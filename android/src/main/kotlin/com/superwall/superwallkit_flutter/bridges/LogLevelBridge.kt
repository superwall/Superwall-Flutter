package com.superwall.superwallkit_flutter.bridges

import LogLevel
import android.content.Context
import com.superwall.superwallkit_flutter.badArgs
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class LogLevelBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {
    override fun onMethodCall(call: MethodCall, result: Result) {
        val levelValue = call.argument<Int>("level")
        val logLevel = levelValue?.let { findLogLevel(it) }

        if (logLevel != null) {
            when (call.method) {
                "getLogLevelDescription" -> result.success(logLevel.toString())
                "getLogLevelDescriptionEmoji" -> result.success(logLevel.getDescriptionEmoji())
                else -> result.notImplemented()
            }
        } else {
            result.badArgs(call);
        }
    }

    private fun findLogLevel(value: Int): LogLevel? {
        return LogLevel.values().firstOrNull { it.level == value }
    }
}
