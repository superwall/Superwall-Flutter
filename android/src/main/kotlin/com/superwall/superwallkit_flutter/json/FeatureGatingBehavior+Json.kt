import com.superwall.sdk.models.config.FeatureGatingBehavior

fun FeatureGatingBehavior.toJson(): String =
    when (this) {
        FeatureGatingBehavior.Gated -> "gated"
        FeatureGatingBehavior.NonGated -> "nonGated"
    }

fun FeatureGatingBehavior.Companion.fromJson(json: String): FeatureGatingBehavior? =
    when (json) {
        "gated" -> FeatureGatingBehavior.Gated
        "nonGated" -> FeatureGatingBehavior.NonGated
        else -> null
    }
