package com.superwall.superwallkit_flutter.bridges

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

open class BaseBridge(val channel: MethodChannel) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {}
}
