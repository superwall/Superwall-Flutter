package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.store.abstractions.transactions.StorePayment
import com.superwall.sdk.store.abstractions.transactions.StoreTransaction
import com.superwall.sdk.store.abstractions.transactions.StoreTransactionState

fun StoreTransaction.toJson(): Map<String, Any?> {
    return mapOf(
        "configRequestId" to configRequestId,
        "appSessionId" to appSessionId,
        "triggerSessionId" to triggerSessionId,
        "transactionDate" to transactionDate?.time,
        "originalTransactionIdentifier" to originalTransactionIdentifier,
        "state" to state.toJson(),
        "storeTransactionId" to storeTransactionId,
        "payment" to payment?.toJson(),
        "originalTransactionDate" to originalTransactionDate?.time,
        "webOrderLineItemID" to webOrderLineItemID,
        "appBundleId" to appBundleId,
        "subscriptionGroupId" to subscriptionGroupId,
        "isUpgraded" to isUpgraded,
        "expirationDate" to expirationDate?.time,
        "offerId" to offerId,
        "revocationDate" to revocationDate?.time,
        "appAccountToken" to appAccountToken?.toString()
    )
}

fun StoreTransactionState.toJson(): String {
    return when (this) {
        StoreTransactionState.Purchasing -> "purchasing"
        StoreTransactionState.Purchased -> "purchased"
        StoreTransactionState.Failed -> "failed"
        StoreTransactionState.Restored -> "restored"
        StoreTransactionState.Deferred -> "deferred"
    }
}

fun StorePayment.toJson(): Map<String, Any?> {
    return mapOf(
        // TODO Uncomment when implemented in Android
        // "productIdentifier" to productIdentifier,
        "quantity" to quantity,
        "discountIdentifier" to discountIdentifier
    )
}