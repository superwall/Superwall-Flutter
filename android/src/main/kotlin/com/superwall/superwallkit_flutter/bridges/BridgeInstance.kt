package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.superwallkit_flutter.BridgingCreator
import com.superwall.superwallkit_flutter.setBridgeId
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.first

typealias BridgeClass = String
typealias BridgeId = String
typealias Communicator = MethodChannel

abstract class BridgeInstance(
    val context: Context,
    val bridgeId: BridgeId,
    val initializationArgs: Map<String, Any>? = null,
) : MethodChannel.MethodCallHandler {

    private val mainScope: CoroutineScope = CoroutineScope(Dispatchers.IO)

    companion object {
        fun bridgeClass(): BridgeClass {
            throw NotImplementedError("Subclasses must implement")
        }
    }

    private var communicatorFlow: MutableStateFlow<Communicator?> = MutableStateFlow(null)

    suspend fun communicator(): Communicator {
        synchronized(this@BridgeInstance) {
            if (communicatorFlow.value == null) {
                mainScope.launch {

                    val communicator = MethodChannel(
                        BridgingCreator.shared().flutterPluginBinding().binaryMessenger,
                        bridgeId
                    )
                    communicator.setBridgeId(bridgeId);
                    communicatorFlow.value = communicator
                }
            }
        }
        return communicatorFlow.filterNotNull().first()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {}
}

fun BridgeId.bridgeClass(): BridgeClass {
    val bridgeClass = this.split("-").firstOrNull()
    return bridgeClass ?: throw IllegalArgumentException("Unable to parse bridge class from $this.")
}

fun BridgeClass.generateBridgeId(): BridgeId {
    return "$this-bridgeId"
}
