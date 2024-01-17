package com.superwall.superwallkit_flutter.bridges

import LogLevel
import android.app.Activity
import android.content.Context
import com.superwall.sdk.Superwall
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.delegate.SuperwallDelegate
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.net.Uri
import com.superwall.sdk.delegate.SubscriptionStatus
import com.superwall.sdk.identity.IdentityOptions
import com.superwall.sdk.identity.identify
import com.superwall.sdk.identity.setUserAttributes
import com.superwall.sdk.misc.ActivityProvider
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.sdk.paywall.presentation.register
import com.superwall.superwallkit_flutter.BreadCrumbs
import com.superwall.superwallkit_flutter.SuperwallkitFlutterPlugin
import com.superwall.superwallkit_flutter.argumentForKey
import com.superwall.superwallkit_flutter.badArgs
import com.superwall.superwallkit_flutter.bridgeInstance
import com.superwall.superwallkit_flutter.json.JsonExtensions
import com.superwall.superwallkit_flutter.json.identityOptionsFromJson
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import logLevelFromJson
import superwallOptionsFromJson
import toJson

class SuperwallBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), ActivityProvider {
    companion object { fun bridgeClass(): BridgeClass = "SuperwallBridge" }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setDelegate" -> {
                val delegateProxyBridge = call.bridgeInstance<SuperwallDelegate?>("delegateProxyBridgeId")
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
                val logLevel = logLevelJson?.let { JsonExtensions.Companion.logLevelFromJson(it) }

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
            "getUserId" -> {
                // Implement logic to get the current user's id
                // TODO: Add this once fixed in Android SDK
//                result.success(Superwall.instance.userId)
                result.success("")
            }
            "getIsLoggedIn" -> {
                // TODO: Add to Android
//                val isLoggedIn = Superwall.instance.isLoggedIn
//                result.success(isLoggedIn)
                result.notImplemented()
            }
            "getPresentedViewController" -> {
                // TODO: Since UIViewController cannot be returned directly to Dart, handle appropriately
//                val viewController = Superwall.instance.presentedViewController
//                result.success(viewController?.description)
                result.notImplemented()
            }
            "getLatestPaywallInfo" -> {
                // TODO: Convert PaywallInfo to a format suitable for passing over method channels
//                val paywallInfo = Superwall.instance.latestPaywallInfo
//                result.success(paywallInfo?.toMap())
                result.notImplemented()
            }
            "getSubscriptionStatusBridgeId" -> {
                val subscriptionStatusBridgeId = Superwall.instance.subscriptionStatus.value.createBridgeId()
                result.success(subscriptionStatusBridgeId)
            }
            "setSubscriptionStatus" -> {
                val subscriptionStatusBridge = call.bridgeInstance<SubscriptionStatusBridge>("subscriptionStatusBridgeId")
                subscriptionStatusBridge?.let {
                    Superwall.instance.setSubscriptionStatus(it.status)

                    val updatedValue = Superwall.instance.subscriptionStatus.value;
                    val valid = (updatedValue == SubscriptionStatus.ACTIVE || updatedValue == SubscriptionStatus.INACTIVE) && (updatedValue != SubscriptionStatus.UNKNOWN);
                    result.success(mapOf(
                        "providedStatus" to it.status.toString(),
                        "updatedValue" to updatedValue.toString(),
                        "valid" to valid
                    ))

                } ?: run {
                    result.badArgs(call)
                }
            }
            "getIsConfigured" -> {
                // TODO: Add to Android
//                val isConfigured = Superwall.instance.isConfigured
//                result.success(isConfigured)
                result.notImplemented()
            }
            "setIsConfigured" -> {
                // TODO: Add to Android
//                val configured = call.argumentForKey<Boolean>("configured")
//                configured?.let {
//                    Superwall.instance.isConfigured = it
//                }
//                result.success(null)
                result.notImplemented()
            }
            "getIsPaywallPresented" -> {
                val isPaywallPresented = Superwall.instance.isPaywallPresented
                result.success(isPaywallPresented)
            }
            "preloadAllPaywalls" -> {
                // TODO: Add to Android
//                Superwall.instance.preloadAllPaywalls()
//                result.success(null)
                result.notImplemented()
            }
            "preloadPaywallsForEvents" -> {
                // TODO: Add to Android
//                val eventNames = call.argumentForKey<List<String>>("eventNames")?.toSet()
//                eventNames?.let {
//                    Superwall.instance.preloadPaywalls(forEvents: it)
//                }
//                result.success(null)
                result.notImplemented()
            }
            "handleDeepLink" -> {
                val urlString = call.argument<String>("url")
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

                    val options: SuperwallOptions? = call.argument<Map<String, Any>>("options")?.let { optionsValue ->
                        JsonExtensions.Companion.superwallOptionsFromJson(optionsValue)
                    }

                    Superwall.configure(
                        applicationContext = this@SuperwallBridge.context,
                        apiKey = apiKey,
                        purchaseController = purchaseControllerProxyBridge,
                        options = options,
                        activityProvider = this@SuperwallBridge
                    )

                    // Set the platform wrapper
                    Superwall.instance.setPlatformWrapper("Flutter");

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
            "registerEvent" -> {
                val event = call.argument<String>("event")
                event?.let { event ->
                    val params = call.argument<Map<String, Any>>("params")

                    BreadCrumbs.append("SuperwallBridge.kt: Invoke registerEvent")
                    val handlerProxyBridge = call.bridgeInstance<PaywallPresentationHandlerProxyBridge?>("handlerProxyBridgeId")
                    BreadCrumbs.append("SuperwallBridge.kt: Found handlerProxyBridge instance: $handlerProxyBridge")

                    val handler: PaywallPresentationHandler? = handlerProxyBridge?.handler
                    BreadCrumbs.append("SuperwallBridge.kt: Found handler: $handler")

                    Superwall.instance.register(event, params, handler) {
                        val featureBlockProxyBridge = call.bridgeInstance<CompletionBlockProxyBridge>("featureBlockProxyBridgeId")
                        featureBlockProxyBridge?.let {
                            it.callCompletionBlock()
                        }
                    }
                    result.success(true)
                } ?: run {
                    result.badArgs(call)
                }
            }

            "identify" -> {
                val userId = call.argument<String>("userId")
                userId?.let {
                    val identityOptionsJson = call.argument<Map<String, Any?>>("identityOptions")
                    val identityOptions = identityOptionsJson?.let { JsonExtensions.Companion.identityOptionsFromJson(it) }

                    Superwall.instance.identify(userId, identityOptions)
                    result.success(null)
                } ?: run {
                    result.badArgs(call)
                }
            }

            else -> result.notImplemented()
        }
    }

    override fun getCurrentActivity(): Activity? {
        return SuperwallkitFlutterPlugin.currentActivity
    }
}