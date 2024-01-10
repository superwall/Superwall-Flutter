package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.superwallkit_flutter.invokeMethodOnMain

class PaywallPresentationHandlerProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "PaywallPresentationHandlerProxyBridge" }

    val handler: PaywallPresentationHandler by lazy {
        PaywallPresentationHandler().apply {
            onPresent {
                communicator.invokeMethodOnMain("onPresent", mapOf("paywallInfoBridgeId" to it.createBridgeId()))
            }
            onDismiss {
                communicator.invokeMethodOnMain("onDismiss", mapOf("paywallInfoBridgeId" to it.createBridgeId()))
            }

            onError {
                communicator.invokeMethodOnMain("onError", mapOf("errorString" to it.toString()))
            }
            onSkip {
                communicator.invokeMethodOnMain("onSkip", mapOf("paywallSkippedReasonBridgeId" to it.createBridgeId()))
            }
        }
    }
}
