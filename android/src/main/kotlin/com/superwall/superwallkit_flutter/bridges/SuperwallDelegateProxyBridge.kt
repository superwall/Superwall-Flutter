package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import android.net.Uri
import com.superwall.sdk.analytics.superwall.SuperwallEventInfo
import com.superwall.sdk.delegate.SubscriptionStatus
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.invokeMethodOnMain
import toJson
import java.net.URL

class SuperwallDelegateProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), SuperwallDelegate {
    companion object { fun bridgeClass(): BridgeClass = "SuperwallDelegateProxyBridge" }

    override fun willPresentPaywall(paywallInfo: PaywallInfo) {
        communicator.invokeMethodOnMain("willPresentPaywall", mapOf("paywallInfoBridgeId" to paywallInfo.createBridgeId()))
    }

    override fun didPresentPaywall(paywallInfo: PaywallInfo) {
        communicator.invokeMethodOnMain("didPresentPaywall", mapOf("paywallInfoBridgeId" to paywallInfo.createBridgeId()))
    }

    override fun willDismissPaywall(paywallInfo: PaywallInfo) {
        communicator.invokeMethodOnMain("willDismissPaywall", mapOf("paywallInfoBridgeId" to paywallInfo.createBridgeId()))
    }

    override fun didDismissPaywall(paywallInfo: PaywallInfo) {
        communicator.invokeMethodOnMain("didDismissPaywall", mapOf("paywallInfoBridgeId" to paywallInfo.createBridgeId()))
    }

    override fun handleCustomPaywallAction(name: String) {
        communicator.invokeMethodOnMain("handleCustomPaywallAction", mapOf("name" to name))
    }

    override fun subscriptionStatusDidChange(newValue: SubscriptionStatus) {
        communicator.invokeMethodOnMain("subscriptionStatusDidChange", mapOf("subscriptionStatusBridgeId" to newValue.createBridgeId()))
    }

    override fun handleSuperwallEvent(eventInfo: SuperwallEventInfo) {
        communicator.invokeMethodOnMain("handleSuperwallEvent", mapOf("eventInfo" to eventInfo.toJson()))
    }

    override fun paywallWillOpenURL(url: URL) {
        communicator.invokeMethodOnMain("paywallWillOpenURL", mapOf("url" to url.toString()))
    }

    override fun paywallWillOpenDeepLink(url: Uri) {
        communicator.invokeMethodOnMain("paywallWillOpenDeepLink", mapOf("url" to url.toString()))
    }

    override fun handleLog(
        level: String,
        scope: String,
        message: String?,
        info: Map<String, Any>?,
        error: Throwable?
    ) {
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

        communicator.invokeMethodOnMain("handleLog", arguments)
    }
}

