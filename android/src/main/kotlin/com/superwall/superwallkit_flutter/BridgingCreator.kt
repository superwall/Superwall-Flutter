package com.superwall.superwallkit_flutter

import android.content.Context
import com.superwall.superwallkit_flutter.bridges.BridgeClass
import com.superwall.superwallkit_flutter.bridges.BridgeId
import com.superwall.superwallkit_flutter.bridges.BridgeInstance
import com.superwall.superwallkit_flutter.bridges.Communicator
import com.superwall.superwallkit_flutter.bridges.CompletionBlockProxyBridge
import com.superwall.superwallkit_flutter.bridges.ExperimentBridge
import com.superwall.superwallkit_flutter.bridges.PaywallInfoBridge
import com.superwall.superwallkit_flutter.bridges.PaywallPresentationHandlerProxyBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonEventNotFoundBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonHoldoutBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonNoRuleMatchBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonUserIsSubscribedBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseControllerProxyBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultCancelledBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultFailedBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultPendingBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultPurchasedBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultRestoredBridge
import com.superwall.superwallkit_flutter.bridges.RestorationResultFailedBridge
import com.superwall.superwallkit_flutter.bridges.RestorationResultRestoredBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusActiveBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusInactiveBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusUnknownBridge
import com.superwall.superwallkit_flutter.bridges.SuperwallBridge
import com.superwall.superwallkit_flutter.bridges.SuperwallDelegateProxyBridge
import com.superwall.superwallkit_flutter.bridges.bridgeClass
import com.superwall.superwallkit_flutter.bridges.generateBridgeId
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class BridgingCreator(val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : MethodCallHandler {
    private val instances: MutableMap<String, BridgeInstance> = mutableMapOf()

    companion object {
        lateinit var shared: BridgingCreator

        // Define a map of bridge names to their respective classes
        private val bridgeMap: Map<BridgeClass, Class<out BridgeInstance>> = mapOf(
            "SuperwallBridge" to SuperwallBridge::class.java,
            "SuperwallDelegateProxyBridge" to SuperwallDelegateProxyBridge::class.java,
            "PurchaseControllerProxyBridge" to PurchaseControllerProxyBridge::class.java,
            "CompletionBlockProxyBridge" to CompletionBlockProxyBridge::class.java,
            "SubscriptionStatusActiveBridge" to SubscriptionStatusActiveBridge::class.java,
            "SubscriptionStatusInactiveBridge" to SubscriptionStatusInactiveBridge::class.java,
            "SubscriptionStatusUnknownBridge" to SubscriptionStatusUnknownBridge::class.java,
            "PaywallPresentationHandlerProxyBridge" to PaywallPresentationHandlerProxyBridge::class.java,
            "PaywallSkippedReasonHoldoutBridge" to PaywallSkippedReasonHoldoutBridge::class.java,
            "PaywallSkippedReasonNoRuleMatchBridge" to PaywallSkippedReasonNoRuleMatchBridge::class.java,
            "PaywallSkippedReasonEventNotFoundBridge" to PaywallSkippedReasonEventNotFoundBridge::class.java,
            "PaywallSkippedReasonUserIsSubscribedBridge" to PaywallSkippedReasonUserIsSubscribedBridge::class.java,
            ExperimentBridge.bridgeClass() to ExperimentBridge::class.java,
            PaywallInfoBridge.bridgeClass() to PaywallInfoBridge::class.java,
            PurchaseResultCancelledBridge.bridgeClass() to PurchaseResultCancelledBridge::class.java,
            PurchaseResultPurchasedBridge.bridgeClass() to PurchaseResultPurchasedBridge::class.java,
            PurchaseResultRestoredBridge.bridgeClass() to PurchaseResultRestoredBridge::class.java,
            PurchaseResultPendingBridge.bridgeClass() to PurchaseResultPendingBridge::class.java,
            PurchaseResultFailedBridge.bridgeClass() to PurchaseResultFailedBridge::class.java,
            RestorationResultRestoredBridge.bridgeClass() to RestorationResultRestoredBridge::class.java,
            RestorationResultFailedBridge.bridgeClass() to RestorationResultFailedBridge::class.java,

        )

        fun register(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
            val communicator = Communicator(flutterPluginBinding.binaryMessenger, "SWK_BridgingCreator")
            val bridge = BridgingCreator(flutterPluginBinding)
            shared = bridge
            communicator.setMethodCallHandler(bridge)
        }
    }

    // Generic function to retrieve a bridge instance
    fun <T> bridgeInstance(bridgeId: BridgeId): T? {
        var instance = instances[bridgeId] as? T

        if (instance == null) {
            // No instance was found. When calling `invokeBridgeMethod` from Dart, make sure to provide any potentially uninitialized instances
            throw AssertionError("Unable to find a native instance for $bridgeId.")
        }

        return instance
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "createBridgeInstance" -> {
                val bridgeId = call.argument<String>("bridgeId")

                if (bridgeId != null) {
                    createBridgeInstanceFromBridgeId(bridgeId)
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
    private fun createBridgeInstanceFromBridgeId(bridgeId: BridgeId, initializationArgs: Map<String, Any>? = null): BridgeInstance {
        // An existing bridge instance might exist if it were created natively, instead of from Dart
        val existingBridgeInstance = instances[bridgeId]
        existingBridgeInstance?.let {
            return it
        }

        val bridgeClass = bridgeMap[bridgeId.bridgeClass()]
        bridgeClass?.let { bridgeClass ->
            try {
                // Use Java reflection to find the constructor
                val constructor = bridgeClass.getConstructor(Context::class.java, bridgeId::class.java, Map::class.java)

                // Create an instance of the bridge
                val bridgeInstance = constructor.newInstance(flutterPluginBinding.applicationContext, bridgeId, initializationArgs) as BridgeInstance

                instances[bridgeId] = bridgeInstance
                bridgeInstance.communicator.setMethodCallHandler(bridgeInstance)
                return bridgeInstance

            } catch (e: NoSuchMethodException) {
                throw AssertionError("No suitable constructor found for $bridgeClass", e)
            } catch (e: Exception) {
                throw AssertionError("Error creating a bridge instance of $bridgeClass", e)
            }
        } ?: run {
            throw AssertionError("Unable to find a bridge class for ${bridgeId.bridgeClass()}. Make sure to add to BridgingCreator.")
        }
    }

    // Create the bridge instance as instructed from native
    fun createBridgeInstanceFromBridgeClass(bridgeClass: BridgeClass, initializationArgs: Map<String, Any>? = null): BridgeInstance {
        return createBridgeInstanceFromBridgeId(bridgeClass.generateBridgeId(), initializationArgs)
    }
}