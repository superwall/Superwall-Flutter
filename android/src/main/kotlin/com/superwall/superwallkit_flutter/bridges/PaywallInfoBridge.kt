package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.BridgingCreator
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PaywallInfoBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {

    companion object {
        fun bridgeClass(): BridgeClass = "PaywallInfoBridge"
    }

    val paywallInfo: PaywallInfo

    init {
        val tempPaywallInfo = initializationArgs?.get("paywallInfo") as? PaywallInfo
        paywallInfo = tempPaywallInfo ?: throw IllegalArgumentException("Attempting to create `PaywallInfoBridge` without providing `paywallInfo`.")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getName" -> {
                val name = paywallInfo.name
                result.success(name)
            }
            else -> result.notImplemented()
        }
    }
}

fun PaywallInfo.createBridgeId(): BridgeId {
    val bridgeInstance = BridgingCreator.shared.createBridgeInstanceFromBridgeClass(
        bridgeClass = PaywallInfoBridge.bridgeClass(),
        initializationArgs = mapOf("paywallInfo" to this)
    )
    return bridgeInstance.bridgeId
}