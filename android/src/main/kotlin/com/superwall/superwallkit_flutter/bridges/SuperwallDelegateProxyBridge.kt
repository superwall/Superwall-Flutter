package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.delegate.SubscriptionStatus
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.invokeMethodOnMain
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import java.net.URL

class SuperwallDelegateProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), SuperwallDelegate {

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

    override fun paywallWillOpenURL(url: URL) {
        communicator.invokeMethodOnMain("paywallWillOpenURL", mapOf("url" to url.toString()))
    }

    override fun paywallWillOpenDeepLink(url: URL) {
        communicator.invokeMethodOnMain("paywallWillOpenDeepLink", mapOf("url" to url.toString()))
    }
}

