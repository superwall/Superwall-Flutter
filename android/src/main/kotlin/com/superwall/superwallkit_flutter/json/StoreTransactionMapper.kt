import com.superwall.sdk.store.abstractions.transactions.StoreTransaction
import com.superwall.sdk.store.abstractions.transactions.StoreTransactionType
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Date


fun StoreTransaction.pigeonify(): PStoreTransaction {
    val dateFormatter = DateTimeFormatter.ISO_INSTANT

    fun Date.toIsoString(): String? = this.toInstant()
        .atZone(ZoneId.systemDefault())
        .format(dateFormatter)

    return PStoreTransaction(
        configRequestId = configRequestId,
        appSessionId = appSessionId,
        transactionDate = transactionDate?.toIsoString(),
        originalTransactionIdentifier = originalTransactionIdentifier?:"",
        storeTransactionId = storeTransactionId,
        originalTransactionDate = originalTransactionDate?.toIsoString(),
        webOrderLineItemID = webOrderLineItemID,
        appBundleId = appBundleId,
        subscriptionGroupId = subscriptionGroupId,
        isUpgraded = isUpgraded,
        expirationDate = expirationDate?.toIsoString(),
        offerId = offerId,
        revocationDate = revocationDate?.toIsoString()
    )
}

fun StoreTransactionType.pigeonify(): PStoreTransaction {
    val dateFormatter = DateTimeFormatter.ISO_INSTANT

    fun Date.toIsoString(): String? = this.toInstant()
        .atZone(ZoneId.systemDefault())
        .format(dateFormatter)

    return PStoreTransaction(
        configRequestId = "",
        appSessionId = "",
        transactionDate = transactionDate?.toIsoString(),
        originalTransactionIdentifier = originalTransactionIdentifier?:"",
        storeTransactionId = storeTransactionId,
        originalTransactionDate = originalTransactionDate?.toIsoString(),
        webOrderLineItemID = webOrderLineItemID,
        appBundleId = appBundleId,
        subscriptionGroupId = subscriptionGroupId,
        isUpgraded = isUpgraded,
        expirationDate = expirationDate?.toIsoString(),
        offerId = offerId,
        revocationDate = revocationDate?.toIsoString()
    )
}