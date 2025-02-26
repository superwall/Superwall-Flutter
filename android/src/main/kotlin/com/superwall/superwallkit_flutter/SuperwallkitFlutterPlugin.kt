package com.superwall.superwallkit_flutter

import android.app.Activity
import android.app.Application
import android.net.Uri
import android.os.Debug
import com.superwall.sdk.Superwall
import com.superwall.sdk.config.models.ConfigurationStatus
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.identity.identify
import com.superwall.sdk.identity.setUserAttributes
import com.superwall.sdk.logger.LogLevel
import com.superwall.sdk.misc.ActivityProvider
import com.superwall.sdk.misc.runOnUiThread
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.sdk.paywall.presentation.register
import com.superwall.superwallkit_flutter.bridges.*
import com.superwall.superwallkit_flutter.json.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import superwallOptionsFromJson
import toJson
import java.util.WeakHashMap
import java.util.concurrent.atomic.AtomicInteger
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class SuperwallkitFlutterPlugin : FlutterPlugin, ActivityAware, MethodCallHandler, ActivityProvider {
    var currentAttachedActivity: Activity? = null

    companion object {
        private var instance: SuperwallkitFlutterPlugin? = null
        val reattachementCount = AtomicInteger(0)
        val activityReattachementCount = AtomicInteger(0)

        val currentActivity: Activity?
            get() = instance?.currentAttachedActivity
    }

    private var methodChannel: MethodChannel? = null

    init {
        if (BuildConfig.DEBUG && BuildConfig.WAIT_FOR_DEBUGGER) {
            Debug.waitForDebugger()
        }

        // Only allow instance to get set once.
        if (instance == null) {
            instance = this
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        executor {
            command<Void>("setDelegate") {
                val delegateProxyBridge = call.bridgeInstance<SuperwallDelegate?>("delegateProxyBridgeId")
                delegateProxyBridge?.let {
                    Superwall.instance.delegate = it
                    result.success(null)
                } ?: run {
                    result.badArgs(call)
                }
            }
            command<Void>("getLogLevel") {
                val logLevel = Superwall.instance.logLevel
                result.success(logLevel.toJson())
            }
            command<StringCommandArguments>("setLogLevel") {
                Superwall.instance.logLevel = LogLevel.valueOf(it.value)
                result.success(null)
            }
            command<Void>("getUserAttributes") {
                val attributes = Superwall.instance.userAttributes
                result.success(attributes)
            }
            command<MapCommandArguments>("setUserAttributes") {
                Superwall.instance.setUserAttributes(it.map)
                result.success(null)
            }
            command<Void>("getLocaleIdentifier") {
                val identifier = Superwall.instance.localeIdentifier
                result.success(identifier)
            }
            command<StringCommandArguments>("setLocaleIdentifier") {
                Superwall.instance.localeIdentifier = it.value
                result.success(null)
            }
            command<Void>("getUserId") {
                val userId = Superwall.instance.userId
                result.success(userId)
            }
            command<Void>("getIsLoggedIn") {
                val isLoggedIn = Superwall.instance.isLoggedIn
                result.success(isLoggedIn)
            }
            command<Void>("getIsInitialized") {
                val isInitialized = Superwall.initialized
                result.success(isInitialized)
            }
            command<Void>("getLatestPaywallInfoBridgeId") {
                val paywallInfo = Superwall.instance.latestPaywallInfo
                result.success(paywallInfo?.createBridgeId())
            }
            command<Void>("getSubscriptionStatusBridgeId") {
                val subscriptionStatusBridgeId = Superwall.instance.subscriptionStatus.value.createBridgeId()
                result.success(subscriptionStatusBridgeId)
            }
            command<MapCommandArguments>("setSubscriptionStatus") {
                val subscriptionStatusBridge = call.bridgeInstance<SubscriptionStatusBridge>("subscriptionStatusBridgeId")
                subscriptionStatusBridge?.let {
                    Superwall.instance.setSubscriptionStatus(it.status)
                    val updatedValue = Superwall.instance.subscriptionStatus.value
                    val valid = (updatedValue is SubscriptionStatus.Active || updatedValue is SubscriptionStatus.Inactive) && (updatedValue !is SubscriptionStatus.Unknown)
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
            command<Void>("getConfigurationStatusBridgeId") {
                val configurationStatus = Superwall.instance.configurationState
                val json = when(Superwall.instance.configurationState){
                    ConfigurationStatus.Configured -> "configured"
                    ConfigurationStatus.Failed -> "failed"
                    ConfigurationStatus.Pending -> "pending"
                }
                result.success(json)
            }
            command<Void>("getIsPaywallPresented") {
                val isPaywallPresented = Superwall.instance.isPaywallPresented
                result.success(isPaywallPresented)
            }
            command<Void>("preloadAllPaywalls") {
                Superwall.instance.preloadAllPaywalls()
                result.success(null)
            }
            command<MapCommandArguments>("preloadPaywallsForPlacements") {
                val placementNames = call.argumentForKey<List<String>>("placementNames")?.toSet()
                placementNames?.let {
                    Superwall.instance.preloadPaywalls(placementNames)
                }
                result.success(null)
            }
            command<MapCommandArguments>("handleDeepLink") {
                val urlString = call.argumentForKey<String>("url")
                urlString?.let {
                    try {
                        val uri = Uri.parse(it)
                        val handled = Superwall.instance.handleDeepLink(uri)
                        result.success(handled)
                    } catch (e: Exception) {
                        result.badArgs(call)
                    }
                } ?: run {
                    result.badArgs(call)
                }
            }
            command<MapCommandArguments>("togglePaywallSpinner") {
                val isHidden = call.argumentForKey<Boolean>("isHidden")
                isHidden?.let {
                    Superwall.instance.togglePaywallSpinner(isHidden = it)
                    result.success(null)
                } ?: run {
                    result.badArgs(call)
                }
            }
            command<Void>("reset") {
                Superwall.instance.reset()
                result.success(null)
            }
            command<MapCommandArguments>("configure") {
                val apiKey: String = it.map["apiKey"] as String
                apiKey?.let { apiKey ->
                    val purchaseControllerProxyBridge = call.bridgeInstance<PurchaseControllerProxyBridge?>("purchaseControllerProxyBridgeId")
                    val options: SuperwallOptions? = call.argument<Map<String, Any>>("options")?.let { optionsValue ->
                        JsonExtensions.superwallOptionsFromJson(optionsValue)
                    }

                    Superwall.configure(
                        applicationContext = currentAttachedActivity?.applicationContext as Application,
                        apiKey = apiKey,
                        purchaseController = purchaseControllerProxyBridge,
                        options = options,
                        activityProvider = this@SuperwallkitFlutterPlugin,
                        completion = {
                            scope.launch {
                                methodChannel?.invokeMethodOnMain("callCompletionBlock", null)
                            }
                        }
                    )

                    Superwall.instance.setPlatformWrapper(
                        "Flutter",
                        call.argumentForKey<String>("sdkVersion") ?: ""
                    )

                    result.success(null)
                } ?: run {
                    result.badArgs(call.method)
                }
            }
            command<Void>("dismiss") {
                CoroutineScope(Dispatchers.Main).launch {
                    Superwall.instance.dismiss()
                    result.success(null)
                }
            }
            command<MapCommandArguments>("registerPlacement") {
                val placement = call.argumentForKey<String>("placement")
                placement?.let { placement ->
                    val params = call.argument<Map<String, Any>>("params")
                    BreadCrumbs.append("SuperwallBridge.kt: Invoke registerPlacement")
                    val handlerProxyBridge = call.bridgeInstance<PaywallPresentationHandlerProxyBridge?>("handlerProxyBridgeId")
                    BreadCrumbs.append("SuperwallBridge.kt: Found handlerProxyBridge instance: $handlerProxyBridge")

                    val handler: PaywallPresentationHandler? = handlerProxyBridge?.handler
                    BreadCrumbs.append("SuperwallBridge.kt: Found handler: $handler")

                    Superwall.instance.register(placement, params, handler) {
                        scope.launch {
                            methodChannel?.invokeMethodOnMain("callCompletionBlock", null)
                        }
                    }
                    result.success(true)
                } ?: run {
                    result.badArgs(call)
                }
            }
            command<MapCommandArguments>("identify") {
                val userId = call.argumentForKey<String>("userId")
                userId?.let {
                    val identityOptionsJson = call.argument<Map<String, Any?>>("identityOptions")
                    val identityOptions = identityOptionsJson?.let { JsonExtensions.identityOptionsFromJson(it) }

                    Superwall.instance.identify(userId, identityOptions)
                    result.success(null)
                } ?: run {
                    result.badArgs(call)
                }
            }
            command<Void>("confirmAllAssignments") {
                CoroutineScope(Dispatchers.IO).launch {
                    Superwall.instance.confirmAllAssignments()
                        .fold({
                            result.success(it.map { it.toJson() })
                        }, {
                            result.badArgs(call)
                        })
                }
            }
            command<Void>("getEntitlements") {
                val entitlements = Superwall.instance.entitlements
                result.success(entitlements.toJson())
            }
        }
    }


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        if(reattachementCount.get() == 0) {
            flutterPluginBinding.applicationContext.packageName
            methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "mainChannel")
            BridgingCreator.setFlutterPlugin(flutterPluginBinding)
        } else reattachementCount.incrementAndGet()

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if(reattachementCount.get() == 0) {
            BridgingCreator.shared.tearDown()
            instance = null
        } else reattachementCount.decrementAndGet()
    }

    //region ActivityAware

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        if(currentAttachedActivity!=null || activityReattachementCount.get() != 0)
            activityReattachementCount.incrementAndGet()
        else
            currentAttachedActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        currentAttachedActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        currentAttachedActivity = binding.activity
    }

    override fun onDetachedFromActivity() {
        if(activityReattachementCount.get() == 0) {
            currentAttachedActivity = null
        }else activityReattachementCount.decrementAndGet()
    }

    override fun getCurrentActivity(): Activity? = currentAttachedActivity

    //endregion
}

