package com.superwall.superwallkit_flutter.bridges

import LogLevel
import com.superwall.superwallkit_flutter.badArgs
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class LogLevelBridge(channel: MethodChannel, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : BaseBridge(channel, flutterPluginBinding) {
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
