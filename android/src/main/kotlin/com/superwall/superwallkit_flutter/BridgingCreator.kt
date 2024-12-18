package com.superwall.superwallkit_flutter

import com.superwall.superwallkit_flutter.bridges.BridgeClass
import com.superwall.superwallkit_flutter.bridges.BridgeId
import com.superwall.superwallkit_flutter.bridges.BridgeInstance
import com.superwall.superwallkit_flutter.bridges.Communicator
import com.superwall.superwallkit_flutter.bridges.bridgeClass
import com.superwall.superwallkit_flutter.bridges.generateBridgeId
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.filterNotNull
import java.util.concurrent.ConcurrentHashMap
import io.flutter.embedding.android.FlutterActivity
import kotlinx.coroutines.flow.first

class BridgingCreator(
    val flutterPluginBinding: suspend () -> FlutterPlugin.FlutterPluginBinding,
    val scope: CoroutineScope = CoroutineScope(Dispatchers.IO)
) : MethodCallHandler {
    private val instances: MutableMap<String, BridgeInstance> = ConcurrentHashMap()

    object Constants {}

    companion object {
        private var _shared: BridgingCreator? = null
        val shared: BridgingCreator
            get() = _shared ?: throw IllegalStateException("BridgingCreator not initialized")

        private var _flutterPluginBinding: MutableStateFlow<FlutterPlugin.FlutterPluginBinding?> =
            MutableStateFlow(null)

        suspend fun waitForPlugin() : FlutterPlugin.FlutterPluginBinding {
            return _flutterPluginBinding.filterNotNull().first()
        }
        fun setFlutterPlugin(binding: FlutterPlugin.FlutterPluginBinding) {
            // Only allow binding to occur once. It appears that if binding is set multiple
            // times (due to other SDK interference), we'll lose access to the
            // SuperwallKitFlutterPlugin current activity
            if (_flutterPluginBinding.value != null) {
                println("WARNING: Attempting to set a flutter plugin binding again.")
                return
            }

            // Store for getter


            binding?.let {
                synchronized(BridgingCreator::class.java) {
                    val bridge = BridgingCreator({ waitForPlugin() })
                    _shared = bridge
                    _flutterPluginBinding.value = binding
                    val communicator = Communicator(binding.binaryMessenger, "SWK_BridgingCreator")
                    communicator.setMethodCallHandler(bridge)
                }
            }

        }
    }

    fun tearDown() {
        print("Did tearDown BridgingCreator")
        _shared = null
        _flutterPluginBinding.value = null
    }

    // Generic function to retrieve a bridge instance
    suspend fun <T> bridgeInstance(bridgeId: BridgeId): T? {
        BreadCrumbs.append("BridgingCreator.kt: Searching for $bridgeId among ${instances.count()}: ${instances.toFormattedString()}")
        var instance = instances[bridgeId] as? T

        if (instance == null) {
            // No instance was found. When calling `invokeBridgeMethod` from Dart, make sure to provide any potentially uninitialized instances
            throw AssertionError("Unable to find a native instance for $bridgeId. Logs: ${BreadCrumbs.logs()}")
        }

        return instance
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        scope.launch {

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
    }

    // Create the bridge instance as instructed from Dart
    private suspend fun createBridgeInstanceFromBridgeId(
        bridgeId: BridgeId,
        initializationArgs: Map<String, Any>?
    ): BridgeInstance {
        // An existing bridge instance might exist if it were created natively, instead of from Dart
        val existingBridgeInstance = instances[bridgeId]
        existingBridgeInstance?.let {
            return it
        }

        // Create an instance of the bridge
        val bridgeInstance = bridgeInitializers[bridgeId.bridgeClass()]?.invoke(
            flutterPluginBinding().applicationContext,
            bridgeId,
            initializationArgs
        )
        bridgeInstance?.let { bridgeInstance ->
            instances[bridgeId] = bridgeInstance
            bridgeInstance.communicator().setMethodCallHandler(bridgeInstance)
            return bridgeInstance
        } ?: run {
            throw AssertionError("Unable to find a bridge initializer for ${bridgeId}. Make sure to add to BridgingCreator+Constants.kt.}")
        }
    }

    // Create the bridge instance as instructed from native
    suspend fun createBridgeInstanceFromBridgeClass(
        bridgeClass: BridgeClass,
        initializationArgs: Map<String, Any>? = null
    ): BridgeInstance {
        return createBridgeInstanceFromBridgeId(bridgeClass.generateBridgeId(), initializationArgs)
    }
}