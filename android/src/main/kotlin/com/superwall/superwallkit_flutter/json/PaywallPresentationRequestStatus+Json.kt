package com.superwall.superwallkit_flutter.json

import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatus
import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatusReason

fun PaywallPresentationRequestStatus.toJson(): Map<String, String> = when (this) {
    PaywallPresentationRequestStatus.Presentation -> mapOf("status" to "presentation")
    PaywallPresentationRequestStatus.NoPresentation -> mapOf("status" to "noPresentation")
    PaywallPresentationRequestStatus.Timeout -> mapOf("status" to "timeout")
}

suspend fun PaywallPresentationRequestStatusReason.toJson(): Map<String, Any?> = when (this) {
    is PaywallPresentationRequestStatusReason.DebuggerPresented -> mapOf("reason" to "debuggerPresented")
    is PaywallPresentationRequestStatusReason.Holdout -> mapOf("reason" to "holdout")
    is PaywallPresentationRequestStatusReason.NoAudienceMatch -> mapOf("reason" to "noAudienceMatch")
    is PaywallPresentationRequestStatusReason.PlacementNotFound -> mapOf("reason" to "placementNotFound")
    is PaywallPresentationRequestStatusReason.NoPaywallView -> mapOf("reason" to "noPaywallViewController")
    is PaywallPresentationRequestStatusReason.NoPresenter -> mapOf("reason" to "noPresenter")
    is PaywallPresentationRequestStatusReason.NoConfig -> mapOf("reason" to "noConfig")
    is PaywallPresentationRequestStatusReason.PaywallAlreadyPresented -> mapOf("reason" to "paywallAlreadyPresented")
    else -> {
        mapOf()}
}