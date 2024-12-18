package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.superwallkit_flutter.invokeMethodOnMain

class CompletionBlockProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null,
) : BridgeInstance(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "CompletionBlockProxyBridge" }

    suspend fun callCompletionBlock(value: Any? = null) {
        communicator().invokeMethodOnMain("callCompletionBlock", value)
    }
}