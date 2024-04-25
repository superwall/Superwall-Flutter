package com.superwall.superwallkit_flutter.bridges

import android.app.Activity
import android.content.Context
import com.android.billingclient.api.ProductDetails
import com.superwall.sdk.delegate.subscription_controller.PurchaseController
import com.superwall.sdk.delegate.PurchaseResult
import com.superwall.sdk.delegate.RestorationResult
import com.superwall.superwallkit_flutter.asyncInvokeMethodOnMain
import com.superwall.superwallkit_flutter.bridgeInstance

class PurchaseControllerProxyBridge(
    context: Context,
    bridgeId: BridgeId,
    initializationArgs: Map<String, Any>? = null
) : BridgeInstance(context, bridgeId, initializationArgs), PurchaseController {
    companion object { fun bridgeClass(): BridgeClass = "PurchaseControllerProxyBridge" }

    // PurchaseController

    override suspend fun purchase(activity: Activity, productDetails: ProductDetails, basePlanId: String?, offerId: String?): PurchaseResult {
        val attributes = mapOf(
            "productId" to productDetails.productId,
            "basePlanId" to basePlanId,
            "offerId" to offerId
        )

        val purchaseResultBridgeId = communicator.asyncInvokeMethodOnMain("purchaseFromGooglePlay", attributes) as? BridgeId
        val purchaseResultBridge = purchaseResultBridgeId?.bridgeInstance() as? PurchaseResultBridge

        if (purchaseResultBridge == null) {
            println("WARNING: Unexpected result")
            return PurchaseResult.Failed("ERROR: Could not find a purchase result " +
                    "bridge. Make sure you enforce that it was created from Dart before " +
                    "sending back a response.");
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
