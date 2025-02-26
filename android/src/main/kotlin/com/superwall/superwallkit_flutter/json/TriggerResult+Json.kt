import com.superwall.sdk.models.triggers.TriggerResult
import com.superwall.superwallkit_flutter.bridges.createBridgeId

fun TriggerResult.toJson(): Map<String, Any?> {
    return when (this) {
        is TriggerResult.PlacementNotFound -> mapOf("result" to "placementNotFound")
        is TriggerResult.NoAudienceMatch -> mapOf("result" to "noAudienceMatch")
        is TriggerResult.Paywall -> mapOf("result" to "paywall", "experiment" to mapOf("id" to experiment.id,
            "description" to experiment.toString()))
        is TriggerResult.Holdout -> mapOf("result" to "holdout", "experiment" to mapOf("id" to experiment.id,
            "description" to experiment.toString()))
        is TriggerResult.Error -> mapOf("result" to "error", "error" to error.localizedMessage)
    }
}