package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.paywall.presentation.internal.state.PaywallSkippedReason

fun PaywallSkippedReason.toJson(): Map<String, Any?> {
    return when (this) {
        is PaywallSkippedReason.Holdout ->
            mapOf("type" to "holdout", "experiment" to experiment.toJson())
        is PaywallSkippedReason.NoRuleMatch ->
            mapOf("type" to "noRuleMatch")
        is PaywallSkippedReason.EventNotFound ->
            mapOf("type" to "eventNotFound")
        is PaywallSkippedReason.UserIsSubscribed ->
            mapOf("type" to "userIsSubscribed")
    }
}