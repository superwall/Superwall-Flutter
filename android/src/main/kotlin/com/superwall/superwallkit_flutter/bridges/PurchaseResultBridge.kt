package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.delegate.PurchaseResult
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

abstract class PurchaseResultBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), MethodChannel.MethodCallHandler {

    abstract val purchaseResult: PurchaseResult

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }
}

class PurchaseResultCancelledBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : PurchaseResultBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "PurchaseResultCancelledBridge" }
    override val purchaseResult: PurchaseResult = PurchaseResult.Cancelled()
}

class PurchaseResultPurchasedBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : PurchaseResultBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "PurchaseResultPurchasedBridge" }
    override val purchaseResult: PurchaseResult = PurchaseResult.Purchased()
}

class PurchaseResultPendingBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : PurchaseResultBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "PurchaseResultPendingBridge" }
    override val purchaseResult: PurchaseResult = PurchaseResult.Pending()
}

class PurchaseResultFailedBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : PurchaseResultBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "PurchaseResultFailedBridge" }
    override val purchaseResult: PurchaseResult

    init {
        val errorString = initializationArgs?.get("error") as? String
            ?: throw IllegalArgumentException("Attempting to create `PurchaseResultFailedBridge` without providing `error`.")
        purchaseResult = PurchaseResult.Failed(errorString)
    }
}