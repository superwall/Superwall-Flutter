package com.superwall.superwallkit_flutter

import android.app.Activity
import com.superwall.sdk.Superwall
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.delegate.subscription_controller.PurchaseController
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.net.Uri
import com.superwall.sdk.delegate.SubscriptionStatus
import com.superwall.sdk.misc.ActivityProvider

class SuperwallPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityProvider {
    private lateinit var channel: MethodChannel
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "SWK_SuperwallBridge")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDelegate" -> {
                val delegate = Superwall.instance.delegate
                result.success(delegate)
            }
            "setDelegate" -> {
                val delegate = call.argumentForKey<SuperwallDelegate?>("delegate")
                Superwall.instance.delegate = delegate
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
            "getSubscriptionStatus" -> {
                val statusStateFlow = Superwall.instance.subscriptionStatus
                val status = statusStateFlow.value
                result.success(status.rawValue)
            }
            "setSubscriptionStatus" -> {
                val statusRawValue = call.argumentForKey<Int>("status")
                statusRawValue?.let {
                    val status = SubscriptionStatus.fromRawValue(statusRawValue)
                    Superwall.instance.setSubscriptionStatus(status)
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
                        result.error("URI_PARSE_ERROR", "Error parsing URL: ${e.message}", null)
                    }
                } ?: run {
                    // urlString is null
                    result.error("INVALID_URL", "URL is null", null)
                }
            }
            "togglePaywallSpinner" -> {
                val isHidden = call.argumentForKey<Boolean>("isHidden")
                isHidden?.let {
                    Superwall.instance.togglePaywallSpinner(isHidden = it)
                }
                result.success(null)
            }
            "reset" -> {
                Superwall.instance.reset()
                result.success(null)
            }
            "configure" -> {
                val apiKey = call.argumentForKey<String>("apiKey_android")
                apiKey?.let {
                    // TODO: need primitives for purchase controller and options
                    val purchaseController = call.argumentForKey<PurchaseController?>("purchaseController")
                    val options = call.argumentForKey<SuperwallOptions?>("options")
                    Superwall.configure(flutterPluginBinding.applicationContext, apiKey = it, purchaseController = purchaseController, options = options, activityProvider = this)
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun getCurrentActivity(): Activity? {
        return SuperwallkitFlutterPlugin.currentActivity
    }
}