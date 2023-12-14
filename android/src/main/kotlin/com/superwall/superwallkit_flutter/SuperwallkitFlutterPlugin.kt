package com.superwall.superwallkit_flutter

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SuperwallkitFlutterPlugin: FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var currentActivity: Activity? = null

  companion object {
    private var instance: SuperwallkitFlutterPlugin? = null

    val currentActivity: Activity?
      get() = instance?.currentActivity
  }

  init {
    instance = this
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // Define the list of plugin types that conform to FlutterPlugin.
    // Make sure each plugin type conforms to `FlutterPlugin`.
    val pluginInstances = listOf(
      SubscriptionStatusBridge(),
      LogLevelBridge(),
      PaywallInfoBridge(),
      PublicPresentationBridge(),
      PurchaseResultBridge(),
      RestorationResultBridge(),
      SuperwallBridge()
    )

    // Iterate over the plugin instances and call `onAttachedToEngine` on each one
    pluginInstances.forEach { plugin ->
      plugin.onAttachedToEngine(flutterPluginBinding)
    }
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    result.notImplemented()
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

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

fun MethodChannel.Result.badArgsError(method: String) {
  return error("BAD_ARGS", "Missing or invalid arguments for '$method'", null)
}
