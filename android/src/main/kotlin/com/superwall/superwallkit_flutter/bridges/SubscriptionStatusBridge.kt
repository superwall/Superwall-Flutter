package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.delegate.SubscriptionStatus
import com.superwall.superwallkit_flutter.BridgingCreator
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

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
    companion object {
        fun bridgeClass(): BridgeClass = "SubscriptionStatusActiveBridge"
    }

    override val status: SubscriptionStatus
        get() = SubscriptionStatus.ACTIVE
}

class SubscriptionStatusInactiveBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : SubscriptionStatusBridge(context, bridgeId, initializationArgs) {
    companion object {
        fun bridgeClass(): BridgeClass = "SubscriptionStatusInactiveBridge"
    }

    override val status: SubscriptionStatus
        get() = SubscriptionStatus.INACTIVE
}

class SubscriptionStatusUnknownBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : SubscriptionStatusBridge(context, bridgeId, initializationArgs) {
    companion object {
        fun bridgeClass(): BridgeClass = "SubscriptionStatusUnknownBridge"
    }

    override val status: SubscriptionStatus
        get() = SubscriptionStatus.UNKNOWN
}

fun SubscriptionStatus.createBridgeId(): BridgeId {
    val bridgeClass = when (this) {
        SubscriptionStatus.ACTIVE -> SubscriptionStatusActiveBridge.bridgeClass()
        SubscriptionStatus.INACTIVE -> SubscriptionStatusInactiveBridge.bridgeClass()
        SubscriptionStatus.UNKNOWN -> SubscriptionStatusUnknownBridge.bridgeClass()
    }

    val bridgeInstance = BridgingCreator.shared.createBridgeInstanceFromBridgeClass(bridgeClass)
    return bridgeInstance.bridgeId
}