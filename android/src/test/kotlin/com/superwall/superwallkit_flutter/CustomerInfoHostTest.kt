package com.superwall.superwallkit_flutter

import PCustomerInfo
import com.superwall.sdk.Superwall
import com.superwall.sdk.models.customer.CustomerInfo
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.store.Entitlements
import io.flutter.plugin.common.BinaryMessenger
import org.mockito.ArgumentMatchers.any
import org.mockito.ArgumentMatchers.eq
import org.mockito.Mockito.mock
import org.mockito.Mockito.verify
import org.mockito.Mockito.`when`
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse

class CustomerInfoHostTest {
    private fun withSdk(test: (Superwall, SuperwallHost, BinaryMessenger) -> Unit) {
        val instanceField = Superwall::class.java.getDeclaredField("_instance").apply { isAccessible = true }
        val previous = instanceField.get(null)
        val sdk = mock(Superwall::class.java)
        instanceField.set(null, sdk)
        val messenger = mock(BinaryMessenger::class.java)
        val host = SuperwallHost(context = { error("No Application needed for customer-info reads") }, binaryMessenger = { messenger })
        try {
            test(sdk, host, messenger)
        } finally {
            host.dispose()
            instanceField.set(null, previous)
        }
    }

    @Test
    fun getterReturnsNativeSnapshotInsteadOfPlaceholder() = withSdk { sdk, host, _ ->
        val entitlement = Entitlement(id = "expired", isActive = false, productIds = setOf("monthly"))
        `when`(sdk.getCustomerInfo()).thenReturn(CustomerInfo(emptyList(), emptyList(), "customer", listOf(entitlement)))
        var result: PCustomerInfo? = null
        host.getCustomerInfo { result = it.getOrThrow() }
        assertEquals("customer", result!!.userId)
        assertEquals(listOf("monthly"), result!!.entitlements.single().productIds)
        assertFalse(result!!.entitlements.single().isActive)
        verify(sdk).getCustomerInfo()
    }

    @Test
    fun productLookupUsesNativeIdentifierMatchingAndPreservesDetails() = withSdk { sdk, host, _ ->
        val entitlements = mock(Entitlements::class.java)
        `when`(sdk.entitlements).thenReturn(entitlements)
        val ids = setOf("premium:monthly:trial", "unknown")
        `when`(entitlements.byProductIds(ids)).thenReturn(setOf(
            Entitlement(id = "premium", isActive = true, productIds = setOf("premium:monthly:trial")),
        ))
        val result = host.getEntitlementsByProductIds(ids.toList())
        verify(entitlements).byProductIds(ids)
        assertEquals("premium", result.single().id)
        assertEquals(listOf("premium:monthly:trial"), result.single().productIds)
    }

    @Test
    fun registersCustomerInfoChannelAndDisposesAfterNativeTeardown() = withSdk { _, host, messenger ->
        val channel = "dev.flutter.pigeon.superwallkit_flutter.SuperwallEventStreams.streamCustomerInfo"
        verify(messenger).setMessageHandler(eq(channel), any(BinaryMessenger.BinaryMessageHandler::class.java))
        host.setDelegate(true)
        Superwall::class.java.getDeclaredField("_instance").apply { isAccessible = true }.set(null, null)
        host.dispose()
        verify(messenger).setMessageHandler(channel, null)
    }
}
