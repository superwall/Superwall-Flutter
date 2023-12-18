package com.superwall.superwallkit_flutter.bridges

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

open class BaseBridge(
    val channel: MethodChannel,
    val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        throw AssertionError("Subclasses of BaseBridge must implement onMethodCall.")
    }
}