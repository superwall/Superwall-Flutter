import com.superwall.sdk.models.triggers.Experiment
import com.superwall.sdk.models.triggers.TriggerResult

fun TriggerResult.pigeonify(): PTriggerResult {
    return when (this) {
        is TriggerResult.PlacementNotFound -> PPlacementNotFoundTriggerResult()
        is TriggerResult.NoAudienceMatch -> PNoAudienceMatchTriggerResult()
        is TriggerResult.Paywall -> PPaywallTriggerResult(
            experiment = experiment.pigeonify()
        )
        is TriggerResult.Holdout -> PHoldoutTriggerResult(
            experiment = experiment.pigeonify()
        )
        is TriggerResult.Error -> PErrorTriggerResult(
            error = error.localizedMessage ?: "Unknown error"
        )
    }
}

fun Experiment.pigeonify(): PExperiment {
    return PExperiment(
        id = id,
        groupId = groupId,
        variant = variant.pigeonify()
    )
}

fun Experiment.Variant.pigeonify(): PVariant {
    return PVariant(
        id = id,
        type = when(this.type) {
            Experiment.Variant.VariantType.TREATMENT -> PVariantType.TREATMENT
            Experiment.Variant.VariantType.HOLDOUT -> PVariantType.HOLDOUT
        },
        paywallId = paywallId
    )
}
