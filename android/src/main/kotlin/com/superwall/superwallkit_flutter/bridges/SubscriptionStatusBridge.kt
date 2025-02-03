package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import android.util.Log
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.Superwall
import com.superwall.superwallkit_flutter.BridgingCreator
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.superwall.superwallkit_flutter.json.toEntitlement
import com.superwall.superwallkit_flutter.json.toJson

open class SubscriptionStatusBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {
    open val status: SubscriptionStatus
        get() = throw AssertionError("Subclasses must implement")

    override val cachable = false
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDescription" -> {
                val description = status.toString()
                result.success(description)
            }
            "getEntitlements" -> {
                val entitlements = Superwall.instance.entitlements.active.map { it.toJson() }.toList()

                result.success(entitlements)
            }
            else -> result.notImplemented()
        }
    }
}

// Define the subclasses for each subscription status
class SubscriptionStatusActiveBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>?
) : SubscriptionStatusBridge(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "SubscriptionStatusActiveBridge" }


    override val status: SubscriptionStatus
        get() {
            Log.e("REceived entitlements", "$initializationArgs")
            val entitlements = (initializationArgs?.get("entitlements") as? List<Map<String,Any>>)?.map {
                Log.e("Deserializing", "To ent: $it")
                it.toEntitlement() }?.toSet() ?: emptySet()
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