package com.superwall.superwallkit_flutter

import com.superwall.superwallkit_flutter.bridges.BaseBridge
import com.superwall.superwallkit_flutter.bridges.CompletionBlockProxyBridge
import com.superwall.superwallkit_flutter.bridges.LogLevelBridge
import com.superwall.superwallkit_flutter.bridges.PaywallInfoBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseControllerProxyBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultBridge
import com.superwall.superwallkit_flutter.bridges.RestorationResultBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusBridge
import com.superwall.superwallkit_flutter.bridges.SuperwallBridge
import com.superwall.superwallkit_flutter.bridges.SuperwallDelegateProxyBridge
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class BridgingCreator(private val registrar: Registrar) : MethodCallHandler {
    private val instances: MutableMap<String, Any> = mutableMapOf()

    companion object {
        lateinit var shared: BridgingCreator

        // Define a map of bridge names to their respective classes
        private val bridgeMap: Map<String, Class<out BaseBridge>> = mapOf(
            "LogLevelBridge" to LogLevelBridge::class.java,
            "PaywallInfoBridge" to PaywallInfoBridge::class.java,
            "PurchaseControllerProxyBridge" to PurchaseControllerProxyBridge::class.java,
            "PurchaseResultBridge" to PurchaseResultBridge::class.java,
            "RestorationResultBridge" to RestorationResultBridge::class.java,
            "SubscriptionStatusBridge" to SubscriptionStatusBridge::class.java,
            "SuperwallDelegateProxyBridge" to SuperwallDelegateProxyBridge::class.java,
            "CompletionBlockProxyBridge" to CompletionBlockProxyBridge::class.java,
            "SuperwallBridge" to SuperwallBridge::class.java,
        )
    }

    // Generic function to retrieve a bridge instance
    fun <T> bridge(channelName: String): T? {
        return instances[channelName] as? T
    }

    fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(registrar.messenger(), "SWK_BridgingCreator")
        val bridge = BridgingCreator(registrar)
        shared = bridge
        channel.setMethodCallHandler(bridge)
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
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun createBridge(bridgeName: String, channelName: String) {
        val channel = MethodChannel(registrar.messenger(), channelName)

        val classType = bridgeMap[bridgeName]
        if (classType != null) {
            val bridgeClass = classType.kotlin
            val constructor = bridgeClass.constructors.firstOrNull()
                ?: throw IllegalStateException("No suitable constructor found for $bridgeClass")

            val bridge = constructor.call(channel) as BaseBridge
            instances[channelName] = bridge
            channel.setMethodCallHandler(bridge)
        } else {
            throw AssertionError("Unable to find a bridge type for $bridgeName. Make sure to add to BridgingCreator.")
        }
    }
}
