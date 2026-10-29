package com.superwall.superwallkit_flutter

import PCustomerInfo
import PSuperwallDelegateGenerated
import com.superwall.sdk.models.customer.CustomerInfo
import com.superwall.sdk.models.entitlements.Entitlement
import io.flutter.plugin.common.BinaryMessenger
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.runTest
import kotlinx.coroutines.test.setMain
import org.mockito.ArgumentMatchers.any
import org.mockito.ArgumentMatchers.anyString
import org.mockito.Mockito.doAnswer
import org.mockito.Mockito.mock
import java.nio.ByteBuffer
import kotlin.test.Test
import kotlin.test.assertEquals

@OptIn(ExperimentalCoroutinesApi::class)
class CustomerInfoDelegateTest {
    @Test
    fun forwardsOldAndNewCustomerInfoOverPigeonAndStopsOnDispose() = runTest {
        Dispatchers.setMain(StandardTestDispatcher(testScheduler))
        try {
            val messages = mutableListOf<Pair<String, List<PCustomerInfo>>>()
            val messenger = mock(BinaryMessenger::class.java)
            doAnswer { invocation ->
                val buffer = invocation.getArgument<ByteBuffer>(1)
                buffer.flip()
                @Suppress("UNCHECKED_CAST")
                val values = PSuperwallDelegateGenerated.codec.decodeMessage(buffer) as List<PCustomerInfo>
                messages += invocation.getArgument<String>(0) to values
                val reply = PSuperwallDelegateGenerated.codec.encodeMessage(listOf(null))!!
                reply.flip()
                invocation.getArgument<BinaryMessenger.BinaryReply>(2).reply(reply)
                null
            }.`when`(messenger).send(anyString(), any(ByteBuffer::class.java), any(BinaryMessenger.BinaryReply::class.java))
            val delegate = SuperwallDelegateHost { PSuperwallDelegateGenerated(messenger) }
            val old = CustomerInfo(emptyList(), emptyList(), "old", emptyList())
            val updated = old.copy(userId = "new", entitlements = listOf(Entitlement("premium")))

            delegate.customerInfoDidChange(old, updated)
            testScheduler.runCurrent()
            val (channel, values) = messages.single()
            assertEquals("dev.flutter.pigeon.superwallkit_flutter.PSuperwallDelegateGenerated.customerInfoDidChange", channel)
            assertEquals(listOf("old", "new"), values.map { it.userId })
            assertEquals("premium", values[1].entitlements.single().id)

            delegate.dispose()
            delegate.customerInfoDidChange(updated, old)
            testScheduler.runCurrent()
            assertEquals(1, messages.size)
        } finally {
            Dispatchers.resetMain()
        }
    }
}
