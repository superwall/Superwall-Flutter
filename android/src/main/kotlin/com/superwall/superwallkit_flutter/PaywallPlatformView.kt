package com.superwall.superwallkit_flutter

import PPaywallViewCallbackGenerated
import android.content.Context
import android.content.res.Configuration
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.superwall.sdk.Superwall
import com.superwall.sdk.paywall.presentation.get_paywall.builder.PaywallBuilder
import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatusReason
import com.superwall.sdk.paywall.presentation.internal.state.PaywallResult
import com.superwall.sdk.paywall.presentation.internal.state.PaywallSkippedReason
import com.superwall.sdk.paywall.view.PaywallView
import com.superwall.sdk.paywall.view.delegate.PaywallViewCallback
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper
import com.superwall.superwallkit_flutter.utils.pigeonExperiment
import com.superwall.superwallkit_flutter.utils.toPigeon
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.joinAll
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull

class PaywallPlatformViewFactory(
    private val binaryMessenger: BinaryMessenger,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    companion object {
        const val VIEW_TYPE = "superwallkit_flutter/paywall_view"
    }

    override fun create(
        context: Context,
        viewId: Int,
        args: Any?,
    ): PlatformView {
        val creationParams = args as? Map<*, *>
        val hostId = creationParams?.get("hostId") as? String ?: ""
        val params =
            (creationParams?.get("params") as? Map<*, *>)
                ?.mapNotNull { (key, value) ->
                    if (key is String && value != null) key to value else null
                }?.toMap()
        return PaywallPlatformView(
            context = context,
            callback = PPaywallViewCallbackGenerated(binaryMessenger, hostId),
            placement = creationParams?.get("placement") as? String ?: "",
            params = params,
        )
    }
}

/**
 * A platform view that shows one SDK [PaywallView] for one placement and set of params. A change
 * of either on the Dart side creates a new platform view.
 *
 * PaywallView instances are cached and shared by the SDK (keyed by paywall, not placement), so a
 * paywall that was retrieved but never shown is left to the cache. The destructive teardown runs
 * only when a presentation genuinely ends (dismissal or [dispose]), and no platform view retrieves
 * a paywall while a teardown is in flight, because the SDK cache can hand the same instance
 * straight back.
 */
