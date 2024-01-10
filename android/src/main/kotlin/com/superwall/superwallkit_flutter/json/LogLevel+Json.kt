import com.superwall.superwallkit_flutter.json.JsonExtensions

fun JsonExtensions.Companion.logLevelFromJson(json: String): LogLevel? {
    return when (json.lowercase()) {
        "debug" -> LogLevel.debug
        "info" -> LogLevel.info
        "warn" -> LogLevel.warn
        "error" -> LogLevel.error
        else -> null
    }
}