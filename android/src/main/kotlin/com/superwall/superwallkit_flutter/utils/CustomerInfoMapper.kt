package com.superwall.superwallkit_flutter.utils

import PCustomerInfo
import PEntitlement
import PEntitlementType
import PLatestSubscriptionOfferType
import PLatestSubscriptionState
import PNonSubscriptionTransaction
import PProductStore
import PSubscriptionTransaction
import com.superwall.sdk.models.customer.CustomerInfo
import com.superwall.sdk.models.customer.NonSubscriptionTransaction
import com.superwall.sdk.models.customer.SubscriptionTransaction
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.product.Store
import com.superwall.sdk.store.abstractions.product.receipt.LatestPeriodType
import com.superwall.sdk.store.abstractions.product.receipt.LatestSubscriptionState

object CustomerInfoMapper {
    fun toPigeon(customerInfo: CustomerInfo): PCustomerInfo =
        PCustomerInfo(
            subscriptions = customerInfo.subscriptions.map(::toPigeon),
            nonSubscriptions = customerInfo.nonSubscriptions.map(::toPigeon),
            entitlements = customerInfo.entitlements.map(::toPigeon),
            userId = customerInfo.userId,
        )

    fun toPigeon(entitlement: Entitlement): PEntitlement =
        PEntitlement(
            id = entitlement.id,
            type = when (entitlement.type) {
                Entitlement.Type.SERVICE_LEVEL -> PEntitlementType.SERVICE_LEVEL
            },
            isActive = entitlement.isActive,
            productIds = entitlement.productIds.toList(),
            latestProductId = entitlement.latestProductId,
            store = entitlement.store?.let(::toPigeon),
            startsAt = entitlement.startsAt?.time,
            renewedAt = entitlement.renewedAt?.time,
            expiresAt = entitlement.expiresAt?.time,
            isLifetime = entitlement.isLifetime,
            willRenew = entitlement.willRenew,
            state = entitlement.state?.let(::toPigeon),
            offerType = entitlement.offerType?.let(::toPigeon),
        )

    private fun toPigeon(transaction: SubscriptionTransaction): PSubscriptionTransaction =
        PSubscriptionTransaction(
            transactionId = transaction.transactionId,
            productId = transaction.productId,
            purchaseDate = transaction.purchaseDate.time,
            willRenew = transaction.willRenew,
            isRevoked = transaction.isRevoked,
            isInGracePeriod = transaction.isInGracePeriod,
            isInBillingRetryPeriod = transaction.isInBillingRetryPeriod,
            isActive = transaction.isActive,
            expirationDate = transaction.expirationDate?.time,
            offerType = transaction.offerType?.let(::toPigeon),
            subscriptionGroupId = transaction.subscriptionGroupId,
            store = toPigeon(transaction.store),
        )

    private fun toPigeon(transaction: NonSubscriptionTransaction): PNonSubscriptionTransaction =
        PNonSubscriptionTransaction(
            transactionId = transaction.transactionId,
            productId = transaction.productId,
            purchaseDate = transaction.purchaseDate.time,
            isConsumable = transaction.isConsumable,
            isRevoked = transaction.isRevoked,
            store = toPigeon(transaction.store),
        )

    private fun toPigeon(store: Store): PProductStore =
        when (store) {
            Store.APP_STORE -> PProductStore.APP_STORE
            Store.PLAY_STORE -> PProductStore.PLAY_STORE
            Store.STRIPE -> PProductStore.STRIPE
            Store.PADDLE -> PProductStore.PADDLE
            Store.SUPERWALL -> PProductStore.SUPERWALL
            Store.CUSTOM, Store.OTHER -> PProductStore.OTHER
        }

    private fun toPigeon(state: LatestSubscriptionState): PLatestSubscriptionState? =
        when (state) {
            LatestSubscriptionState.GRACE_PERIOD -> PLatestSubscriptionState.IN_GRACE_PERIOD
            LatestSubscriptionState.SUBSCRIBED -> PLatestSubscriptionState.SUBSCRIBED
            LatestSubscriptionState.EXPIRED -> PLatestSubscriptionState.EXPIRED
            LatestSubscriptionState.BILLING_RETRY -> PLatestSubscriptionState.IN_BILLING_RETRY_PERIOD
            LatestSubscriptionState.REVOKED -> PLatestSubscriptionState.REVOKED
            LatestSubscriptionState.UNKNOWN -> null
        }

    private fun toPigeon(offerType: LatestPeriodType): PLatestSubscriptionOfferType? =
        when (offerType) {
            LatestPeriodType.TRIAL -> PLatestSubscriptionOfferType.TRIAL
            LatestPeriodType.CODE -> PLatestSubscriptionOfferType.CODE
            LatestPeriodType.PROMOTIONAL -> PLatestSubscriptionOfferType.PROMOTIONAL
            LatestPeriodType.WINBACK -> PLatestSubscriptionOfferType.WINBACK
            // The Flutter offer enum represents offers, not regular or revoked periods.
            LatestPeriodType.SUBSCRIPTION, LatestPeriodType.REVOKED -> null
        }
}
