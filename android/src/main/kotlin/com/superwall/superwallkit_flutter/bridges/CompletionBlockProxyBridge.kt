package com.superwall.superwallkit_flutter.bridges

import io.flutter.plugin.common.MethodChannel

class CompletionBlockProxyBridge(channel: MethodChannel) : BaseBridge(channel) {

    fun callCompletionBlock(value: Any? = null) {
        channel.invokeMethod("callCompletionBlock", value)
    }
}
