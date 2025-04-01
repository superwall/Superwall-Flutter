package com.superwall.superwallkit_flutter

import PPaywallInfo
import PSubscriptionStatus
import PSuperwallDelegateApi
import PSuperwallEventInfoPigeon
import android.net.Uri
import com.superwall.sdk.analytics.superwall.SuperwallEventInfo
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.utils.EventMapper
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper
import java.net.URI

class SuperwallDelegateHost(val backingDelegate: PSuperwallDelegateApi) : SuperwallDelegate {

    override fun didDismissPaywall(withInfo: PaywallInfo) {
        super.didDismissPaywall(withInfo)
        backingDelegate.didDismissPaywall(PaywallInfoMapper.toPPaywallInfo(withInfo))
    }

    override fun didPresentPaywall(withInfo: PaywallInfo) {
        super.didPresentPaywall(withInfo)
        backingDelegate.didPresentPaywall(PaywallInfoMapper.toPPaywallInfo(withInfo))

    }

    override fun willDismissPaywall(withInfo: PaywallInfo) {
        super.willDismissPaywall(withInfo)
        backingDelegate.willDismissPaywall(PaywallInfoMapper.toPPaywallInfo(withInfo))

    }

    override fun willPresentPaywall(withInfo: PaywallInfo) {
        super.willPresentPaywall(withInfo)
        backingDelegate.willPresentPaywall(PaywallInfoMapper.toPPaywallInfo(withInfo))

    }

    override fun handleCustomPaywallAction(withName: String) {
        super.handleCustomPaywallAction(withName)
        backingDelegate.handleCustomPaywallAction(withName)
    }

    override fun handleLog(
        level: String,
        scope: String,
        message: String?,
        info: Map<String, Any>?,
        error: Throwable?
    ) {
        super.handleLog(level, scope, message, info, error)
        backingDelegate.handleLog(level, scope, message, info, error?.message)
    }

    override fun handleSuperwallEvent(eventInfo: SuperwallEventInfo) {
        super.handleSuperwallEvent(eventInfo)
        backingDelegate.handleSuperwallEvent(
            EventMapper.toPigeonEventInfo(eventInfo)
        )

    }

    override fun paywallWillOpenDeepLink(url: Uri) {
        super.paywallWillOpenDeepLink(url)
    }

    override fun paywallWillOpenURL(url: URI) {
        super.paywallWillOpenURL(url)
    }

    override fun subscriptionStatusDidChange(from: SubscriptionStatus, to: SubscriptionStatus) {
        super.subscriptionStatusDidChange(from, to)
    }

}