class PaywallPlatformView(
    context: Context,
    private val callback: PPaywallViewCallbackGenerated,
    private val placement: String,
    private val params: Map<String, Any>?,
) : PlatformView {
    private companion object {
        // Teardown must survive dispose(): cancelling destroyed()/cleanup() mid-flight would
        // leave the shared cached PaywallView half torn down. The jobs are shared by every
        // platform view, since the one replacing a disposed view can be handed the same paywall.
        // Only touched on the main thread.
        val teardownScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
        val teardownJobs = mutableSetOf<Job>()

        // How long to wait for the platform view a paywall is still attached to to be disposed.
        const val REPLACED_VIEW_TIMEOUT_MILLIS = 1000L
    }

    private val loadScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    private val disposed = CompletableDeferred<Unit>()
    private var loadGeneration = 0

    // The paywall on screen.
    private var paywallView: PaywallView? = null

    // A retrieved paywall waiting for the host to be attached to a window.
    private var pendingPaywallView: PaywallView? = null

    private val host = HostLayout(context)

    private val delegate =
        object : PaywallViewCallback {
            override fun onFinished(
                paywall: PaywallView,
                result: PaywallResult,
                shouldDismiss: Boolean,
            ) {
                if (paywall !== paywallView) return

                callback.onFinished(
                    PaywallInfoMapper.toPPaywallInfo(paywall.info),
                    result.toPigeon(),
                    shouldDismiss,
                ) {}

                if (shouldDismiss) {
                    teardownPaywall()
                }
            }
        }

    init {
        loadPaywall()
    }

    override fun getView(): View = host

    override fun dispose() {
        loadGeneration += 1
        pendingPaywallView = null
        teardownPaywall()
        loadScope.cancel()
        disposed.complete(Unit)
    }

    /**
     * Retrieval starts at creation rather than when the host is attached to a window: Flutter
     * attaches the host at different times depending on the composition mode and can detach and
     * reattach it, while creation and [dispose] happen exactly once. The paywall is only added,
     * and its presentation only begun, once the host is in a window.
     */
    private fun loadPaywall() {
        val generation = loadGeneration
        callback.onLoadStart {}

        if (!Superwall.initialized) {
            callback.onError("Superwall must be configured before a PaywallView is shown.") {}
            return
        }
        val activity = SuperwallkitFlutterPlugin.currentActivity
        if (activity == null) {
            callback.onError("No current Activity is available to load the paywall.") {}
            return
        }

        loadScope.launch {
            var hasWaitedForReplacedView = false
            while (true) {
                // Never acquire from the SDK cache while a previous instance is still tearing
                // down: the builder can return that same instance.
                while (teardownJobs.isNotEmpty()) {
                    teardownJobs.toList().joinAll()
                    teardownJobs.removeAll { it.isCompleted }
                }
                if (generation != loadGeneration) return@launch

                val result =
                    PaywallBuilder(placement)
                        .params(params)
                        .delegate(delegate)
                        .activity(activity)
                        .build()

                // Stale result. The view belongs to the SDK cache; leave it for the next
                // acquisition.
                if (generation != loadGeneration) return@launch

                val paywall = result.getOrNull()
                val currentHost = paywall?.parent as? HostLayout
                if (currentHost != null && !hasWaitedForReplacedView) {
                    // The paywall is still shown by a platform view this one may be replacing,
                    // whose dispose hasn't arrived yet. Wait for it, then retrieve again.
                    hasWaitedForReplacedView = true
                    withTimeoutOrNull(REPLACED_VIEW_TIMEOUT_MILLIS) { currentHost.owner.disposed.await() }
                    continue
                }

                result.fold(
                    onSuccess = { showPaywall(it) },
                    onFailure = { error ->
                        if (error is PaywallSkippedReason) {
                            callback.onSkip(error.toPigeon(), error.pigeonExperiment()) {}
                        } else {
                            val message =
                                if (error is PaywallPresentationRequestStatusReason) {
                                    error.info
                                } else {
                                    error.localizedMessage ?: error.toString()
                                }
                            callback.onError(message) {}
                        }
                    },
                )
                return@launch
            }
        }
    }

    private fun showPaywall(paywall: PaywallView) {
        if (paywall.parent != null) {
            callback.onError(
                "The retrieved paywall is already attached to another view. " +
                    "Use a different placement for each mounted PaywallView.",
            ) {}
            return
        }
        if (!host.isAttachedToWindow) {
            pendingPaywallView = paywall
            return
        }
        pendingPaywallView = null
        paywallView = paywall
        host.addView(
            paywall,
            FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT),
        )
        paywall.onViewCreated()
        callback.onPresent(PaywallInfoMapper.toPPaywallInfo(paywall.info)) {}
    }

    /** Ends the presentation for real: dismissal or disposal of the platform view. */
    private fun teardownPaywall() {
        val paywall = paywallView ?: return
        paywallView = null
        host.removeView(paywall)
        paywall.beforeOnDestroy(forceCleanup = true)
        paywall.encapsulatingActivity = null
        val job =
            teardownScope.launch {
                paywall.destroyed(forceCleanup = true)
                paywall.cleanup()
            }
        teardownJobs.removeAll { it.isCompleted }
        if (!job.isCompleted) teardownJobs.add(job)
    }

    private inner class HostLayout(
        context: Context,
    ) : FrameLayout(context) {
        val owner: PaywallPlatformView get() = this@PaywallPlatformView

        private var lastUiMode = resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK

        override fun onAttachedToWindow() {
            super.onAttachedToWindow()
            // Another platform view can have been given the paywall while this one waited.
            pendingPaywallView?.let { showPaywall(it) }
        }

        override fun onConfigurationChanged(newConfig: Configuration?) {
            super.onConfigurationChanged(newConfig)
            val uiMode = (newConfig ?: resources.configuration).uiMode and Configuration.UI_MODE_NIGHT_MASK
            if (uiMode != lastUiMode) {
                lastUiMode = uiMode
                paywallView?.takeIf { it.state.isPresented }?.onThemeChanged()
            }
        }
    }
}
