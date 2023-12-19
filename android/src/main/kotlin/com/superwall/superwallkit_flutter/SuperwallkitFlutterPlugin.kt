package com.superwall.superwallkit_flutter

import android.app.Activity
import android.os.Debug
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

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

// Make sure to provide the key for the bridge, not the bridge itself.
fun <T> MethodCall.bridgeForKey(key: String): T? {
  val channelName = this.argument<String>(key)
  if (channelName == null) {
    return null
  }
  return BridgingCreator.shared.bridge(channelName)
}

fun MethodChannel.Result.badArgs(call: MethodCall) {
  return badArgs(call.method)
}

fun MethodChannel.Result.badArgs(method: String) {
  return error("BAD_ARGS", "Missing or invalid arguments for '$method'", null)
}
