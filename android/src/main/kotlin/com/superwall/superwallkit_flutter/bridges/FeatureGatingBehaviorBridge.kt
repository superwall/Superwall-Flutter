import com.superwall.sdk.models.config.FeatureGatingBehavior

fun FeatureGatingBehavior.toJson(): String {
    return when (this) {
        FeatureGatingBehavior.Gated -> "gated"
        FeatureGatingBehavior.NonGated -> "nonGated"
    }
}