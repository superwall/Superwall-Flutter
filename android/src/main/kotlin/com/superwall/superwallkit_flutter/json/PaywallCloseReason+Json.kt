import com.superwall.sdk.paywall.presentation.PaywallCloseReason

fun PaywallCloseReason.toJson(): String {
    return when (this) {
        PaywallCloseReason.SystemLogic -> "systemLogic"
        PaywallCloseReason.ForNextPaywall -> "forNextPaywall"
        PaywallCloseReason.WebViewFailedToLoad -> "webViewFailedToLoad"
        PaywallCloseReason.ManualClose -> "manualClose"
        PaywallCloseReason.None -> "none"
    }
}