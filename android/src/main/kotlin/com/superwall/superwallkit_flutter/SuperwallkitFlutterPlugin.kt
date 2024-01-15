package com.superwall.superwallkit_flutter

import android.app.Activity
import android.os.Debug
import com.superwall.sdk.misc.runOnUiThread
import com.superwall.superwallkit_flutter.bridges.BridgeId
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.suspendCancellableCoroutine
import java.util.WeakHashMap
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class SuperwallkitFlutterPlugin: FlutterPlugin, ActivityAware {
  var currentActivity: Activity? = null

  companion object {
    private var instance: SuperwallkitFlutterPlugin? = null

    val currentActivity: Activity?
      get() = instance?.currentActivity
  }

  init {
    if (BuildConfig.DEBUG && BuildConfig.WAIT_FOR_DEBUGGER) {
      Debug.waitForDebugger()
    }

    instance = this
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    BridgingCreator.register(flutterPluginBinding)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}

  //region ActivityAware

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    currentActivity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
  }

  override fun onDetachedFromActivity() {
    currentActivity = null
  }

  //endregion
}

fun <T> MethodCall.argumentForKey(key: String): T? {
  return this.argument(key)
}

// Make sure to provide the key for the bridge (which provides the bridgeId)
fun <T> MethodCall.bridgeInstance(key: String): T? {
  BreadCrumbs.append("SuperwallKitFlutterPlugin.kt: Invoke bridgeInstance(key:) on $this. Key is $key")
  val bridgeId = this.argument<String>(key) ?: return null
  BreadCrumbs.append("SuperwallKitFlutterPlugin.kt: Invoke bridgeInstance(key:) in on $this. Found bridgeId $bridgeId")
  return BridgingCreator.shared.bridgeInstance(bridgeId)
}

fun <T> BridgeId.bridgeInstance(): T? {
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

suspend fun MethodChannel.asyncInvokeMethodOnMain(method: String, arguments: Any? = null): Any? = suspendCancellableCoroutine { continuation ->
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
    return bridgeIds[methodChannel] ?: throw IllegalStateException("bridgeId must be set at initialization of MethodChannel")
  }
}

fun MethodChannel.setBridgeId(bridgeId: String) {
  MethodChannelAssociations.setBridgeId(this, bridgeId)
}

fun MethodChannel.getBridgeId(): String {
  return MethodChannelAssociations.getBridgeId(this)
}