package com.superwall.superwallkit_flutter

import PEntitlementType
import PLatestSubscriptionOfferType
import PLatestSubscriptionState
import PProductStore
import com.superwall.sdk.models.customer.CustomerInfo
import com.superwall.sdk.models.customer.NonSubscriptionTransaction
import com.superwall.sdk.models.customer.SubscriptionTransaction
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.product.Store
import com.superwall.sdk.store.abstractions.product.receipt.LatestPeriodType
import com.superwall.sdk.store.abstractions.product.receipt.LatestSubscriptionState
import com.superwall.superwallkit_flutter.utils.CustomerInfoMapper
import java.util.Date
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertTrue

class CustomerInfoMapperTest {
    private val purchaseTime = 1_760_000_000_123L
    private val renewalTime = 1_761_000_000_456L
    private val expiryTime = 1_762_000_000_789L

    private fun subscription() = SubscriptionTransaction(
        transactionId = "trial-transaction",
        productId = "premium:monthly:trial",
        purchaseDate = Date(purchaseTime),
        willRenew = true,
        isRevoked = false,
        isInGracePeriod = false,
        isInBillingRetryPeriod = false,
        isActive = true,
        expirationDate = Date(expiryTime),
        store = Store.PLAY_STORE,
        offerType = LatestPeriodType.TRIAL,
        subscriptionGroupId = "premium-group",
    )

    private fun entitlement() = Entitlement(
        id = "premium",
        type = Entitlement.Type.SERVICE_LEVEL,
        isActive = true,
        productIds = linkedSetOf("premium:monthly:trial", "premium:yearly"),
        latestProductId = "premium:monthly:trial",
        startsAt = Date(purchaseTime),
        renewedAt = Date(renewalTime),
        expiresAt = Date(expiryTime),
        isLifetime = false,
        willRenew = true,
        state = LatestSubscriptionState.SUBSCRIBED,
        offerType = LatestPeriodType.TRIAL,
        store = Store.PLAY_STORE,
    )

    @Test
    fun customerInfoPreservesTransactionsEntitlementsAndOrder() {
        val trial = subscription()
        val revoked = trial.copy(
            transactionId = "old-transaction",
            productId = "premium:yearly",
            willRenew = false,
            isRevoked = true,
            isInGracePeriod = true,
            isInBillingRetryPeriod = true,
            isActive = false,
            expirationDate = null,
            offerType = LatestPeriodType.REVOKED,
            subscriptionGroupId = null,
            store = Store.STRIPE,
        )
        val oneTime = NonSubscriptionTransaction(
            transactionId = "lifetime-transaction",
            productId = "premium-lifetime",
            purchaseDate = Date(purchaseTime),
            isConsumable = false,
            isRevoked = true,
            store = Store.PADDLE,
        )
        val result = CustomerInfoMapper.toPigeon(
            CustomerInfo(
                subscriptions = listOf(revoked, trial),
                nonSubscriptions = listOf(oneTime, oneTime.copy(isConsumable = true, isRevoked = false)),
                entitlements = listOf(entitlement(), entitlement().copy(id = "expired", isActive = false)),
                userId = "test-customer",
            ),
        )

        assertEquals("test-customer", result.userId)
        assertEquals(listOf("old-transaction", "trial-transaction"), result.subscriptions.map { it.transactionId })
        val mappedTrial = result.subscriptions[1]
        assertEquals(trial.productId, mappedTrial.productId)
        assertEquals(purchaseTime, mappedTrial.purchaseDate)
        assertEquals(expiryTime, mappedTrial.expirationDate)
        assertTrue(mappedTrial.willRenew)
        assertFalse(mappedTrial.isRevoked)
        assertFalse(mappedTrial.isInGracePeriod)
        assertFalse(mappedTrial.isInBillingRetryPeriod)
        assertTrue(mappedTrial.isActive)
        assertEquals(PLatestSubscriptionOfferType.TRIAL, mappedTrial.offerType)
        assertEquals("premium-group", mappedTrial.subscriptionGroupId)
        assertEquals(PProductStore.PLAY_STORE, mappedTrial.store)

        val mappedRevoked = result.subscriptions[0]
        assertFalse(mappedRevoked.willRenew)
        assertTrue(mappedRevoked.isRevoked)
        assertTrue(mappedRevoked.isInGracePeriod)
        assertTrue(mappedRevoked.isInBillingRetryPeriod)
        assertFalse(mappedRevoked.isActive)
        assertNull(mappedRevoked.expirationDate)
        assertNull(mappedRevoked.offerType)
        assertNull(mappedRevoked.subscriptionGroupId)
        assertEquals(PProductStore.STRIPE, mappedRevoked.store)

        assertEquals(2, result.nonSubscriptions.size)
        val mappedOneTime = result.nonSubscriptions[0]
        assertEquals(oneTime.transactionId, mappedOneTime.transactionId)
        assertEquals(oneTime.productId, mappedOneTime.productId)
        assertEquals(purchaseTime, mappedOneTime.purchaseDate)
        assertFalse(mappedOneTime.isConsumable)
        assertTrue(mappedOneTime.isRevoked)
        assertEquals(PProductStore.PADDLE, mappedOneTime.store)
        assertTrue(result.nonSubscriptions[1].isConsumable)
        assertFalse(result.nonSubscriptions[1].isRevoked)
        assertEquals(listOf("premium", "expired"), result.entitlements.map { it.id })
        assertFalse(result.entitlements[1].isActive)
    }

