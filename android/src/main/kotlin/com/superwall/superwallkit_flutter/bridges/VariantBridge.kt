import com.superwall.sdk.models.triggers.Experiment
import com.superwall.sdk.models.triggers.Experiment.Variant

fun Experiment.Variant.toJson(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "type" to type.toJson(),
        "paywallId" to paywallId
    )
}

fun Experiment.Variant.VariantType.toJson(): String {
    return when (this) {
        Variant.VariantType.TREATMENT -> "treatment"
        Variant.VariantType.HOLDOUT -> "holdout"
    }
}