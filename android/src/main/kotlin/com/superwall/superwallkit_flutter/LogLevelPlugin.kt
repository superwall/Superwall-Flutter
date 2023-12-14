package com.superwall.superwallkit_flutter

import LogLevel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class LogLevelPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "SWK_LogLevelBridge")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val args = call.arguments<Map<String, Any>?>()
        val levelValue = args?.get("level") as? Int
        val logLevel = levelValue?.let { findLogLevel(it) }

        if (logLevel != null) {
            when (call.method) {
                "getLogLevelDescription" -> result.success(logLevel.toString())
                "getLogLevelDescriptionEmoji" -> result.success(logLevel.getDescriptionEmoji())
                else -> result.notImplemented()
            }
        } else {
            result.error("INVALID_ARGUMENTS", "Invalid log level", null)
        }
    }

    private fun findLogLevel(value: Int): LogLevel? {
        return LogLevel.values().firstOrNull { it.level == value }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
