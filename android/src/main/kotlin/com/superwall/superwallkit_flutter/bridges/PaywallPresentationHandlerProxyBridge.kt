package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.superwallkit_flutter.invokeMethodOnMain
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class PaywallPresentationHandlerProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null,
) : BridgeInstance(context, bridgeId, initializationArgs) {
    val scope = CoroutineScope(Dispatchers.IO)

    companion object {
        fun bridgeClass(): BridgeClass = "PaywallPresentationHandlerProxyBridge"
    }

    val handler: PaywallPresentationHandler by lazy {
        PaywallPresentationHandler().apply {
            onPresent {
                scope.launch {
                    communicator().invokeMethodOnMain(
                        "onPresent",
                        mapOf("paywallInfoBridgeId" to it.createBridgeId())
                    )
                }
            }
            onDismiss {
                scope.launch {
                    communicator().invokeMethodOnMain(
                        "onDismiss",
                        mapOf("paywallInfoBridgeId" to it.createBridgeId())
                    )
                }
            }

            onError {
                scope.launch {
                    communicator().invokeMethodOnMain(
                        "onError",
                        mapOf("errorString" to it.toString())
                    )
                }
            }
            onSkip {
                scope.launch {
                    communicator().invokeMethodOnMain(
                        "onSkip",
                        mapOf("paywallSkippedReasonBridgeId" to it.createBridgeId())
                    )
                }
            }
        }
    }
}
