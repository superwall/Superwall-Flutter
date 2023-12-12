package com.superwall.superwallkit_flutter

import com.superwall.sdk.delegate.SubscriptionStatus
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SubscriptionStatusPlugin: FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "SWK_SubscriptionStatusPlugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getDescription" -> {
                val statusRawValue = call.argument<Int?>("status")
                if (statusRawValue != null) {
                    val status = SubscriptionStatus.fromRawValue(statusRawValue)
                    val description = status.toString()
                    result.success(description)
                } else {
                    result.error("INVALID_ARGUMENTS", "Invalid arguments for getDescription", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
