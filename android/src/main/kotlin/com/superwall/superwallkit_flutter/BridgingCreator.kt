package com.superwall.superwallkit_flutter

import com.superwall.superwallkit_flutter.bridges.BaseBridge
import com.superwall.superwallkit_flutter.bridges.CompletionBlockProxyBridge
import com.superwall.superwallkit_flutter.bridges.PaywallPresentationHandlerProxyBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseControllerProxyBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusActiveBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusInactiveBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusUnknownBridge
import com.superwall.superwallkit_flutter.bridges.SuperwallBridge
import com.superwall.superwallkit_flutter.bridges.SuperwallDelegateProxyBridge
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class BridgingCreator(private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : MethodCallHandler {
    private val instances: MutableMap<String, Any> = mutableMapOf()

    companion object {
        lateinit var shared: BridgingCreator

        // Define a map of bridge names to their respective classes
        private val bridgeMap: Map<String, Class<out BaseBridge>> = mapOf(
            "SuperwallBridge" to SuperwallBridge::class.java,
            "SuperwallDelegateProxyBridge" to SuperwallDelegateProxyBridge::class.java,
            "PurchaseControllerProxyBridge" to PurchaseControllerProxyBridge::class.java,
            "CompletionBlockProxyBridge" to CompletionBlockProxyBridge::class.java,
            "SubscriptionStatusActiveBridge" to SubscriptionStatusActiveBridge::class.java,
            "SubscriptionStatusInactiveBridge" to SubscriptionStatusInactiveBridge::class.java,
            "SubscriptionStatusUnknownBridge" to SubscriptionStatusUnknownBridge::class.java,
            "PaywallPresentationHandlerProxyBridge" to PaywallPresentationHandlerProxyBridge::class.java,
        )

        fun register(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
            val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "SWK_BridgingCreator")
            val bridge = BridgingCreator(flutterPluginBinding)
            shared = bridge
            channel.setMethodCallHandler(bridge)
        }
    }

    // Generic function to retrieve a bridge instance
    fun <T> bridge(channelName: String): T? {
        var instance = instances[channelName] as? T

        if (instance == null) {
            val bridgeName = channelName.substringBefore("-")
            if (bridgeName.isEmpty()) {
                throw AssertionError("Unable to parse bridge name from $channelName.")
            }

            instance = createBridge(bridgeName, channelName) as? T
            if (instance == null) {
                throw AssertionError("Unable to create bridge for $channelName.")
            }
        }

        return instance
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "createBridge" -> {
                val bridgeName = call.argument<String>("bridgeName")
                val channelName = call.argument<String>("channelName")

                if (bridgeName != null && channelName != null) {
                    createBridge(bridgeName, channelName)
                    result.success(null)
                } else {
                    println("WARNING: Unable to create bridge")
                    result.badArgs(call)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun createBridge(bridgeName: String, channelName: String): BaseBridge? {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)

        val classType = bridgeMap[bridgeName]
        classType?.let { classType ->
            try {
                // Use Java reflection to find the constructor
                val constructor = classType.getConstructor(MethodChannel::class.java, FlutterPlugin.FlutterPluginBinding::class.java)

                // Create an instance of the bridge
                val bridge = constructor.newInstance(channel, flutterPluginBinding) as BaseBridge

                instances[channelName] = bridge
                channel.setMethodCallHandler(bridge)
                return bridge

            } catch (e: NoSuchMethodException) {
                throw AssertionError("No suitable constructor found for $classType", e)
            } catch (e: Exception) {
                throw AssertionError("Error creating an instance of $classType", e)
            }
        } ?: run {
            throw AssertionError("Unable to find a bridge type for $bridgeName. Make sure to add to BridgingCreator.")
        }
    }
}

fun String.toJson(): Map<String, String> {
    return mapOf("value" to this)
}