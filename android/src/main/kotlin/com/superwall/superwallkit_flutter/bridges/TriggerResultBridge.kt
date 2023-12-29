package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.models.triggers.TriggerResult

fun TriggerResult.toJson(): Map<String, Any?> {
    return when (this) {
        is TriggerResult.EventNotFound -> mapOf("type" to "eventNotFound")
        is TriggerResult.NoRuleMatch -> mapOf("type" to "noRuleMatch")
        is TriggerResult.Paywall -> mapOf("type" to "paywall", "experiment" to experiment.toJson())
        is TriggerResult.Holdout -> mapOf("type" to "holdout", "experiment" to experiment.toJson())
        is TriggerResult.Error -> mapOf("type" to "error", "errorDetail" to error)
    }
}