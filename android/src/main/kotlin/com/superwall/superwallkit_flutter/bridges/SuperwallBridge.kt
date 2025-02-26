package com.superwall.superwallkit_flutter.bridges

import android.app.Activity
import android.app.Application
import android.content.Context
import android.net.Uri
import android.util.Log
import com.superwall.sdk.Superwall
import com.superwall.sdk.analytics.superwall.SuperwallPlacementInfo
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.delegate.SuperwallDelegate
import com.superwall.sdk.identity.identify
import com.superwall.sdk.identity.setUserAttributes
import com.superwall.sdk.misc.ActivityProvider
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.paywall.presentation.PaywallPresentationHandler
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.sdk.paywall.presentation.register
import com.superwall.superwallkit_flutter.BreadCrumbs
import com.superwall.superwallkit_flutter.SuperwallkitFlutterPlugin
import com.superwall.superwallkit_flutter.argumentForKey
import com.superwall.superwallkit_flutter.badArgs
import com.superwall.superwallkit_flutter.bridgeInstance
import com.superwall.superwallkit_flutter.json.*
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.superwall.superwallkit_flutter.BridgingCreator
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.Job
import logLevelFromJson
import superwallOptionsFromJson
import toJson

class SuperwallBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null,
    val scope: CoroutineScope = CoroutineScope(Dispatchers.IO)
) : BridgeInstance(context, bridgeId, initializationArgs), ActivityProvider {
    companion object {
        fun bridgeClass(): BridgeClass = "SuperwallBridge"
    }

    init {
        val main = CoroutineScope(Dispatchers.Main)
        main.launch {
            events().setStreamHandler(
                BridgeHandler(scope) { eventSink ->
                    // Use the main dispatcher so that events are sent on the UI thread.
                    scope.launch {
                        try {
                            Superwall.instance.subscriptionStatus.collect { status ->
                                main.launch {
                                    eventSink.success(status.toJson())
                                }
                            }
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                }
            )
        }
    }

    internal class BridgeHandler(
        val scope: CoroutineScope,
        val sink: (EventChannel.EventSink) -> Unit
    ) : EventChannel.StreamHandler {
        private var listening: Job? = null
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            listening?.cancel()
            listening = scope.launch {
                sink(events!!)
            }
        }

        override fun onCancel(arguments: Any?) {
            listening?.cancel()
        }
    }

    override fun getCurrentActivity(): Activity? {
        return SuperwallkitFlutterPlugin.currentActivity
    }
}