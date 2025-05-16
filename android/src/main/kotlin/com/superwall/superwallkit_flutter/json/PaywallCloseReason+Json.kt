import com.superwall.sdk.paywall.presentation.PaywallCloseReason

fun PaywallCloseReason.pigeonify(): PPaywallCloseReason {
    return when (this) {
        PaywallCloseReason.SystemLogic -> PPaywallCloseReason.SYSTEM_LOGIC
        PaywallCloseReason.ForNextPaywall -> PPaywallCloseReason.FOR_NEXT_PAYWALL
        PaywallCloseReason.WebViewFailedToLoad -> PPaywallCloseReason.WEB_VIEW_FAILED_TO_LOAD
        PaywallCloseReason.ManualClose -> PPaywallCloseReason.MANUAL_CLOSE
        PaywallCloseReason.None -> PPaywallCloseReason.NONE
    }
}