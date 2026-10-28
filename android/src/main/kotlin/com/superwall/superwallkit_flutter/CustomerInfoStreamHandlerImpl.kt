package com.superwall.superwallkit_flutter

import PCustomerInfo
import PigeonEventSink
import StreamCustomerInfoStreamHandler
import com.superwall.sdk.Superwall
import com.superwall.sdk.models.customer.CustomerInfo
import com.superwall.superwallkit_flutter.utils.CustomerInfoMapper
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

internal class CustomerInfoStreamHandlerImpl(
    private val scope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate),
    private val customerInfo: () -> StateFlow<CustomerInfo> = { Superwall.instance.customerInfo },
) : StreamCustomerInfoStreamHandler() {
    private var streamJob: Job? = null

    override fun onListen(arguments: Any?, sink: PigeonEventSink<PCustomerInfo>) {
        onCancel(null)
        val flow = try {
            customerInfo()
        } catch (error: IllegalStateException) {
            sink.error("not-configured", error.message, null)
            return
        }
        streamJob = scope.launch {
            flow.collect { sink.success(CustomerInfoMapper.toPigeon(it)) }
        }
    }

    override fun onCancel(arguments: Any?) {
        streamJob?.cancel()
        streamJob = null
    }

    fun dispose() {
        onCancel(null)
        scope.cancel()
    }
}
