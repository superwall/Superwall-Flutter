package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.delegate.SubscriptionStatus
import com.superwall.superwallkit_flutter.badArgs
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class SubscriptionStatusBridge(channel: MethodChannel) : BaseBridge(channel) {
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getDescription" -> {
                val statusRawValue = call.argument<Int?>("status")
                if (statusRawValue != null) {
                    val status = SubscriptionStatus.fromRawValue(statusRawValue)
                    val description = status.toString()
                    result.success(description)
                } else {
                    result.badArgs(call)
                }
            }
            else -> result.notImplemented()
        }
    }
}

// Extension to convert an integer to a SubscriptionStatus
fun SubscriptionStatus.Companion.fromRawValue(value: Int) = when(value) {
    0 -> SubscriptionStatus.ACTIVE
    1 -> SubscriptionStatus.INACTIVE
    2 -> SubscriptionStatus.UNKNOWN
    else -> throw IllegalArgumentException("Invalid integer for SubscriptionStatus")
}

// Extension to get the integer value of a SubscriptionStatus instance
val SubscriptionStatus.rawValue: Int
    get() = when(this) {
        SubscriptionStatus.ACTIVE -> 0
        SubscriptionStatus.INACTIVE -> 1
        SubscriptionStatus.UNKNOWN -> 2
    }