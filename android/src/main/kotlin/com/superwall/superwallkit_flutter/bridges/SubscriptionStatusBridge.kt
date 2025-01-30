package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.superwallkit_flutter.BridgingCreator
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.superwall.superwallkit_flutter.json.toEntitlement

open class SubscriptionStatusBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {
    open val status: SubscriptionStatus
        get() = throw AssertionError("Subclasses must implement")

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDescription" -> {
                val description = status.toString()
                result.success(description)
            }
            else -> result.notImplemented()
        }
    }
}

// Define the subclasses for each subscription status
class SubscriptionStatusActiveBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : SubscriptionStatusBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "SubscriptionStatusActiveBridge" }

    override val status: SubscriptionStatus
        get() {
            val entitlements = (initializationArgs?.get("entitlements") as? Set<Map<String,Any>>)?.map { it.toEntitlement() }?.toSet() ?: emptySet()
            return SubscriptionStatus.Active(entitlements = entitlements)
        }
}

class SubscriptionStatusInactiveBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : SubscriptionStatusBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "SubscriptionStatusInactiveBridge" }

    override val status: SubscriptionStatus
        get() = SubscriptionStatus.Inactive
}

class SubscriptionStatusUnknownBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : SubscriptionStatusBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "SubscriptionStatusUnknownBridge" }

    override val status: SubscriptionStatus
        get() = SubscriptionStatus.Unknown
}

suspend fun SubscriptionStatus.createBridgeId(): BridgeId {
    val bridgeClass = when (this) {
        is SubscriptionStatus.Active -> SubscriptionStatusActiveBridge.bridgeClass()
        is SubscriptionStatus.Inactive -> SubscriptionStatusInactiveBridge.bridgeClass()
        is SubscriptionStatus.Unknown -> SubscriptionStatusUnknownBridge.bridgeClass()
    }

    val bridgeInstance = BridgingCreator.shared.createBridgeInstanceFromBridgeClass(bridgeClass)
    return bridgeInstance.bridgeId
}