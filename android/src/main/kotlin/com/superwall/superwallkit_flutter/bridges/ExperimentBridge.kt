package com.superwall.superwallkit_flutter.bridges
import android.content.Context
import com.superwall.sdk.models.triggers.Experiment
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.BridgingCreator
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.math.exp

class ExperimentBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {
    companion object { fun bridgeClass(): BridgeClass = "ExperimentBridge" }
    lateinit var experiment: Experiment

    init {
        val experiment = initializationArgs?.get("experiment") as? Experiment
        this.experiment = experiment ?: throw IllegalArgumentException("Attempting to create `ExperimentBridge` without providing `experiment`.")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getId" -> {
                val id = experiment.id
                result.success(id)
            }
            "getDescription" -> {
                val description = experiment.toString()
                result.success(description)
            }
            else -> result.notImplemented()
        }
    }
}

suspend fun Experiment.createBridgeId(): BridgeId {
    val bridgeInstance = (BridgingCreator.shared().createBridgeInstanceFromBridgeClass(
        bridgeClass = ExperimentBridge.bridgeClass(),
        initializationArgs = mapOf("experiment" to this)
    ) as ExperimentBridge).apply {
        experiment = this@createBridgeId
    }
    return bridgeInstance.bridgeId
}