fun <T> MethodCall.argumentForKey(key: String): T? {
    return this.argument(key)
}

// Make sure to provide the key for the bridge (which provides the bridgeId)
suspend fun <T> MethodCall.bridgeInstance(key: String): T? {
    BreadCrumbs.append("SuperwallKitFlutterPlugin.kt: Invoke bridgeInstance(key:) on $this. Key is $key")
    val bridgeId = this.argument<String>(key) ?: return null
    BreadCrumbs.append("SuperwallKitFlutterPlugin.kt: Invoke bridgeInstance(key:) in on $this. Found bridgeId $bridgeId")
    return BridgingCreator.shared.bridgeInstance(bridgeId)
}

suspend fun <T> BridgeId.bridgeInstance(): T? {
    BreadCrumbs.append("SuperwallKitFlutterPlugin.kt: Invoke bridgeInstance() in on $this")
    return BridgingCreator.shared.bridgeInstance(this)
}

fun MethodChannel.Result.badArgs(call: MethodCall) {
    return badArgs(call.method)
}

fun MethodChannel.Result.badArgs(method: String) {
    return error("BAD_ARGS", "Missing or invalid arguments for '$method'", null)
}

fun MethodChannel.invokeMethodOnMain(method: String, arguments: Any? = null) {
    runOnUiThread {
        invokeMethod(method, arguments);
    }
}

