package com.superwall.superwallkit_flutter

import PActive
import PConfigurationStatus
import PConfigureCompletionGenerated
import PConfigureCompletionHost
import PConfirmedAssignment
import PEntitlement
import PExperiment
import PEntitlements
import PFeatureHandlerGenerated
import PFeatureHandlerHost
import PIdentityOptions
import PInactive
import PPaywallInfo
import PPaywallPresentationHandlerGenerated
import PPaywallPresentationHandlerHost
import PPresentationResult
import PPlacementNotFoundPresentationResult
import PNoAudienceMatchPresentationResult
import PPaywallPresentationResult
import PHoldoutPresentationResult
import PPaywallNotAvailablePresentationResult
import PPurchaseControllerGenerated
import PPurchaseControllerHost
import PRestorationFailed
import PRestorationRestored
import PRestorationResult
import PSubscriptionStatus
import PSuperwallDelegateGenerated
import PSuperwallHostApi
import PSuperwallHostApi.Companion.setUp
import PSuperwallOptions
import PUnknown
import PVariant
import PVariantType
import PigeonEventSink
import StreamSubscriptionStatusStreamHandler
import android.app.Activity
import android.app.Application
import com.superwall.sdk.Superwall
import com.superwall.sdk.config.models.ConfigurationStatus
import com.superwall.sdk.identity.IdentityOptions
import com.superwall.sdk.identity.identify
import com.superwall.sdk.identity.setUserAttributes
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.models.triggers.Experiment
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.superwallkit_flutter.json.JsonExtensions
import com.superwall.superwallkit_flutter.utils.toSdkOptions
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import logLevelFromJson
import toJson
import androidx.core.net.toUri
import com.superwall.sdk.paywall.presentation.register
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import android.util.Log
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.delegate.RestorationResult
import com.superwall.sdk.logger.LogLevel
import com.superwall.sdk.misc.ActivityProvider
import com.superwall.sdk.paywall.presentation.get_presentation_result.getPresentationResult
import com.superwall.sdk.paywall.presentation.result.PresentationResult
import com.superwall.superwallkit_flutter.utils.SubscriptionStatusMapper.fromPigeon
import com.superwall.superwallkit_flutter.utils.SubscriptionStatusMapper.toPigeon
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.collectLatest

