package com.superwall.superwallkit_flutter.bridges

import android.app.Activity
import com.superwall.sdk.delegate.subscription_controller.PurchaseController
import io.flutter.plugin.common.MethodChannel
import com.superwall.sdk.delegate.PurchaseResult
import com.superwall.sdk.delegate.RestorationResult
import com.android.billingclient.api.SkuDetails

class PurchaseControllerProxyBridge(channel: MethodChannel) : BaseBridge(channel),
    PurchaseController {

    // PurchaseController

    override suspend fun purchase(activity: Activity, product: SkuDetails): PurchaseResult {
        val purchaseResult = channel.invokeMethod("purchaseProduct", mapOf("productId" to product.getSku())) as? Map<String, Any>
            ?: throw PurchaseControllerProxyPluginError()

        return parsePurchaseResultFromJson(purchaseResult)
    }

    override suspend fun restorePurchases(): RestorationResult {
        val restorationResult = channel.invokeMethod("restorePurchases", null) as? Map<String, Any>
            ?: throw PurchaseControllerProxyPluginError()

        return parseRestorationResultFromJson(restorationResult)
    }

    private fun parsePurchaseResultFromJson(dictionary: Map<String, Any>): PurchaseResult {
        val type = dictionary["type"] as? String ?: throw PurchaseControllerProxyJsonError()

        return when (type) {
            "cancelled" -> PurchaseResult.Cancelled()
            "purchased" -> PurchaseResult.Purchased()
            // TODO: Update Android
//            "restored" -> Restored()
            "pending" -> PurchaseResult.Pending()
            "failed" -> {
                val errorDescription = dictionary["error"] as? String
                PurchaseResult.Failed(PurchaseControllerProxyJsonError())
            }
            else -> throw PurchaseControllerProxyJsonError()
        }
    }

    private fun parseRestorationResultFromJson(dictionary: Map<String, Any>): RestorationResult {
        val type = dictionary["type"] as? String ?: throw PurchaseControllerProxyJsonError()

        return when (type) {
            "restored" -> RestorationResult.Restored()
            "failed" -> {
                val errorDescription = dictionary["error"] as? String
                RestorationResult.Failed(PurchaseControllerProxyJsonError())
            }
            else -> throw PurchaseControllerProxyJsonError()
        }
    }
}

class PurchaseControllerProxyPluginError : Exception()
class PurchaseControllerProxyJsonError : Exception()