suspend fun MethodChannel.asyncInvokeMethodOnMain(method: String, arguments: Any? = null): Any? =
    suspendCancellableCoroutine { continuation ->
        runOnUiThread {
            invokeMethod(method, arguments, object : MethodChannel.Result {
                override fun success(result: Any?) {
                    continuation.resume(result)
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    continuation.resumeWithException(
                        RuntimeException("Error invoking method: $errorCode, $errorMessage")
                    )
                }

                override fun notImplemented() {
                    continuation.resumeWithException(
                        UnsupportedOperationException("Method not implemented: $method")
                    )
                }
            })
        }
    }

fun <T> Map<String, Any?>.argument(key: String): T? {
    return this[key] as? T
}

object MethodChannelAssociations {
    private val bridgeIds = WeakHashMap<MethodChannel, String>()

    fun setBridgeId(methodChannel: MethodChannel, bridgeId: String) {
        bridgeIds[methodChannel] = bridgeId
    }

    fun getBridgeId(methodChannel: MethodChannel): String {
        return bridgeIds[methodChannel]
            ?: throw IllegalStateException("bridgeId must be set at initialization of MethodChannel")
    }
}

fun MethodChannel.setBridgeId(bridgeId: String) {
    MethodChannelAssociations.setBridgeId(this, bridgeId)
}

fun MethodChannel.getBridgeId(): String {
    return MethodChannelAssociations.getBridgeId(this)
}