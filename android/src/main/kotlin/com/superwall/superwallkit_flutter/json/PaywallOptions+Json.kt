import com.superwall.sdk.config.options.PaywallOptions
import com.superwall.superwallkit_flutter.json.JsonExtensions

fun JsonExtensions.Companion.paywallOptionsFromJson(dictionary: Map<String, Any?>): PaywallOptions? {
    val isHapticFeedbackEnabled = dictionary["isHapticFeedbackEnabled"] as? Boolean ?: return null
    val restoreFailedValue = dictionary["restoreFailed"] as? Map<String, Any?> ?: return null
    val shouldShowPurchaseFailureAlert = dictionary["shouldShowPurchaseFailureAlert"] as? Boolean ?: return null
    val shouldPreload = dictionary["shouldPreload"] as? Boolean ?: return null
    val automaticallyDismiss = dictionary["automaticallyDismiss"] as? Boolean ?: return null
    val transactionBackgroundViewValue = dictionary["transactionBackgroundView"] as? String ?: return null

    val restoreFailed = restoreFailedFromJson(restoreFailedValue) ?: return null
    val transactionBackgroundView = transactionBackgroundViewFromJson(transactionBackgroundViewValue) ?: return null

    return PaywallOptions().apply {
        this.isHapticFeedbackEnabled = isHapticFeedbackEnabled
        this.restoreFailed = restoreFailed
        this.shouldShowPurchaseFailureAlert = shouldShowPurchaseFailureAlert
        this.shouldPreload = shouldPreload
        this.automaticallyDismiss = automaticallyDismiss
        this.transactionBackgroundView = transactionBackgroundView
    }
}

fun JsonExtensions.Companion.restoreFailedFromJson(dictionary: Map<String, Any?>): PaywallOptions.RestoreFailed? {
    val title = dictionary["title"] as? String ?: return null
    val message = dictionary["message"] as? String ?: return null
    val closeButtonTitle = dictionary["closeButtonTitle"] as? String ?: return null

    return PaywallOptions.RestoreFailed().apply {
        this.title = title
        this.message = message
        this.closeButtonTitle = closeButtonTitle
    }
}

fun JsonExtensions.Companion.transactionBackgroundViewFromJson(json: String): PaywallOptions.TransactionBackgroundView? {
    return when (json) {
        "spinner" -> PaywallOptions.TransactionBackgroundView.SPINNER
        // TODO: Add None case to Android SDK
        "none" -> null
        else -> null
    }
}