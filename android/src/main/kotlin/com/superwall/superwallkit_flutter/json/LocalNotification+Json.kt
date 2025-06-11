import com.superwall.sdk.models.paywall.LocalNotification
import com.superwall.sdk.models.paywall.LocalNotificationType

fun LocalNotification.toJson(): Map<String, Any?> {
    val json =
        mutableMapOf<String, Any?>(
            "type" to this.type.toJson(),
            "title" to this.title,
            "body" to this.body,
            "delay" to this.delay,
        )

    return json
}

fun LocalNotificationType.toJson(): String =
    when (this) {
        LocalNotificationType.TrialStarted -> "trialStarted"
        else -> ""
    }
