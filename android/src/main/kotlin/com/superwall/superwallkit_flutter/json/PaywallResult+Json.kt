import com.superwall.sdk.paywall.presentation.internal.state.PaywallResult

fun PaywallResult.toJson(): Map<String, Any> =
    when (this) {
        is PaywallResult.Purchased ->
            mapOf(
                "type" to "purchased",
                "product" to
                    mapOf(
                        "productId" to this.productId,
                    ),
            )
        is PaywallResult.Declined ->
            mapOf(
                "type" to "declined",
            )
        is PaywallResult.Restored ->
            mapOf(
                "type" to "restored",
            )
    }
