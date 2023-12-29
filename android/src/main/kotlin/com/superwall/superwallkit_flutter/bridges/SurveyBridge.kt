package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.config.models.Survey
import com.superwall.sdk.config.models.SurveyOption
import com.superwall.sdk.config.models.SurveyShowCondition

fun Survey.toJson(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "assignmentKey" to assignmentKey,
        "title" to title,
        "message" to message,
        "options" to options.map { it.toJson() },
        "presentationCondition" to presentationCondition.toJson(),
        "presentationProbability" to presentationProbability,
        "includeOtherOption" to includeOtherOption,
        "includeCloseOption" to includeCloseOption
    )
}

fun SurveyOption.toJson(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "title" to title
    )
}

fun SurveyShowCondition.toJson(): String {
    return when (this) {
        SurveyShowCondition.ON_MANUAL_CLOSE -> "onManualClose"
        SurveyShowCondition.ON_PURCHASE -> "onPurchase"
    }
}