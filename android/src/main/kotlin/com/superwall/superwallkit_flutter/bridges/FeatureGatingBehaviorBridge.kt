import com.superwall.sdk.models.config.FeatureGatingBehavior

fun FeatureGatingBehavior.toJson(): String {
    return when (this) {
        FeatureGatingBehavior.Gated -> "gated"
        FeatureGatingBehavior.NonGated -> "nonGated"
    }
}

fun FeatureGatingBehavior.Companion.fromJson(json: String): FeatureGatingBehavior? {
    return when (json) {
        "gated" -> FeatureGatingBehavior.Gated
        "nonGated" -> FeatureGatingBehavior.NonGated
        else -> null
    }
}
