package com.superwall.superwallkit_flutter

import PCustomerInfo
import PigeonEventSink
import com.superwall.sdk.models.customer.CustomerInfo
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.runTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse

@OptIn(ExperimentalCoroutinesApi::class)
class CustomerInfoStreamHandlerTest {
    private fun snapshot(userId: String) = CustomerInfo(
        subscriptions = emptyList(),
        nonSubscriptions = emptyList(),
        entitlements = emptyList(),
        userId = userId,
    )

    private class RecordingSink : EventChannel.EventSink {
        val values = mutableListOf<PCustomerInfo>()
        val errors = mutableListOf<String>()
        val pigeon = PigeonEventSink<PCustomerInfo>(this)

        override fun success(value: Any?) { values += value as PCustomerInfo }
        override fun error(code: String, message: String?, details: Any?) { errors += code }
        override fun endOfStream() = Unit
    }

    @Test
    fun listenEmitsSnapshotAndUpdatesThenCancelStopsDelivery() = runTest {
        val flow = MutableStateFlow(snapshot("initial"))
        val scope = CoroutineScope(SupervisorJob() + StandardTestDispatcher(testScheduler))
        val handler = CustomerInfoStreamHandlerImpl(scope) { flow }
        val sink = RecordingSink()

        handler.onListen(null, sink.pigeon)
        testScheduler.runCurrent()
        flow.value = snapshot("updated")
        testScheduler.runCurrent()
        assertEquals(listOf("initial", "updated"), sink.values.map { it.userId })

        handler.onCancel(null)
        flow.value = snapshot("after-cancel")
        testScheduler.runCurrent()
        assertEquals(2, sink.values.size)

        handler.onListen(null, sink.pigeon)
        testScheduler.runCurrent()
        assertEquals("after-cancel", sink.values.last().userId)
        handler.dispose()
    }

    @Test
    fun repeatedListenReplacesCollectorAndDisposeReleasesIt() = runTest {
        val flow = MutableStateFlow(snapshot("initial"))
        val job = SupervisorJob()
        val handler = CustomerInfoStreamHandlerImpl(
            CoroutineScope(job + StandardTestDispatcher(testScheduler)),
        ) { flow }
        val oldSink = RecordingSink()
        val newSink = RecordingSink()

        handler.onListen(null, oldSink.pigeon)
        testScheduler.runCurrent()
        handler.onListen(null, newSink.pigeon)
        testScheduler.runCurrent()
        assertEquals(1, flow.subscriptionCount.value)
        flow.value = snapshot("updated")
        testScheduler.runCurrent()
        assertEquals(listOf("initial"), oldSink.values.map { it.userId })
        assertEquals(listOf("initial", "updated"), newSink.values.map { it.userId })

        handler.dispose()
        testScheduler.runCurrent()
        assertFalse(job.isActive)
        assertEquals(0, flow.subscriptionCount.value)
        flow.value = snapshot("after-dispose")
        testScheduler.runCurrent()
        assertEquals(2, newSink.values.size)
    }

    @Test
    fun preConfigureListenReportsErrorAndCanBeRetried() = runTest {
        val flow = MutableStateFlow(snapshot("configured"))
        var configured = false
        val handler = CustomerInfoStreamHandlerImpl(
            CoroutineScope(SupervisorJob() + StandardTestDispatcher(testScheduler)),
        ) {
            check(configured) { "Superwall has not been initialized or configured." }
            flow
        }
        val sink = RecordingSink()
        handler.onListen(null, sink.pigeon)
        assertEquals(listOf("not-configured"), sink.errors)
        assertEquals(0, flow.subscriptionCount.value)

        configured = true
        handler.onListen(null, sink.pigeon)
        testScheduler.runCurrent()
        assertEquals("configured", sink.values.single().userId)
        handler.dispose()
    }
}
