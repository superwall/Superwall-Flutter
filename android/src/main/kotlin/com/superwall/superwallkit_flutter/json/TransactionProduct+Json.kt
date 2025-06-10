import com.superwall.sdk.analytics.superwall.TransactionProduct

fun TransactionProduct.toJson(): Map<String, Any> =
    mapOf(
        "id" to id,
    )
