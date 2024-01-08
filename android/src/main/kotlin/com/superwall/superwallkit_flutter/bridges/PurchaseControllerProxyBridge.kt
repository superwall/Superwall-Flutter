package com.superwall.superwallkit_flutter.bridges

import android.app.Activity
import android.content.Context
import com.superwall.sdk.delegate.subscription_controller.PurchaseController
import io.flutter.plugin.common.MethodChannel
import com.superwall.sdk.delegate.PurchaseResult
import com.superwall.sdk.delegate.RestorationResult
import com.android.billingclient.api.SkuDetails
import com.superwall.superwallkit_flutter.asyncInvokeMethodOnMain
import com.superwall.superwallkit_flutter.bridgeInstance
import io.flutter.embedding.engine.plugins.FlutterPlugin

class PurchaseControllerProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), PurchaseController {

    // PurchaseController

    override suspend fun purchase(activity: Activity, product: SkuDetails): PurchaseResult {
        val purchaseResultBridgeId = communicator.asyncInvokeMethodOnMain("purchaseProduct", mapOf("productId" to product.sku)) as? BridgeId
        val purchaseResultBridge = purchaseResultBridgeId?.bridgeInstance() as? PurchaseResultBridge

        if (purchaseResultBridge == null) {
            println("WARNING: Unexpected result")
            return PurchaseResult.Failed(PurchaseControllerProxyPluginError());
        }

        return purchaseResultBridge.purchaseResult
    }

    override suspend fun restorePurchases(): RestorationResult {
        val restorationResultBridgeId = communicator.asyncInvokeMethodOnMain("restorePurchases") as? BridgeId
        val restorationResultBridge = restorationResultBridgeId?.bridgeInstance() as? RestorationResultBridge

        if (restorationResultBridge == null) {
            println("WARNING: Unexpected result")
            return RestorationResult.Failed(PurchaseControllerProxyPluginError())
        }

        return restorationResultBridge.restorationResult
    }

}

class PurchaseControllerProxyPluginError : Exception()
