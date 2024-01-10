import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.superwallkit_flutter.json.JsonExtensions
import java.util.EnumSet

fun JsonExtensions.Companion.superwallOptionsFromJson(dictionary: Map<String, Any?>): SuperwallOptions? {
    val paywallsValue = dictionary["paywalls"] as? Map<String, Any?> ?: return null
    val paywalls = JsonExtensions.Companion.paywallOptionsFromJson(paywallsValue) ?: return null
    val networkEnvironmentValue = dictionary["networkEnvironment"] as? String ?: return null
    val networkEnvironment = JsonExtensions.Companion.networkEnvironmentFromJson(networkEnvironmentValue) ?: return null
    val isExternalDataCollectionEnabled = dictionary["isExternalDataCollectionEnabled"] as? Boolean ?: return null
    val loggingValue = dictionary["logging"] as? Map<String, Any?> ?: return null
    val logging = JsonExtensions.Companion.loggingFromJson(loggingValue) ?: return null

    val localeIdentifier = dictionary["localeIdentifier"] as? String
    val isGameControllerEnabled = dictionary["isGameControllerEnabled"] as? Boolean ?: false

    return SuperwallOptions().apply {
        this.paywalls = paywalls
        this.networkEnvironment = networkEnvironment
        this.isExternalDataCollectionEnabled = isExternalDataCollectionEnabled
        this.localeIdentifier = localeIdentifier
        this.isGameControllerEnabled = isGameControllerEnabled
        this.logging = logging
    }
}

fun JsonExtensions.Companion.networkEnvironmentFromJson(json: String): SuperwallOptions.NetworkEnvironment? {
    return when (json) {
        "release" -> SuperwallOptions.NetworkEnvironment.Release()
        "releaseCandidate" -> SuperwallOptions.NetworkEnvironment.ReleaseCandidate()
        "developer" -> SuperwallOptions.NetworkEnvironment.Developer()
        else -> null
    }
}

fun JsonExtensions.Companion.loggingFromJson(dictionary: Map<String, Any?>): SuperwallOptions.Logging? {
    val levelString = dictionary["level"] as? String ?: return null
    val level = JsonExtensions.Companion.logLevelFromJson(levelString) ?: return null
    val scopeStrings = dictionary["scopes"] as? List<String> ?: return null

    val scopes = EnumSet.noneOf(LogScope::class.java)
    scopeStrings.forEach { scopeString ->
        JsonExtensions.Companion.logScopeFromJson(scopeString)?.let {
            scopes.add(it)
        }
    }
    if (scopes.isEmpty()) return null

    return SuperwallOptions.Logging().apply {
        this.level = level
        this.scopes = scopes
    }
}