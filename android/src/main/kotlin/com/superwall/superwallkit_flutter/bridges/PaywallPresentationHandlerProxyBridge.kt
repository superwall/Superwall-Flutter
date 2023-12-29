package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.superwallkit_flutter.invokeMethodOnMain
import com.superwall.superwallkit_flutter.toJson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class PaywallPresentationHandlerProxyBridge(channel: MethodChannel, flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : BaseBridge(channel, flutterPluginBinding) {
    val handler: PaywallPresentationHandler by lazy {
        PaywallPresentationHandler().apply {
            onPresent {
                channel.invokeMethodOnMain("onPresent", mapOf("paywallInfo" to it.toJson()))
            }
            onDismiss {
                channel.invokeMethodOnMain("onDismiss", mapOf("paywallInfo" to it.toJson()))
            }

            onError {
                channel.invokeMethodOnMain("onError", mapOf("error" to it.toString().toJson()))
            }
            onSkip {
                channel.invokeMethodOnMain("onSkip", mapOf("paywallSkippedReason" to it.toJson()))
            }
        }
    }
}
