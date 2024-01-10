package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.delegate.RestorationResult
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

abstract class RestorationResultBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), MethodChannel.MethodCallHandler {

    abstract val restorationResult: RestorationResult

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }
}

class RestorationResultRestoredBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : RestorationResultBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "RestorationResultRestoredBridge" }
    override val restorationResult: RestorationResult = RestorationResult.Restored()
}

class RestorationResultFailedBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : RestorationResultBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "RestorationResultFailedBridge" }
    override val restorationResult: RestorationResult

    init {
        val errorMessage = initializationArgs?.get("error") as? String
            ?: throw IllegalArgumentException("Attempting to create `RestorationResultFailedBridge` without providing `error`.")
        restorationResult = RestorationResult.Failed(RestorationResultError(errorMessage))
    }
}

data class RestorationResultError(override val message: String) : Throwable()
