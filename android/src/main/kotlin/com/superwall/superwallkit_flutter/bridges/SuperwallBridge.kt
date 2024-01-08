package com.superwall.superwallkit_flutter.bridges

import android.app.Activity
import android.content.Context
import com.superwall.sdk.Superwall
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.delegate.subscription_controller.PurchaseController
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.net.Uri
import com.android.billingclient.api.Purchase
import com.superwall.sdk.misc.ActivityProvider
import com.superwall.sdk.misc.runOnUiThread
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.sdk.paywall.presentation.register
import com.superwall.superwallkit_flutter.BridgingCreator
import com.superwall.superwallkit_flutter.SuperwallkitFlutterPlugin
import com.superwall.superwallkit_flutter.argumentForKey
import com.superwall.superwallkit_flutter.badArgs
import com.superwall.superwallkit_flutter.bridgeInstance
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SuperwallBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), ActivityProvider {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setDelegate" -> {
                val delegateProxyBridge = call.bridgeInstance<SuperwallDelegate?>("delegateProxyBridgeId")
                delegateProxyBridge?.let {
                    Superwall.instance.delegate = it
                } ?: run {
                    result.badArgs(call)
                }

                result.success(null)
            }
            "getLogLevel" -> {
                // TODO
//                val logLevel = Superwall.instance.logLevel
//                result.success(logLevel.ordinal)
                result.notImplemented()
            }
            "setLogLevel" -> {
                // TODO
//                val levelOrdinal = call.argumentForKey<Int>("logLevel")
//                levelOrdinal?.let {
//                    val logLevel = LogLevel.values()[it]
//                    Superwall.instance.logLevel = logLevel
//                }
//                result.success(null)
                result.notImplemented()
            }
            "getUserAttributes" -> {
                // TODO: Fix IdentityManager class in Android
//                val attributes = Superwall.instance.getUserAttributes()
//                result.success(attributes)
                result.notImplemented()
            }
            "getUserId" -> {
                // TODO: Add to Android
//                val userId = Superwall.instance.userId
//                result.success(userId)
                result.notImplemented()
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
                } ?: run {
                    result.badArgs(call)
                }

                result.success(null)
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
                } ?: run {
                    result.badArgs(call)
                }
                result.success(null)
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

                    val options: SuperwallOptions? = call.argument("options")

                    Superwall.configure(
                        applicationContext = this@SuperwallBridge.context,
                        apiKey = apiKey,
                        purchaseController = purchaseControllerProxyBridge,
                        options = options,
                        activityProvider = this@SuperwallBridge
                    )

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

                    val handlerProxyBridge = call.bridgeInstance<PaywallPresentationHandlerProxyBridge?>("handlerProxyBridgeId")
                    val handler: PaywallPresentationHandler? = handlerProxyBridge?.handler

                    Superwall.instance.register(event, params, handler) {
                        val featureBlockProxyBridge = call.bridgeInstance<CompletionBlockProxyBridge>("featureBlockProxyBridgeId")
                        featureBlockProxyBridge?.let {
                            it.callCompletionBlock()
                        }
                    }
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