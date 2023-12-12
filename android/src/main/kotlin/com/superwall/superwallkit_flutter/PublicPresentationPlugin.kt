package com.superwall.superwallkit_flutter

import com.superwall.sdk.Superwall
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.sdk.paywall.presentation.register
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class PublicPresentationPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private val scope = CoroutineScope(Dispatchers.Main)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "SWK_PublicPresentationPlugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "dismiss" -> {
                scope.launch {
                    Superwall.instance.dismiss()
                    result.success(null)
                }
            }
            "registerEventWithFeature" -> {
                val event = call.argument<String>("event")
                if (event != null) {
                    val params = call.argument<Map<String, Any>>("params")
//                    val handler = call.argument<Int>("handler")

                    // TODO: Implement the logic to register an event in Superwall with a feature handler
                    Superwall.instance.register(event, params)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENTS", "Invalid arguments for registerEventWithFeature", null)
                }
            }
            "registerEvent" -> {
                val event = call.argument<String>("event")
                if (event != null) {
                    val params = call.argument<Map<String, Any>>("params")
                    Superwall.instance.register(event, params)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENTS", "Invalid arguments for registerEvent", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
