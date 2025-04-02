package com.superwall.superwallkit_flutter.bridges

import android.app.Activity
import android.app.Application
import android.content.Context
import android.net.Uri
import android.util.Log
import com.superwall.sdk.Superwall
import com.superwall.sdk.analytics.superwall.SuperwallEventInfo
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.identity.identify
import com.superwall.sdk.identity.setUserAttributes
import com.superwall.sdk.misc.ActivityProvider
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.sdk.paywall.presentation.register
import com.superwall.superwallkit_flutter.BreadCrumbs
import com.superwall.superwallkit_flutter.SuperwallkitFlutterPlugin
import com.superwall.superwallkit_flutter.argumentForKey
import com.superwall.superwallkit_flutter.badArgs
import com.superwall.superwallkit_flutter.json.*
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.Job
import logLevelFromJson
import superwallOptionsFromJson
import toJson
/*
class SuperwallBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null,
    val scope: CoroutineScope = CoroutineScope(Dispatchers.IO)
) : BridgeInstance(context, bridgeId, initializationArgs), ActivityProvider {
    companion object {
        fun bridgeClass(): BridgeClass = "SuperwallBridge"
    }

    init {
        val main = CoroutineScope(Dispatchers.Main)
        main.launch {
            events().setStreamHandler(
                BridgeHandler(scope) { eventSink ->
                    // Use the main dispatcher so that events are sent on the UI thread.
                    scope.launch {
                        try {
                            Superwall.instance.subscriptionStatus.collect { status ->
                                main.launch {
                                    eventSink.success(status.toJson())
                                }
                            }
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                }
            )
        }
    }

    internal class BridgeHandler(
        val scope: CoroutineScope,
        val sink: (EventChannel.EventSink) -> Unit
    ) : EventChannel.StreamHandler {
        private var listening: Job? = null
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            listening?.cancel()
            listening = scope.launch {
                sink(events!!)
            }
        }

        override fun onCancel(arguments: Any?) {
            listening?.cancel()
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        scope.launch {
            when (call.method) {
                "setDelegate" -> {
                    val delegateProxyBridge =
                        call.bridgeInstance<SuperwallDelegate?>("delegateProxyBridgeId")
                    delegateProxyBridge?.let {
                        Superwall.instance.delegate = it
                        result.success(null)
                    } ?: run {
                        result.badArgs(call)
                    }
                }

                "getLogLevel" -> {
                    val logLevel = Superwall.instance.logLevel
                    result.success(logLevel.toJson())
                }

                "setLogLevel" -> {
                    val logLevelJson = call.argumentForKey<String>("logLevel")
                    val logLevel = logLevelJson?.let { JsonExtensions.logLevelFromJson(it) }

                    logLevel?.let {
                        Superwall.instance.logLevel = it
                        result.success(null)
                    } ?: run {
                        result.badArgs(call)
                    }
                }

                "getUserAttributes" -> {
                    val attributes = Superwall.instance.userAttributes
                    result.success(attributes)
                }

                "setUserAttributes" -> {
                    val userAttributes = call.argument<Map<String, Any?>>("userAttributes")
                    userAttributes?.let {
                        Superwall.instance.setUserAttributes(userAttributes)
                        result.success(null)
                    } ?: run {
                        result.badArgs(call)
                    }
                }

                "getLocaleIdentifier" -> {
                    val identifier = Superwall.instance.localeIdentifier
                    result.success(identifier)
                }

                "setLocaleIdentifier" -> {
                    val localeIdentifier = call.argument<String?>("localeIdentifier")
                    Superwall.instance.localeIdentifier = localeIdentifier
                    result.success(null)
                }

                "getUserId" -> {
                    // Implement logic to get the current user's id
                    val userId = Superwall.instance.userId
                    result.success(userId)
                }

                "getIsLoggedIn" -> {
                    val isLoggedIn = Superwall.instance.isLoggedIn
                    result.success(isLoggedIn)
                }

                "getIsInitialized" -> {
                    val isInitialized = Superwall.initialized
                    result.success(isInitialized)
                }

                "getPresentedViewController" -> {
                    // TODO: Since UIViewController cannot be returned directly to Dart, handle appropriately
                    result.notImplemented()
                }

                "getLatestPaywallInfoBridgeId" -> {
                    val paywallInfo = Superwall.instance.latestPaywallInfo
                    result.success(paywallInfo?.createBridgeId())
                }

                "getSubscriptionStatusBridgeId" -> {
                    val subscriptionStatusBridgeId =
                        Superwall.instance.subscriptionStatus.value.createBridgeId()
                    result.success(subscriptionStatusBridgeId)
                }

                "setSubscriptionStatus" -> {
                    val subscriptionStatusBridge =
                        call.bridgeInstance<SubscriptionStatusBridge>("subscriptionStatusBridgeId")
                    subscriptionStatusBridge?.let {
                        Superwall.instance.setSubscriptionStatus(it.status)

                        val updatedValue = Superwall.instance.subscriptionStatus.value;
                        val valid =
                            (updatedValue is SubscriptionStatus.Active || updatedValue is SubscriptionStatus.Inactive) && (updatedValue !is SubscriptionStatus.Unknown);
                        result.success(
                            mapOf(
                                "providedStatus" to it.status.toString(),
                                "updatedValue" to updatedValue.toString(),
                                "valid" to valid
                            )
                        )

                    } ?: run {
                        result.badArgs(call)
                    }
                }

                "getConfigurationStatusBridgeId" -> {
                    val configurationStatusBridgeId =
                        Superwall.instance.configurationState.createBridgeId()
                    result.success(configurationStatusBridgeId)
                }

                "getIsConfigured" -> {

                    // TODO: Add to Android
                    //                val isConfigured = Superwall.instance.isConfigured
                    //                result.success(isConfigured)
                    result.notImplemented()
                }


                "getIsPaywallPresented" -> {
                    val isPaywallPresented = Superwall.instance.isPaywallPresented
                    result.success(isPaywallPresented)
                }

                "preloadAllPaywalls" -> {
                    Superwall.instance.preloadAllPaywalls()
                    result.success(null)
                }

                "preloadPaywallsForPlacements" -> {
                    val placementNames =
                        call.argumentForKey<List<String>>("placementNames")?.toSet()
                    placementNames?.let {
                        Superwall.instance.preloadPaywalls(it)
                    }
                    result.success(null)
                }

                "handleDeepLink" -> {
                    val urlString = call.argumentForKey<String>("url")
                    urlString?.let {
                        try {
                            val uri = Uri.parse(it)
                            val handled = Superwall.instance.handleDeepLink(uri)
                            result.success(handled)
                        } catch (e: Exception) {
                            // Handle any other exceptions during parsing
                            result.badArgs(call)
                        }
                    } ?: run {
                        // urlString is null
                        result.badArgs(call)
                    }
                }

                "togglePaywallSpinner" -> {
                    val isHidden = call.argumentForKey<Boolean>("isHidden")
                    isHidden?.let {
                        Superwall.instance.togglePaywallSpinner(isHidden = it)
                        result.success(null)
                    } ?: run {
                        result.badArgs(call)
                    }
                }

                "reset" -> {
                    Superwall.instance.reset()
                    result.success(null)
                }

                "configure" -> {
                    val apiKey = call.argumentForKey<String>("apiKey")
                    apiKey?.let { apiKey ->
                        val purchaseControllerProxyBridge =
                            call.bridgeInstance<PurchaseControllerProxyBridge?>("purchaseControllerProxyBridgeId")

                        val options: SuperwallOptions? =
                            call.argument<Map<String, Any>>("options")?.let { optionsValue ->
                                JsonExtensions.superwallOptionsFromJson(optionsValue)
                            }

                        Superwall.configure(
                            applicationContext = this@SuperwallBridge.context.applicationContext as Application,
                            apiKey = apiKey,
                            purchaseController = purchaseControllerProxyBridge,
                            options = options,
                            activityProvider = this@SuperwallBridge,
                            completion = {
                                scope.launch {

                                    val completionBlockProxyBridge =
                                        call.bridgeInstance<CompletionBlockProxyBridge?>("completionBlockProxyBridgeId")
                                    completionBlockProxyBridge?.callCompletionBlock()
                                }
                            }
                        )

                        // Set the platform wrapper
                        Superwall.instance.setPlatformWrapper(
                            "Flutter",
                            call.argumentForKey<String>("sdkVersion") ?: ""
                        );

                        // Returning nil instead of the result from configure because we want to use the Dart
                        // instance of Superwall, not a native variant
                        result.success(null)
                    } ?: run {
                        result.badArgs(call.method)
                    }
                }

                "dismiss" -> {
                    CoroutineScope(Dispatchers.Main).launch {
                        Superwall.instance.dismiss()
                        result.success(null)
                    }
                }

                "registerPlacement" -> {
                    val placement = call.argumentForKey<String>("placement")
                    placement?.let { placement ->
                        val params = call.argument<Map<String, Any>>("params")
                        BreadCrumbs.append("SuperwallBridge.kt: Invoke registerPlacement")
                        val handlerProxyBridge =
                            call.bridgeInstance<PaywallPresentationHandlerProxyBridge?>("handlerProxyBridgeId")
                        BreadCrumbs.append("SuperwallBridge.kt: Found handlerProxyBridge instance: $handlerProxyBridge")

                        val handler: PaywallPresentationHandler? = handlerProxyBridge?.handler
                        BreadCrumbs.append("SuperwallBridge.kt: Found handler: $handler")

                        Superwall.instance.register(placement, params, handler) {
                            scope.launch {
                                val featureBlockProxyBridge =
                                    call.bridgeInstance<CompletionBlockProxyBridge>("featureBlockProxyBridgeId")
                                featureBlockProxyBridge?.let {
                                    it.callCompletionBlock()
                                }
                            }
                        }
                        result.success(true)
                    } ?: run {
                        result.badArgs(call)
                    }
                }

                "identify" -> {
                    val userId = call.argumentForKey<String>("userId")
                    userId?.let {
                        val identityOptionsJson =
                            call.argument<Map<String, Any?>>("identityOptions")
                        val identityOptions =
                            identityOptionsJson?.let { JsonExtensions.identityOptionsFromJson(it) }

                        Superwall.instance.identify(userId, identityOptions)
                        result.success(null)
                    } ?: run {
                        result.badArgs(call)
                    }
                }

                "confirmAllAssignments" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        Superwall.instance.confirmAllAssignments()
                            .fold({
                                result.success(it.map { it.toJson() })
                            }, {
                                result.badArgs(call)
                            })
                    }
                }

                "getEntitlements" -> {
                    val entitlements = Superwall.instance.entitlements
                    result.success(entitlements.toJson())
                }


                else -> result.notImplemented()
            }
        }
    }

    override fun getCurrentActivity(): Activity? {
        return SuperwallkitFlutterPlugin.currentActivity
    }
}
 */