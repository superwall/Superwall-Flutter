import com.superwall.sdk.config.models.Survey
import com.superwall.sdk.config.models.SurveyOption
import com.superwall.sdk.config.models.SurveyShowCondition

fun Survey.toJson(): Map<String, Any> {
    return mapOf(
        "id" to this.id,
        "assignmentKey" to this.assignmentKey,
        "title" to this.title,
        "message" to this.message,
        "options" to this.options.map { it.toJson() },
        "presentationCondition" to this.presentationCondition.toJson(),
        "presentationProbability" to this.presentationProbability,
        "includeOtherOption" to this.includeOtherOption,
        "includeCloseOption" to this.includeCloseOption
    )
}

fun SurveyOption.toJson(): Map<String, Any> {
    return mapOf(
        "id" to this.id,
        "title" to this.title
    )
}

fun SurveyShowCondition.toJson(): String {
    return when (this) {
        SurveyShowCondition.ON_MANUAL_CLOSE -> "onManualClose"
        SurveyShowCondition.ON_PURCHASE -> "onPurchase"
    }
}
