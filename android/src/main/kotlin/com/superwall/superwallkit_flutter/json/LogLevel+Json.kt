import com.superwall.sdk.logger.LogLevel
import com.superwall.superwallkit_flutter.json.JsonExtensions

fun JsonExtensions.Companion.logLevelFromJson(json: String): LogLevel? =
    when (json.lowercase()) {
        "debug" -> LogLevel.debug
        "info" -> LogLevel.info
        "warn" -> LogLevel.warn
        "error" -> LogLevel.error
        "none" -> LogLevel.none
        else -> null
    }

fun LogLevel.toJson(): String =
    when (this) {
        LogLevel.debug -> "debug"
        LogLevel.info -> "info"
        LogLevel.warn -> "warn"
        LogLevel.error -> "error"
        LogLevel.none -> "none"
        else -> "unknown"
    }
