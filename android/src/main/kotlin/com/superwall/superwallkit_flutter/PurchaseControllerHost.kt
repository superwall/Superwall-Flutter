package com.superwall.superwallkit_flutter

import PPurchaseCancelled
import PPurchaseControllerGenerated
import PPurchaseFailed
import PPurchasePending
import PPurchasePurchased
import PPurchaseResult
import PRestorationFailed
import PRestorationRestored
import PRestorationResult
import android.app.Activity
import com.android.billingclient.api.ProductDetails
import com.superwall.sdk.delegate.PurchaseResult
import com.superwall.sdk.delegate.RestorationResult
import com.superwall.sdk.delegate.subscription_controller.PurchaseController
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
    ): PurchaseResult {
        val result =
            suspendCoroutine<PPurchaseResult> { coroutine ->
                host.purchaseFromGooglePlay(productDetails.productId, basePlanId, offerId, {
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
