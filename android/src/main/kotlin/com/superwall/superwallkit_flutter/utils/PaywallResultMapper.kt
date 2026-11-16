package com.superwall.superwallkit_flutter.utils

import PDeclinedPaywallResult
import PExperiment
import PPaywallResult
import PPaywallSkippedReason
import PPurchasedPaywallResult
import PRestoredPaywallResult
import com.superwall.sdk.paywall.presentation.internal.state.PaywallResult
import com.superwall.sdk.paywall.presentation.internal.state.PaywallSkippedReason
import pigeonify

fun PaywallResult.toPigeon(): PPaywallResult =
    when (this) {
        is PaywallResult.Purchased -> PPurchasedPaywallResult(productId)
        is PaywallResult.Declined -> PDeclinedPaywallResult()
        is PaywallResult.Restored -> PRestoredPaywallResult()
    }

fun PaywallSkippedReason.toPigeon(): PPaywallSkippedReason =
    when (this) {
        is PaywallSkippedReason.Holdout -> PPaywallSkippedReason.HOLDOUT
        is PaywallSkippedReason.NoAudienceMatch -> PPaywallSkippedReason.NO_AUDIENCE_MATCH
        is PaywallSkippedReason.PlacementNotFound -> PPaywallSkippedReason.PLACEMENT_NOT_FOUND
        is PaywallSkippedReason.UserIsSubscribed -> PPaywallSkippedReason.USER_IS_SUBSCRIBED
    }

/** The experiment of a [PaywallSkippedReason.Holdout], `null` for the other reasons. */
fun PaywallSkippedReason.pigeonExperiment(): PExperiment? =
    (this as? PaywallSkippedReason.Holdout)?.experiment?.pigeonify()
