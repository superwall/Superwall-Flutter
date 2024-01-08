package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.superwallkit_flutter.invokeMethodOnMain
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CompletionBlockProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {

    fun callCompletionBlock(value: Any? = null) {
        communicator.invokeMethodOnMain("callCompletionBlock", value)
    }
}
