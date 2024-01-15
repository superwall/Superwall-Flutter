package com.superwall.superwallkit_flutter

import com.superwall.superwallkit_flutter.bridges.BridgeClass
import com.superwall.superwallkit_flutter.bridges.BridgeId
import com.superwall.superwallkit_flutter.bridges.BridgeInstance
import com.superwall.superwallkit_flutter.bridges.Communicator
import com.superwall.superwallkit_flutter.bridges.bridgeClass
import com.superwall.superwallkit_flutter.bridges.generateBridgeId
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class BridgingCreator(val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : MethodCallHandler {
    private val instances: MutableMap<String, BridgeInstance> = mutableMapOf()

    object Constants { }

    companion object {
        lateinit var shared: BridgingCreator

        fun register(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
            val communicator = Communicator(flutterPluginBinding.binaryMessenger, "SWK_BridgingCreator")
            val bridge = BridgingCreator(flutterPluginBinding)
            shared = bridge
            communicator.setMethodCallHandler(bridge)
        }
    }

    // Generic function to retrieve a bridge instance
    fun <T> bridgeInstance(bridgeId: BridgeId): T? {
        BreadCrumbs.append("BridgingCreator.kt: Searching for $bridgeId among ${instances.count()}: ${instances.toFormattedString()}")
        var instance = instances[bridgeId] as? T

        if (instance == null || bridgeId.contains("PaywallPresentationHandler")) {
            // No instance was found. When calling `invokeBridgeMethod` from Dart, make sure to provide any potentially uninitialized instances
            throw AssertionError("Unable to find a native instance for $bridgeId. Logs: ${BreadCrumbs.logs()}")
        }

        return instance
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "createBridgeInstance" -> {
                val bridgeId = call.argument<String>("bridgeId")
                val initializationArgs = call.argument<Map<String, Any>>("args")

                if (bridgeId != null) {
                    createBridgeInstanceFromBridgeId(bridgeId, initializationArgs)
                    result.success(null)
                } else {
                    println("WARNING: Unable to create bridge")
                    result.badArgs(call)
                }
            }
            else -> result.notImplemented()
        }
    }

    // Create the bridge instance as instructed from Dart
    private fun createBridgeInstanceFromBridgeId(bridgeId: BridgeId, initializationArgs: Map<String, Any>?): BridgeInstance {
        // An existing bridge instance might exist if it were created natively, instead of from Dart
        val existingBridgeInstance = instances[bridgeId]
        existingBridgeInstance?.let {
            return it
        }

        // Create an instance of the bridge
        val bridgeInstance = bridgeInitializers[bridgeId.bridgeClass()]?.invoke(flutterPluginBinding.applicationContext, bridgeId, initializationArgs)
        bridgeInstance?.let { bridgeInstance ->
            instances[bridgeId] = bridgeInstance
            bridgeInstance.communicator.setMethodCallHandler(bridgeInstance)
            return bridgeInstance
        } ?: run {
            throw AssertionError("Unable to find a bridge initializer for ${bridgeId}. Make sure to add to BridgingCreator+Constants.}")
        }
    }

    // Create the bridge instance as instructed from native
    fun createBridgeInstanceFromBridgeClass(bridgeClass: BridgeClass, initializationArgs: Map<String, Any>? = null): BridgeInstance {
        return createBridgeInstanceFromBridgeId(bridgeClass.generateBridgeId(), initializationArgs)
    }
}