    @Test
    fun entitlementPreservesAllDetailsAndMillisecondDates() {
        val result = CustomerInfoMapper.toPigeon(entitlement())

        assertEquals("premium", result.id)
        assertEquals(PEntitlementType.SERVICE_LEVEL, result.type)
        assertTrue(result.isActive)
        assertEquals(listOf("premium:monthly:trial", "premium:yearly"), result.productIds)
        assertEquals("premium:monthly:trial", result.latestProductId)
        assertEquals(PProductStore.PLAY_STORE, result.store)
        assertEquals(purchaseTime, result.startsAt)
        assertEquals(renewalTime, result.renewedAt)
        assertEquals(expiryTime, result.expiresAt)
        assertEquals(false, result.isLifetime)
        assertEquals(true, result.willRenew)
        assertEquals(PLatestSubscriptionState.SUBSCRIBED, result.state)
        assertEquals(PLatestSubscriptionOfferType.TRIAL, result.offerType)
    }

    @Test
    fun entitlementPreservesUnknownDetailsAndLifetimeValues() {
        val result = CustomerInfoMapper.toPigeon(Entitlement(id = "manual", isActive = false))

        assertFalse(result.isActive)
        assertTrue(result.productIds.isEmpty())
        assertNull(result.latestProductId)
        assertNull(result.store)
        assertNull(result.startsAt)
        assertNull(result.renewedAt)
        assertNull(result.expiresAt)
        assertNull(result.isLifetime)
        assertNull(result.willRenew)
        assertNull(result.state)
        assertNull(result.offerType)

        val lifetime = CustomerInfoMapper.toPigeon(entitlement().copy(isLifetime = true, willRenew = false, expiresAt = null))
        assertEquals(true, lifetime.isLifetime)
        assertEquals(false, lifetime.willRenew)
        assertNull(lifetime.expiresAt)
    }

    @Test
    fun mapsEveryNativeStateWithoutFabricatingUnknownState() {
        val states = mapOf(
            LatestSubscriptionState.GRACE_PERIOD to PLatestSubscriptionState.IN_GRACE_PERIOD,
            LatestSubscriptionState.SUBSCRIBED to PLatestSubscriptionState.SUBSCRIBED,
            LatestSubscriptionState.EXPIRED to PLatestSubscriptionState.EXPIRED,
            LatestSubscriptionState.BILLING_RETRY to PLatestSubscriptionState.IN_BILLING_RETRY_PERIOD,
            LatestSubscriptionState.REVOKED to PLatestSubscriptionState.REVOKED,
            LatestSubscriptionState.UNKNOWN to null,
        )
        assertEquals(LatestSubscriptionState.values().toSet(), states.keys)
        states.forEach { (native, expected) ->
            assertEquals(expected, CustomerInfoMapper.toPigeon(entitlement().copy(state = native)).state, native.name)
        }
    }

    @Test
    fun mapsEveryNativeOfferForEntitlementsAndTransactions() {
        val offers = mapOf(
            LatestPeriodType.TRIAL to PLatestSubscriptionOfferType.TRIAL,
            LatestPeriodType.CODE to PLatestSubscriptionOfferType.CODE,
            LatestPeriodType.PROMOTIONAL to PLatestSubscriptionOfferType.PROMOTIONAL,
            LatestPeriodType.WINBACK to PLatestSubscriptionOfferType.WINBACK,
            LatestPeriodType.SUBSCRIPTION to null,
            LatestPeriodType.REVOKED to null,
        )
        assertEquals(LatestPeriodType.values().toSet(), offers.keys)
        offers.forEach { (native, expected) ->
            val result = CustomerInfoMapper.toPigeon(
                CustomerInfo(
                    subscriptions = listOf(subscription().copy(offerType = native)),
                    nonSubscriptions = emptyList(),
                    entitlements = listOf(entitlement().copy(offerType = native)),
                ),
            )
            assertEquals(expected, result.subscriptions.single().offerType, native.name)
            assertEquals(expected, result.entitlements.single().offerType, native.name)
        }
    }

    @Test
    fun mapsEveryNativeStoreAcrossAllCustomerInfoModels() {
        val stores = mapOf(
            Store.PLAY_STORE to PProductStore.PLAY_STORE,
            Store.APP_STORE to PProductStore.APP_STORE,
            Store.STRIPE to PProductStore.STRIPE,
            Store.PADDLE to PProductStore.PADDLE,
            Store.SUPERWALL to PProductStore.SUPERWALL,
            Store.CUSTOM to PProductStore.OTHER,
            Store.OTHER to PProductStore.OTHER,
        )
        assertEquals(Store.values().toSet(), stores.keys)
        stores.forEach { (native, expected) ->
            val result = CustomerInfoMapper.toPigeon(
                CustomerInfo(
                    subscriptions = listOf(subscription().copy(store = native)),
                    nonSubscriptions = listOf(NonSubscriptionTransaction.empty().copy(store = native)),
                    entitlements = listOf(entitlement().copy(store = native)),
                ),
            )
            assertEquals(expected, result.subscriptions.single().store, native.name)
            assertEquals(expected, result.nonSubscriptions.single().store, native.name)
            assertEquals(expected, result.entitlements.single().store, native.name)
        }
    }

    @Test
    fun emptySnapshotRemainsEmpty() {
        val result = CustomerInfoMapper.toPigeon(CustomerInfo.empty())
        assertEquals("", result.userId)
        assertTrue(result.subscriptions.isEmpty())
        assertTrue(result.nonSubscriptions.isEmpty())
        assertTrue(result.entitlements.isEmpty())
    }
}
