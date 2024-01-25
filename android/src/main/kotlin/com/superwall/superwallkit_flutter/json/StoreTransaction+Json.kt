import com.superwall.sdk.store.abstractions.transactions.StoreTransaction
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Date

fun StoreTransaction.toJson(): Map<String, Any?> {
    val dateFormatter = DateTimeFormatter.ISO_INSTANT

    fun Date.toIsoString(): String? = this.toInstant()
        .atZone(ZoneId.systemDefault())
        .format(dateFormatter)

    return mapOf(
        "configRequestId" to configRequestId,
        "appSessionId" to appSessionId,
        "transactionDate" to transactionDate?.toIsoString(),
        "originalTransactionIdentifier" to originalTransactionIdentifier,
        "storeTransactionId" to storeTransactionId,
        "originalTransactionDate" to originalTransactionDate?.toIsoString(),
        "webOrderLineItemID" to webOrderLineItemID,
        "appBundleId" to appBundleId,
        "subscriptionGroupId" to subscriptionGroupId,
        "isUpgraded" to isUpgraded,
        "expirationDate" to expirationDate?.toIsoString(),
        "offerId" to offerId,
        "revocationDate" to revocationDate?.toIsoString()
    )
}