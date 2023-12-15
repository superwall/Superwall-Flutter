package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.paywall.presentation.PaywallInfo
import io.flutter.plugin.common.MethodChannel

// TODO
class SuperwallDelegateProxyBridge(channel: MethodChannel) : BaseBridge(channel),
    SuperwallDelegate {

    //region SuperwallDelegate

    override fun willPresentPaywall(paywallInfo: PaywallInfo) {
        // TODO: args
        channel.invokeMethod("willPresentPaywall", paywallInfo.toString())
    }

    override fun handleCustomPaywallAction(name: String) {
        // TODO: args
        channel.invokeMethod("handleCustomPaywallAction", name)
    }

    //endregion
}
