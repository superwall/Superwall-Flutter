import com.superwall.sdk.analytics.superwall.TransactionProduct

fun TransactionProduct.toJson(): Map<String, Any> {
    return mapOf(
        "id" to id
    )
}
