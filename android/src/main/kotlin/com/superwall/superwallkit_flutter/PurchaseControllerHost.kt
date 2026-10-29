package com.superwall.superwallkit_flutter

import PPurchaseCancelled
import PPurchaseControllerGenerated
import PPurchaseFailed
import PPurchasePending
import PPurchasePurchased
import PProductReplacement
import PProductReplacementMode
import PPurchaseResult
import PRestorationFailed
import PRestorationRestored
import PRestorationResult
import android.app.Activity
import com.android.billingclient.api.ProductDetails
import com.superwall.sdk.delegate.PurchaseResult
import com.superwall.sdk.delegate.RestorationResult
import com.superwall.sdk.delegate.subscription_controller.PurchaseController
import com.superwall.sdk.store.ProductReplacement
import com.superwall.sdk.store.abstractions.product.StoreProduct
import kotlin.coroutines.suspendCoroutine

class PurchaseControllerHost(
    val setup: () -> PPurchaseControllerGenerated,
) : PurchaseController {
    var host = setup()

    override suspend fun purchase(
        activity: Activity,
        productDetails: ProductDetails,
        basePlanId: String?,
        offerId: String?,
    ): PurchaseResult = purchaseFromDart(productDetails.productId, basePlanId, offerId, null)

    // The SDK calls this for every purchase. Purchases that don't replace a subscription go
    // through the default implementation, which handles custom products as before.
    override suspend fun purchase(
        activity: Activity,
        product: StoreProduct,
        basePlanId: String?,
        offerId: String?,
        replacement: ProductReplacement?,
    ): PurchaseResult {
        if (replacement == null) {
            return purchase(activity, product, basePlanId, offerId)
        }
        val productDetails =
            product.rawStoreProduct?.underlyingProductDetails
                ?: return PurchaseResult.Failed(
                    "This PurchaseController does not handle custom products. " +
                        "Can't purchase ${product.fullIdentifier}.",
                )
        return purchaseFromDart(productDetails.productId, basePlanId, offerId, replacement.toPigeon())
    }

    private suspend fun purchaseFromDart(
        productId: String,
        basePlanId: String?,
        offerId: String?,
        replacement: PProductReplacement?,
    ): PurchaseResult {
        val result =
            suspendCoroutine<PPurchaseResult> { coroutine ->
                host.purchaseFromGooglePlay(productId, basePlanId, offerId, replacement, {
                    coroutine.resumeWith(it)
                })
            }
        val res =
            when (result) {
                is PPurchasePurchased -> PurchaseResult.Purchased()
                is PPurchaseFailed ->
                    PurchaseResult.Failed(
                        result.error ?: "Unknown purchase error occured",
                    )

                is PPurchasePending -> PurchaseResult.Pending()
                is PPurchaseCancelled -> PurchaseResult.Cancelled()
                else -> {
                    PurchaseResult.Failed("Never occurs - Received $result")
                }
            }
        return res
    }

    override suspend fun restorePurchases(): RestorationResult {
        val result =
            suspendCoroutine<PRestorationResult> { coroutine ->
                host.restorePurchases {
                    coroutine.resumeWith(it)
                }
            }
        return when (result) {
            is PRestorationRestored -> RestorationResult.Restored()
            is PRestorationFailed -> RestorationResult.Failed(Throwable(result.error))
            else -> RestorationResult.Failed(Throwable("Never occurs - Received $result"))
        }
    }
}

private fun ProductReplacement.toPigeon(): PProductReplacement =
    PProductReplacement(
        mode =
            when (mode) {
                ProductReplacement.Mode.DEFAULT -> PProductReplacementMode.STORE_DEFAULT
                ProductReplacement.Mode.CHARGE_PRORATED -> PProductReplacementMode.CHARGE_PRORATED
                ProductReplacement.Mode.CHARGE_FULL_PRICE -> PProductReplacementMode.CHARGE_FULL_PRICE
            },
        oldProductId = oldProductId,
        oldPurchaseToken = oldPurchaseToken,
    )
