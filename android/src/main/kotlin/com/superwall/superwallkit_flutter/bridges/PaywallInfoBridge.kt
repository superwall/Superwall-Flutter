package com.superwall.superwallkit_flutter.bridges

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class PaywallInfoBridge(channel: MethodChannel) : BaseBridge(channel) {
    // TODO: Implement the logic to retrieve and send PaywallInfo
    override fun onMethodCall(call: MethodCall, result: Result) {
        result.notImplemented()
    }
}
