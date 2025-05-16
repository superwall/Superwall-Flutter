import com.superwall.sdk.config.models.Survey
import com.superwall.sdk.config.models.SurveyOption
import com.superwall.sdk.config.models.SurveyShowCondition

fun Survey.pigeonify(): PSurvey {
    return PSurvey(
        id,assignmentKey,title,message, options.map { PSurveyOption(it.id,it.title) },
        presentationCondition.pigeonify(), presentationProbability, includeOtherOption, includeCloseOption
    )
}

fun SurveyShowCondition.pigeonify(): PSurveyShowCondition {
    return when (this) {
        SurveyShowCondition.ON_MANUAL_CLOSE -> PSurveyShowCondition.ON_MANUAL_CLOSE
        SurveyShowCondition.ON_PURCHASE -> PSurveyShowCondition.ON_PURCHASE
    }
}
