package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatus
import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatusReason

fun PaywallPresentationRequestStatus.toJson(): String {
    return when (this) {
        PaywallPresentationRequestStatus.Presentation -> "presentation"
        PaywallPresentationRequestStatus.NoPresentation -> "no_presentation"
        PaywallPresentationRequestStatus.Timeout -> "timeout"
    }
}

fun PaywallPresentationRequestStatusReason.toJson(): Map<String, Any?> {
    return when (this) {
        is PaywallPresentationRequestStatusReason.DebuggerPresented ->
            mapOf("type" to "DebuggerPresented", "description" to description)
        is PaywallPresentationRequestStatusReason.PaywallAlreadyPresented ->
            mapOf("type" to "PaywallAlreadyPresented", "description" to description)
        is PaywallPresentationRequestStatusReason.UserIsSubscribed ->
            mapOf("type" to "UserIsSubscribed", "description" to description)
        is PaywallPresentationRequestStatusReason.Holdout ->
            mapOf("type" to "Holdout", "description" to description, "experiment" to experiment.toJson())
        is PaywallPresentationRequestStatusReason.NoRuleMatch ->
            mapOf("type" to "NoRuleMatch", "description" to description)
        is PaywallPresentationRequestStatusReason.EventNotFound ->
            mapOf("type" to "EventNotFound", "description" to description)
        is PaywallPresentationRequestStatusReason.NoPaywallViewController ->
            mapOf("type" to "NoPaywallViewController", "description" to description)
        is PaywallPresentationRequestStatusReason.NoPresenter ->
            mapOf("type" to "NoPresenter", "description" to description)
        is PaywallPresentationRequestStatusReason.NoConfig ->
            mapOf("type" to "NoConfig", "description" to description)
        is PaywallPresentationRequestStatusReason.SubscriptionStatusTimeout ->
            mapOf("type" to "SubscriptionStatusTimeout", "description" to description)
    }
}