class SuperwallHost(
    val context: () -> Application,
    val binaryMessenger: () -> BinaryMessenger
) : PSuperwallHostApi, StreamSubscriptionStatusStreamHandler() {

    init {
        setUp(binaryMessenger = binaryMessenger(), this)
        register(binaryMessenger(), this)
    }

    private val mainScope = CoroutineScope(Dispatchers.Main)
    private val ioScope = CoroutineScope(Dispatchers.IO)
    private var latestStreamJob: Job? = null
    override fun configure(
        apiKey: String,
        purchaseController: PPurchaseControllerHost?,
        options: PSuperwallOptions?,
        completion: PConfigureCompletionHost?,
        callback: (Result<Unit>) -> Unit,
    ) {
        val sdkOptions = (options?.toSdkOptions() ?: SuperwallOptions()).apply {
            logging.level = LogLevel.debug
        }
        Superwall.configure(
            applicationContext = context().applicationContext as Application,
            apiKey = apiKey,
            options = sdkOptions,
            purchaseController = if (purchaseController != null) {
                PurchaseControllerHost { PPurchaseControllerGenerated(binaryMessenger()) }
            } else null,
            activityProvider = object : ActivityProvider {
                override fun getCurrentActivity(): Activity? {
                    return SuperwallkitFlutterPlugin.currentActivity
                }
            },
            completion = if (completion != null) {
                { result: Result<Unit> ->
                    PConfigureCompletionGenerated(binaryMessenger()).onConfigureCompleted(
                        result.isSuccess,
                        {})
                }
            } else null
        )
    }

    override fun reset() {
        Superwall.instance.reset()
    }

    override fun setDelegate(hasDelegate: Boolean) {
        Superwall.instance.delegate =
            if (hasDelegate)
                SuperwallDelegateHost({
                    PSuperwallDelegateGenerated(binaryMessenger())
                }) else null
    }

    override fun confirmAllAssignments(callback: (Result<List<PConfirmedAssignment>>) -> Unit) {
        ioScope.launch {
            callback(Superwall.instance.confirmAllAssignments().map {
                it.map {
                    PConfirmedAssignment(it.experimentId, it.variant.let {
                        PVariant(
                            id = it.id, paywallId = it.paywallId, type =
                                when (it.type) {
                                    Experiment.Variant.VariantType.TREATMENT -> PVariantType.TREATMENT
                                    Experiment.Variant.VariantType.HOLDOUT -> PVariantType.HOLDOUT
                                }
                        )
                    })
                }
            })
        }
    }

    override fun getLogLevel(): String {
        return Superwall.instance.logLevel.toJson()
    }

    override fun setLogLevel(logLevel: String) {
        JsonExtensions.logLevelFromJson(logLevel)?.let {
            Superwall.instance.logLevel = it
        }
    }

    override fun getUserAttributes(): Map<String, Any> {
        return Superwall.instance.userAttributes
    }

    override fun setUserAttributes(userAttributes: Map<String, Any>) {
        Superwall.instance.setUserAttributes(userAttributes)
    }

    override fun getDeviceAttributes(callback: (Result<Map<String, Any>>) -> Unit) {
        ioScope.launch {
            val unfiltered: Map<String, Any?> = Superwall.instance.deviceAttributes()
            val attributes: Map<String, Any> = unfiltered.filterNot {
                it.value == null
            }.toMap() as Map<String, Any>
            callback(Result.success(attributes))
        }
    }

    override fun getLocaleIdentifier(): String? {
        return Superwall.instance.localeIdentifier
    }

    override fun setLocaleIdentifier(localeIdentifier: String?) {
        Superwall.instance.localeIdentifier = localeIdentifier
    }

    override fun getUserId(): String {
        return Superwall.instance.userId
    }

    override fun getIsLoggedIn(): Boolean {
        return Superwall.instance.isLoggedIn
    }

    override fun getIsInitialized(): Boolean {
        return Superwall.initialized;
    }

    override fun identify(userId: String, identityOptions: PIdentityOptions?) {
        Superwall.instance.identify(userId, options = identityOptions?.let {
            IdentityOptions(
                (it.restorePaywallAssignments == true)
            )
        })
    }

    override fun getEntitlements(): PEntitlements {
        return PEntitlements(
            active = Superwall.instance.entitlements.active.map {
                PEntitlement(it.id)
            }, inactive = Superwall.instance.entitlements.inactive.map {
                PEntitlement(it.id)
            }, all = Superwall.instance.entitlements.all.map {
                PEntitlement(it.id)
            })
    }


    override fun getSubscriptionStatus(): PSubscriptionStatus {
        return Superwall.instance.subscriptionStatus.value.toPigeon()
    }

    override fun setSubscriptionStatus(subscriptionStatus: PSubscriptionStatus) {
        Superwall.instance.setSubscriptionStatus(
            subscriptionStatus.fromPigeon()
        )
    }

    override fun getConfigurationStatus(): PConfigurationStatus {
        return Superwall.instance.configurationState.let {
            when (it) {
                ConfigurationStatus.Configured -> PConfigurationStatus.CONFIGURED
                ConfigurationStatus.Failed -> PConfigurationStatus.FAILED
                ConfigurationStatus.Pending -> PConfigurationStatus.PENDING
            }
        }
    }

    override fun getIsConfigured(): Boolean {
        return Superwall.instance.configurationState is ConfigurationStatus.Configured
    }

    override fun getIsPaywallPresented(): Boolean {
        return Superwall.instance.isPaywallPresented
    }

    override fun preloadAllPaywalls() {
        Superwall.instance.preloadAllPaywalls()
    }

    override fun preloadPaywallsForPlacements(placementNames: List<String>) {
        Superwall.instance.preloadPaywalls(placementNames.toSet())
    }

    override fun handleDeepLink(url: String): Boolean {
        return Superwall.handleDeepLink(url.toUri()).getOrNull() ?: false
    }

    override fun togglePaywallSpinner(isHidden: Boolean) {
        Superwall.instance.togglePaywallSpinner(isHidden)
    }

    override fun getLatestPaywallInfo(): PPaywallInfo? {
        return Superwall.instance.latestPaywallInfo?.let {
            PaywallInfoMapper.toPPaywallInfo(it)
        }
    }

    override fun getPresentationResult(
        placement: String,
        params: Map<String, Any>?,
        callback: (Result<PPresentationResult>) -> Unit
    ) {
        fun toPExperiment(experiment: Experiment) =
            PExperiment(
                id = experiment.id,
                groupId = experiment.groupId,
                variant = PVariant(
                    id = experiment.variant.id,
                    type = when (experiment.variant.type) {
                        Experiment.Variant.VariantType.TREATMENT -> PVariantType.TREATMENT
                        else -> PVariantType.HOLDOUT
                    },
                    paywallId = experiment.variant.paywallId
                )
            )

        ioScope.launch {
            Superwall.instance.getPresentationResult(placement, params).fold({
                when (it) {
                    is PresentationResult.PlacementNotFound -> PPlacementNotFoundPresentationResult(
                        false
                    )

                    is PresentationResult.NoAudienceMatch -> PNoAudienceMatchPresentationResult(
                        false
                    )

                    is PresentationResult.Paywall -> PPaywallPresentationResult(
                        toPExperiment(it.experiment)
                    )

                    is PresentationResult.Holdout -> PHoldoutPresentationResult(
                        toPExperiment(it.experiment)
                    )

                    is PresentationResult.PaywallNotAvailable -> PPaywallNotAvailablePresentationResult(
                        false
                    )

                }.let {
                    callback(Result.success(it))
                }
            }, {
                callback(Result.failure(it))
            })
        }
    }

    override fun registerPlacement(
        placement: String,
        params: Map<String, Any>?,
        handler: PPaywallPresentationHandlerHost?,
        feature: PFeatureHandlerHost?,
        callback: (Result<Unit>) -> Unit
    ) {
        val host = if (handler != null) PaywallPresentationHandlerHost({
            PPaywallPresentationHandlerGenerated(binaryMessenger(), placement)
        }) else null

        Superwall.instance.register(
            placement, params, host?.handler, if (feature != null) {
                {
                    PFeatureHandlerGenerated(binaryMessenger(), placement).onFeature(
                        feature.hostId ?: "", {}
                    )
                }
            } else null
        )
        callback(Result.success(Unit))
    }

    override fun dismiss() {
        ioScope.launch {
            Superwall.instance.dismiss()
        }
    }

    override fun onListen(p0: Any?, sink: PigeonEventSink<PSubscriptionStatus>) {
        latestStreamJob = ioScope.launch {
            Superwall.instance.subscriptionStatus.collectLatest {
                mainScope.launch {
                    sink.success(it.toPigeon())
                }
            }
        }
    }

    override fun onCancel(p0: Any?) {
        latestStreamJob?.cancel()
    }

    override fun restorePurchases(callback: (Result<PRestorationResult>) -> Unit) {
        ioScope.launch {
            val res = Superwall.instance.restorePurchases().map {
                when (it) {
                    is RestorationResult.Restored -> PRestorationRestored()
                    is RestorationResult.Failed -> PRestorationFailed(
                        it.error?.localizedMessage ?: "Unknown error"
                    )
                }
            }
            callback(res)
        }
    }
}