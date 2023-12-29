package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.delegate.SubscriptionStatus
import com.superwall.superwallkit_flutter.badArgs
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

open class SubscriptionStatusBridge(channel: MethodChannel, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : BaseBridge(channel, flutterPluginBinding) {
    open val status: SubscriptionStatus
        get() = throw AssertionError("Subclasses must implement")

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDescription" -> {
                val description = status.toString()
                result.success(description)
            }
            else -> result.notImplemented()
        }
    }
}

// Define the subclasses for each subscription status
class SubscriptionStatusActiveBridge(channel: MethodChannel, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : SubscriptionStatusBridge(channel, flutterPluginBinding) {
    override val status: SubscriptionStatus
        get() = SubscriptionStatus.ACTIVE
}

class SubscriptionStatusInactiveBridge(channel: MethodChannel, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : SubscriptionStatusBridge(channel, flutterPluginBinding) {
    override val status: SubscriptionStatus
        get() = SubscriptionStatus.INACTIVE
}

class SubscriptionStatusUnknownBridge(channel: MethodChannel, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : SubscriptionStatusBridge(channel, flutterPluginBinding) {
    override val status: SubscriptionStatus
        get() = SubscriptionStatus.UNKNOWN
}

fun SubscriptionStatus.toJson(): String {
    return when (this) {
        SubscriptionStatus.ACTIVE -> "active"
        SubscriptionStatus.INACTIVE -> "inactive"
        SubscriptionStatus.UNKNOWN -> "unknown"
    }
}