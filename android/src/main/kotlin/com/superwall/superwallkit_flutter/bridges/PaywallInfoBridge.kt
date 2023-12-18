package com.superwall.superwallkit_flutter.bridges

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class PaywallInfoBridge(channel: MethodChannel, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : BaseBridge(channel, flutterPluginBinding) {
    // TODO: Implement the logic to retrieve and send PaywallInfo
    override fun onMethodCall(call: MethodCall, result: Result) {
        result.notImplemented()
    }
}
