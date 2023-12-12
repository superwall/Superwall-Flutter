package com.superwall.superwallkit_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class RestorationResultPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "SWK_RestorationResultPlugin")
        channel.setMethodCallHandler(this)
    }

    // TODO
    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "isEqualTo") {
            val result1 = call.argument<String>("result1")
            val result2 = call.argument<String>("result2")

            if (result1 != null && result2 != null) {
                // Implement equality logic here based on the result1 and result2 strings
                // and the optional data associated with them if necessary.
                val isEqual = (result1 == result2) // Simplified example; adjust as needed
                result.success(isEqual)
            } else {
                result.error("INVALID_ARGUMENTS", "Invalid arguments for isEqualTo", null)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
