import com.superwall.sdk.models.triggers.TriggerResult
import com.superwall.superwallkit_flutter.bridges.createBridgeId

fun TriggerResult.toJson(): Map<String, Any?> {
    return when (this) {
        is TriggerResult.EventNotFound -> mapOf("result" to "eventNotFound")
        is TriggerResult.NoRuleMatch -> mapOf("result" to "noRuleMatch")
        is TriggerResult.Paywall -> mapOf("result" to "paywall", "experimentBridgeId" to experiment.createBridgeId())
        is TriggerResult.Holdout -> mapOf("result" to "holdout", "experimentBridgeId" to experiment.createBridgeId())
        is TriggerResult.Error -> mapOf("result" to "error", "error" to error.localizedMessage)
    }
}