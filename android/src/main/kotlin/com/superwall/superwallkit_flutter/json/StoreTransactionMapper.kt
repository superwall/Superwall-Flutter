import com.superwall.sdk.store.abstractions.transactions.StorePayment
import com.superwall.sdk.store.abstractions.transactions.StoreTransaction
import com.superwall.sdk.store.abstractions.transactions.StoreTransactionState
import com.superwall.sdk.store.abstractions.transactions.StoreTransactionType
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Date

fun StoreTransaction.pigeonify(): PStoreTransaction {
    val dateFormatter = DateTimeFormatter.ISO_INSTANT

    fun Date.toIsoString(): String? =
        this
            .toInstant()
            .atZone(ZoneId.systemDefault())
            .format(dateFormatter)

    return PStoreTransaction(
        configRequestId = configRequestId,
        appSessionId = appSessionId,
        transactionDate = transactionDate?.toIsoString(),
        originalTransactionIdentifier = originalTransactionIdentifier ?: "",
        storeTransactionId = storeTransactionId,
        originalTransactionDate = originalTransactionDate?.toIsoString(),
        webOrderLineItemID = webOrderLineItemID,
        appBundleId = appBundleId,
        subscriptionGroupId = subscriptionGroupId,
        isUpgraded = isUpgraded,
        expirationDate = expirationDate?.toIsoString(),
        offerId = offerId,
        revocationDate = revocationDate?.toIsoString(),
        state = state.pigeonify(),
        payment = payment?.pigeonify(),
        appAccountToken = appAccountToken,
        purchaseToken = purchaseToken,
        signature = signature,
    )
}

fun StoreTransactionType.pigeonify(): PStoreTransaction {
    val dateFormatter = DateTimeFormatter.ISO_INSTANT

    fun Date.toIsoString(): String? =
        this
            .toInstant()
            .atZone(ZoneId.systemDefault())
            .format(dateFormatter)

    return PStoreTransaction(
        configRequestId = "",
        appSessionId = "",
        transactionDate = transactionDate?.toIsoString(),
        originalTransactionIdentifier = originalTransactionIdentifier ?: "",
        storeTransactionId = storeTransactionId,
        originalTransactionDate = originalTransactionDate?.toIsoString(),
        webOrderLineItemID = webOrderLineItemID,
        appBundleId = appBundleId,
        subscriptionGroupId = subscriptionGroupId,
        isUpgraded = isUpgraded,
        expirationDate = expirationDate?.toIsoString(),
        offerId = offerId,
        revocationDate = revocationDate?.toIsoString(),
        state = state.pigeonify(),
        payment = payment?.pigeonify(),
        appAccountToken = appAccountToken,
        purchaseToken = purchaseToken,
        signature = signature,
    )
}

private fun StoreTransactionState.pigeonify(): PStoreTransactionState =
    when (this) {
        is StoreTransactionState.Purchasing -> PStoreTransactionState.PURCHASING
        is StoreTransactionState.Purchased -> PStoreTransactionState.PURCHASED
        is StoreTransactionState.Failed -> PStoreTransactionState.FAILED
        is StoreTransactionState.Restored -> PStoreTransactionState.RESTORED
        is StoreTransactionState.Deferred -> PStoreTransactionState.DEFERRED
    }

private fun StorePayment.pigeonify(): PStorePayment =
    PStorePayment(
        productIdentifier = productIdentifier,
        quantity = quantity.toLong(),
        discountIdentifier = discountIdentifier,
    )
