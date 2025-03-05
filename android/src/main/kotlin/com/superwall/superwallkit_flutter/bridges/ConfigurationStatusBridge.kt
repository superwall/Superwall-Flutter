package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.config.models.ConfigurationStatus
import android.content.Context
import com.superwall.superwallkit_flutter.BridgingCreator

abstract class ConfigurationStatusBridge(context: Context, bridgeId: BridgeId) : BridgeInstance(context,
    bridgeId
) {
    abstract val configurationStatus: ConfigurationStatus
}

class ConfigurationStatusPendingBridge(context: Context, bridgeId: BridgeId) : ConfigurationStatusBridge(context,
    bridgeId
) {


    companion object {
        fun bridgeClass(): BridgeClass = "ConfigurationStatusPendingBridge"
    }

    override val configurationStatus: ConfigurationStatus
        get() = ConfigurationStatus.Configured
}


class ConfigurationStatusFailedBridge(context: Context, bridgeId: BridgeId) : ConfigurationStatusBridge(context,
    bridgeId
) {


    companion object {
        fun bridgeClass(): BridgeClass = "ConfigurationStatusFailedBridge"
    }

    override val configurationStatus: ConfigurationStatus
        get() = ConfigurationStatus.Failed
}

class ConfigurationStatusConfiguredBridge(context: Context, bridgeId: BridgeId) : ConfigurationStatusBridge(context,
    bridgeId
) {


    companion object {
        fun bridgeClass(): BridgeClass = "ConfigurationStatusConfiguredBridge"
    }

    override val configurationStatus: ConfigurationStatus
        get() = ConfigurationStatus.Configured
}


suspend fun ConfigurationStatus.createBridgeId(): BridgeId {

    val bridgeClass = when (this) {
        is ConfigurationStatus.Pending -> ConfigurationStatusPendingBridge.bridgeClass()
        is ConfigurationStatus.Failed -> ConfigurationStatusFailedBridge.bridgeClass()
        is ConfigurationStatus.Configured -> ConfigurationStatusConfiguredBridge.bridgeClass()
    }
    val bridge = BridgingCreator.shared().createBridgeInstanceFromBridgeClass(
        bridgeClass = bridgeClass
    )
    return bridge.bridgeId
}