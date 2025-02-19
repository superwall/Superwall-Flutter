package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import android.net.Uri
import com.superwall.sdk.analytics.superwall.SuperwallPlacementInfo
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.invokeMethodOnMain
import toJson
import java.net.URI
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SuperwallDelegateProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null,
    val coroutineScope: CoroutineScope = CoroutineScope(Dispatchers.IO)
) : BridgeInstance(context, bridgeId, initializationArgs), SuperwallDelegate {
    companion object {
        fun bridgeClass(): BridgeClass = "SuperwallDelegateProxyBridge"
    }

    override fun willPresentPaywall(paywallInfo: PaywallInfo) {
        coroutineScope.launch {
            communicator().invokeMethodOnMain(
                "willPresentPaywall",
                mapOf("paywallInfoBridgeId" to paywallInfo.createBridgeId())
            )
        }
    }

    override fun didPresentPaywall(paywallInfo: PaywallInfo) {
        coroutineScope.launch {

            communicator().invokeMethodOnMain(
                "didPresentPaywall",
                mapOf("paywallInfoBridgeId" to paywallInfo.createBridgeId())
            )
        }
    }

    override fun willDismissPaywall(paywallInfo: PaywallInfo) {
        coroutineScope.launch {

            communicator().invokeMethodOnMain(
                "willDismissPaywall",
                mapOf("paywallInfoBridgeId" to paywallInfo.createBridgeId())
            )
        }
    }

    override fun didDismissPaywall(paywallInfo: PaywallInfo) {
        coroutineScope.launch {
            communicator().invokeMethodOnMain(
                "didDismissPaywall",
                mapOf("paywallInfoBridgeId" to paywallInfo.createBridgeId())
            )
        }
    }

    override fun handleCustomPaywallAction(name: String) {
        coroutineScope.launch {
            communicator().invokeMethodOnMain("handleCustomPaywallAction", mapOf("name" to name))
        }
    }

    override fun subscriptionStatusDidChange(from: SubscriptionStatus, to: SubscriptionStatus) {
        coroutineScope.launch {
            communicator().invokeMethodOnMain(
                "subscriptionStatusDidChange",
                mapOf("subscriptionStatusBridgeId" to to.createBridgeId())
            )
        }
    }

    override fun handleSuperwallPlacement(placementInfo: SuperwallPlacementInfo) {
        coroutineScope.launch {
            communicator().invokeMethodOnMain(
                "handleSuperwallPlacement",
                mapOf("placementInfo" to placementInfo.toJson())
            )
        }
    }

    override fun paywallWillOpenURL(url: URI) {
        coroutineScope.launch {
            communicator().invokeMethodOnMain("paywallWillOpenURL", mapOf("url" to url.toString()))
        }
    }

    override fun paywallWillOpenDeepLink(url: Uri) {
        coroutineScope.launch {
            communicator().invokeMethodOnMain(
                "paywallWillOpenDeepLink",
                mapOf("url" to url.toString())
            )
        }
    }

    override fun handleLog(
        level: String,
        scope: String,
        message: String?,
        info: Map<String, Any>?,
        error: Throwable?
    ) {
        coroutineScope.launch {
            val transformedInfo = info?.mapValues { (_, value) ->
                when (value) {
                    is String -> value
                    is Int -> value
                    is Map<*, *> -> value
                    is List<*> -> value
                    is Boolean -> value
                    is Set<*> -> value.toList()
                    else -> null
                }
            }

            val arguments: Map<String, Any?> = mapOf(
                "level" to level,
                "scope" to scope,
                "message" to message,
                "info" to transformedInfo,
                "error" to error?.localizedMessage
            )

            communicator().invokeMethodOnMain("handleLog", arguments)
        }
    }
}

