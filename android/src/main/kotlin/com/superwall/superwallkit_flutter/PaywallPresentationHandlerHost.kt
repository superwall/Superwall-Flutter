package com.superwall.superwallkit_flutter

import PDeclinedPaywallResult
import PPaywallPresentationHandlerGenerated
import PPaywallSkippedReason
import PPurchasedPaywallResult
import PRestoredPaywallResult
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.sdk.paywall.presentation.internal.state.PaywallResult
import com.superwall.sdk.paywall.presentation.internal.state.PaywallSkippedReason
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper

class PaywallPresentationHandlerHost(
    setup: () -> PPaywallPresentationHandlerGenerated,
) {
    val backingHandler = setup()
    val handler =
        PaywallPresentationHandler().apply {
            onPresent {
                backingHandler.onPresent(PaywallInfoMapper.toPPaywallInfo(it), {})
            }
            onDismiss { info, result ->
                backingHandler.onDismiss(
                    PaywallInfoMapper.toPPaywallInfo(info),
                    when (result) {
                        is PaywallResult.Purchased -> PPurchasedPaywallResult(result.productId)
                        is PaywallResult.Declined -> PDeclinedPaywallResult()
                        is PaywallResult.Restored -> PRestoredPaywallResult()
                    },
                    {},
                )
            }
            onError {
                backingHandler.onError(it.localizedMessage ?: it.message ?: "Unknown error", {})
            }
            onSkip {
                backingHandler.onSkip(
                    when (it) {
                        is PaywallSkippedReason.Holdout -> PPaywallSkippedReason.HOLDOUT
                        is PaywallSkippedReason.NoAudienceMatch -> PPaywallSkippedReason.NO_AUDIENCE_MATCH
                        is PaywallSkippedReason.PlacementNotFound -> PPaywallSkippedReason.PLACEMENT_NOT_FOUND
                        else -> PPaywallSkippedReason.NO_AUDIENCE_MATCH
                    },
                    {},
                )
            }
        }
}
