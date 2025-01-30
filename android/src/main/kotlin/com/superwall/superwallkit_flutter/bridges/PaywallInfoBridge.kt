package com.superwall.superwallkit_flutter.bridges

import android.content.Context
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.superwallkit_flutter.BridgingCreator
import com.superwall.superwallkit_flutter.json.toJson
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import toJson

class PaywallInfoBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs) {
    companion object {
        fun bridgeClass(): BridgeClass = "PaywallInfoBridge"
    }

    lateinit var paywallInfo: PaywallInfo
    val scope = CoroutineScope(Dispatchers.IO)

    init {
        val paywallInfoArg = initializationArgs?.get("paywallInfo") as? PaywallInfo
        paywallInfo = paywallInfoArg
            ?: throw IllegalArgumentException("Attempting to create `PaywallInfoBridge` without providing `paywallInfo`.")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        scope.launch {

            when (call.method) {
                "getName" -> result.success(paywallInfo.name)
                "getIdentifier" -> result.success(paywallInfo.identifier)
                "getExperimentBridgeId" -> result.success(paywallInfo.experiment?.createBridgeId())
                "getProducts" -> result.success(paywallInfo.products.map { it.toJson() })
                "getProductIds" -> result.success(paywallInfo.productIds)
                "getUrl" -> result.success(paywallInfo.url.toString())
                "getPresentedByEventWithName" -> result.success(paywallInfo.presentedByEventWithName)
                "getPresentedByEventWithId" -> result.success(paywallInfo.presentedByEventWithId)
                "getPresentedByEventAt" -> result.success(paywallInfo.presentedByEventAt)
                "getPresentedBy" -> result.success(paywallInfo.presentedBy)
                "getPresentationSourceType" -> result.success(paywallInfo.presentationSourceType)
                "getResponseLoadStartTime" -> result.success(paywallInfo.responseLoadStartTime)
                "getResponseLoadCompleteTime" -> result.success(paywallInfo.responseLoadCompleteTime)
                "getResponseLoadFailTime" -> result.success(paywallInfo.responseLoadFailTime)
                "getResponseLoadDuration" -> result.success(paywallInfo.responseLoadDuration)
                "getWebViewLoadStartTime" -> result.success(paywallInfo.webViewLoadStartTime)
                "getWebViewLoadCompleteTime" -> result.success(paywallInfo.webViewLoadCompleteTime)
                "getWebViewLoadFailTime" -> result.success(paywallInfo.webViewLoadFailTime)
                "getWebViewLoadDuration" -> result.success(paywallInfo.webViewLoadDuration)
                "getProductsLoadStartTime" -> result.success(paywallInfo.productsLoadStartTime)
                "getProductsLoadCompleteTime" -> result.success(paywallInfo.productsLoadCompleteTime)
                "getProductsLoadFailTime" -> result.success(paywallInfo.productsLoadFailTime)
                "getProductsLoadDuration" -> result.success(paywallInfo.productsLoadDuration)
                "getPaywalljsVersion" -> result.success(paywallInfo.paywalljsVersion)
                "getIsFreeTrialAvailable" -> result.success(paywallInfo.isFreeTrialAvailable)
                "getFeatureGatingBehavior" -> result.success(paywallInfo.featureGatingBehavior.toJson())
                "getCloseReason" -> result.success(paywallInfo.closeReason.toJson())
                "getLocalNotifications" -> result.success(paywallInfo.localNotifications.map { it.toJson() })
                "getComputedPropertyRequests" -> result.success(paywallInfo.computedPropertyRequests.map { it.toJson() })
                "getSurveys" -> result.success(paywallInfo.surveys.map { it.toJson() })
                else -> result.notImplemented()
            }
        }

    }
}

suspend fun PaywallInfo.createBridgeId(): BridgeId {
    val bridgeInstance = (BridgingCreator.shared.createBridgeInstanceFromBridgeClass(
        bridgeClass = PaywallInfoBridge.bridgeClass(),
        initializationArgs = mapOf("paywallInfo" to this)
    ) as PaywallInfoBridge).apply {
        paywallInfo = this@createBridgeId
    }
    return bridgeInstance.bridgeId
}