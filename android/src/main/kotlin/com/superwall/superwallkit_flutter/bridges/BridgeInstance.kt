package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.superwallkit_flutter.BridgingCreator
import com.superwall.superwallkit_flutter.setBridgeId
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

typealias BridgeClass = String
typealias BridgeId = String
typealias Communicator = MethodChannel

abstract class BridgeInstance(
    val context: Context,
    val bridgeId: BridgeId,
    val initializationArgs: Map<String, Any>? = null
) : MethodChannel.MethodCallHandler {

    companion object {
        fun bridgeClass(): BridgeClass {
            throw NotImplementedError("Subclasses must implement")
        }
    }

    val communicator: Communicator by lazy {
        val communicator = MethodChannel(BridgingCreator.shared.flutterPluginBinding.binaryMessenger, bridgeId)
        communicator.setBridgeId(bridgeId);
        communicator
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
