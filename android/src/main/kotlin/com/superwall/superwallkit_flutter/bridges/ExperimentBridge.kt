package com.superwall.superwallkit_flutter.bridges
import android.content.Context
import com.superwall.sdk.models.triggers.Experiment
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ExperimentBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {

    companion object {
        fun bridgeClass(): BridgeClass {
            return "ExperimentBridge"
        }
    }

    val experiment: Experiment

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