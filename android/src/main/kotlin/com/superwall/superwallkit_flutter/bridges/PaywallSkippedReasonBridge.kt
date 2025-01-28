package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.paywall.presentation.internal.state.PaywallSkippedReason
import com.superwall.superwallkit_flutter.BridgingCreator
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch

abstract class PaywallSkippedReasonBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), MethodChannel.MethodCallHandler {
    abstract val reason: PaywallSkippedReason

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDescription" -> {
                val description = reason.toString()
                result.success(description)
            }

            else -> result.notImplemented()
        }
    }
}

class PaywallSkippedReasonHoldoutBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : PaywallSkippedReasonBridge(context, bridgeId, initializationArgs) {
    private val scope = CoroutineScope(Dispatchers.IO)

    companion object {
        fun bridgeClass(): BridgeClass = "PaywallSkippedReasonHoldoutBridge"
    }

    override val reason: PaywallSkippedReason =
        initializationArgs?.get("reason") as? PaywallSkippedReason
            ?: throw IllegalArgumentException("Attempting to create a `PaywallSkippedReasonHoldoutBridge` without providing a reason.")

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {
            "getExperimentBridgeId" -> {
                scope.launch {
                    if (reason is PaywallSkippedReason.Holdout) {
                        val experiment = reason.experiment
                        val experimentBridgeId =
                            BridgingCreator.shared.createBridgeInstanceFromBridgeClass(
                                ExperimentBridge.bridgeClass(),
                                mapOf("experiment" to experiment)
                            )
                        result.success(experimentBridgeId)
                    } else {
                        result.notImplemented()
                    }
                }
            }

            else -> super.onMethodCall(call, result)
        }
    }
}

class PaywallSkippedReasonNoAudienceMatchBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : PaywallSkippedReasonBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "PaywallSkippedReasonNoAudienceMatchBridge" }
    override val reason: PaywallSkippedReason = PaywallSkippedReason.NoAudienceMatch()
}

class PaywallSkippedReasonPlacementNotFoundBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : PaywallSkippedReasonBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "PaywallSkippedReasonPlacementNotFoundBridge" }
    override val reason: PaywallSkippedReason = PaywallSkippedReason.PlacementNotFound()
}

suspend fun PaywallSkippedReason.createBridgeId(): BridgeId {
    return when (this) {
        is PaywallSkippedReason.Holdout -> {
            val bridgeInstance = BridgingCreator.shared.createBridgeInstanceFromBridgeClass(
                PaywallSkippedReasonHoldoutBridge.bridgeClass(),
                mapOf("reason" to this)
            )
            return bridgeInstance.bridgeId
        }

        is PaywallSkippedReason.NoAudienceMatch -> {
            val bridgeInstance = BridgingCreator.shared.createBridgeInstanceFromBridgeClass(
                PaywallSkippedReasonNoAudienceMatchBridge.bridgeClass(),
                mapOf("reason" to this)
            )
            return bridgeInstance.bridgeId
        }

        is PaywallSkippedReason.PlacementNotFound -> {
            val bridgeInstance = BridgingCreator.shared.createBridgeInstanceFromBridgeClass(
                PaywallSkippedReasonPlacementNotFoundBridge.bridgeClass(),
                mapOf("reason" to this)
            )
            return bridgeInstance.bridgeId
        }
    }
}
