package com.superwall.superwallkit_flutter.bridges
import com.superwall.sdk.models.triggers.Experiment
import toJson

class ExperimentBridge {
}

fun Experiment.toJson(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "groupId" to groupId,
        "variant" to variant.toJson()
    )
}