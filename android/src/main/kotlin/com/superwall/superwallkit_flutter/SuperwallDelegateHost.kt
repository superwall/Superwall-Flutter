package com.superwall.superwallkit_flutter

import PActive
import PEntitlement
import PInactive
import PPaywallInfo
import PSubscriptionStatus
import PSuperwallDelegateGenerated
import PUnknown
import PigeonEventSink
import StreamSubscriptionStatusStreamHandler
import android.net.Uri
import com.superwall.sdk.Superwall
import com.superwall.sdk.analytics.superwall.SuperwallEventInfo
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.models.internal.RedemptionResult
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.utils.EventMapper
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper
import com.superwall.superwallkit_flutter.utils.RedemptionResultMapper
import com.superwall.superwallkit_flutter.utils.SubscriptionStatusMapper.toPigeon
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import java.net.URI

class SuperwallDelegateHost(val setup: () -> PSuperwallDelegateGenerated) : SuperwallDelegate {
    private val backingDelegate = setup()
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private val ioScope = CoroutineScope(Dispatchers.IO)
    private fun onMain(unit: () -> Unit) {
        mainScope.launch {
            unit()
        }
    }

    override fun didDismissPaywall(withInfo: PaywallInfo) {
        super.didDismissPaywall(withInfo)
        onMain {
            backingDelegate.didDismissPaywall(PaywallInfoMapper.toPPaywallInfo(withInfo), {})
        }
    }

    override fun didPresentPaywall(withInfo: PaywallInfo) {
        super.didPresentPaywall(withInfo)
        onMain {
            backingDelegate.didPresentPaywall(PaywallInfoMapper.toPPaywallInfo(withInfo), {})
        }
    }

    override fun willDismissPaywall(withInfo: PaywallInfo) {
        super.willDismissPaywall(withInfo)
        onMain {
            backingDelegate.willDismissPaywall(PaywallInfoMapper.toPPaywallInfo(withInfo), {})
        }
    }

    override fun willPresentPaywall(withInfo: PaywallInfo) {
        super.willPresentPaywall(withInfo)
        onMain {
            backingDelegate.willPresentPaywall(PaywallInfoMapper.toPPaywallInfo(withInfo), {})

        }
    }

    override fun handleCustomPaywallAction(withName: String) {
        super.handleCustomPaywallAction(withName)
        onMain {
            backingDelegate.handleCustomPaywallAction(withName, {})
        }
    }

    override fun handleLog(
        level: String,
        scope: String,
        message: String?,
        info: Map<String, Any>?,
        error: Throwable?
    ) {
        super.handleLog(level, scope, message, info, error)
        onMain {
            backingDelegate.handleLog(
                level,
                scope,
                message,
                info?.mapValues { it.toString() },
                error?.message,
                {})
        }
    }

    override fun handleSuperwallEvent(eventInfo: SuperwallEventInfo) {
        super.handleSuperwallEvent(eventInfo)
        onMain {
            /* backingDelegate.handleSuperwallEvent(
                 EventMapper.toPigeonEventInfo(eventInfo), {}
             )
 */
        }
    }

    override fun paywallWillOpenDeepLink(url: Uri) {
        super.paywallWillOpenDeepLink(url)
        onMain {
            backingDelegate.paywallWillOpenDeepLink(url.toString(), {})
        }
    }

    override fun paywallWillOpenURL(url: URI) {
        super.paywallWillOpenURL(url)
        onMain {
            backingDelegate.paywallWillOpenURL(url.toString(), {})
        }
    }

    override fun subscriptionStatusDidChange(from: SubscriptionStatus, to: SubscriptionStatus) {
        super.subscriptionStatusDidChange(from, to)
        onMain {
            backingDelegate.subscriptionStatusDidChange(from.toPigeon(), to.toPigeon(), {})
        }
    }

    override fun willRedeemLink() {
        super.willRedeemLink()
        onMain {
            backingDelegate.willRedeemLink({})
        }
    }

    override fun didRedeemLink(result: RedemptionResult) {
        super.didRedeemLink(result)
        onMain {
            backingDelegate.didRedeemLink(RedemptionResultMapper.toPRedemptionResult(result), {})
        }
    }


}