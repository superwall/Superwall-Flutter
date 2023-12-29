package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.delegate.SubscriptionStatus
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.invokeMethodOnMain
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import java.net.URL

class SuperwallDelegateProxyBridge(channel: MethodChannel, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : BaseBridge(channel, flutterPluginBinding), SuperwallDelegate {

    override fun willPresentPaywall(paywallInfo: PaywallInfo) {
        channel.invokeMethodOnMain("willPresentPaywall", mapOf("paywallInfo" to paywallInfo.toJson()))
    }

    override fun didPresentPaywall(paywallInfo: PaywallInfo) {
        channel.invokeMethodOnMain("didPresentPaywall", mapOf("paywallInfo" to paywallInfo.toJson()))
    }

    override fun willDismissPaywall(paywallInfo: PaywallInfo) {
        channel.invokeMethodOnMain("willDismissPaywall", mapOf("paywallInfo" to paywallInfo.toJson()))
    }

    override fun didDismissPaywall(paywallInfo: PaywallInfo) {
        channel.invokeMethodOnMain("didDismissPaywall", mapOf("paywallInfo" to paywallInfo.toJson()))
    }

    override fun handleCustomPaywallAction(name: String) {
        channel.invokeMethodOnMain("handleCustomPaywallAction", mapOf("name" to name))
    }

    override fun subscriptionStatusDidChange(newValue: SubscriptionStatus) {
        channel.invokeMethodOnMain("subscriptionStatusDidChange", mapOf("newValue" to newValue.toJson()))
    }

    override fun paywallWillOpenURL(url: URL) {
        channel.invokeMethodOnMain("paywallWillOpenURL", mapOf("url" to url.toString()))
    }

    override fun paywallWillOpenDeepLink(url: URL) {
        channel.invokeMethodOnMain("paywallWillOpenDeepLink", mapOf("url" to url.toString()))
    }
}

