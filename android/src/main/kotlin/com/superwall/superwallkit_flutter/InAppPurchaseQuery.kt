package com.superwall.superwallkit_flutter

import POwnedInAppPurchase
import android.content.Context
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingClientStateListener
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.PendingPurchasesParams
import com.android.billingclient.api.Purchase
import com.android.billingclient.api.QueryPurchasesParams
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

class InAppPurchaseQueryException(
    val responseCode: Int,
    message: String,
) : Exception(message)

/**
 * Queries Google Play Billing for one-time (INAPP) purchases the user currently owns.
 *
 * Superwall Android does not expose owned purchases publicly, so this uses a short-lived
 * [BillingClient] that only reads purchases. It never launches a billing flow and never
 * acknowledges or consumes purchases; consumption is left to `Superwall.consume`.
 */
class InAppPurchaseQuery(private val context: () -> Context) {

    suspend fun queryPurchased(): List<POwnedInAppPurchase> =
        suspendCancellableCoroutine { cont ->
            val client = BillingClient.newBuilder(context())
                // Purchases are made through Superwall; this client only reads them.
                .setListener { _, _ -> }
                .enablePendingPurchases(
                    PendingPurchasesParams.newBuilder().enableOneTimeProducts().build()
                )
                .build()

            fun finish(purchases: List<POwnedInAppPurchase>) {
                if (cont.isActive) {
                    cont.resume(purchases)
                }
                client.endConnection()
            }

            fun fail(billingResult: BillingResult, stage: String) {
                if (cont.isActive) {
                    cont.resumeWith(
                        Result.failure(
                            InAppPurchaseQueryException(
                                billingResult.responseCode,
                                "Google Play Billing $stage failed: " +
                                    "${billingResult.responseCode} - ${billingResult.debugMessage}"
                            )
                        )
                    )
                }
                client.endConnection()
            }

            cont.invokeOnCancellation { client.endConnection() }

            client.startConnection(object : BillingClientStateListener {
                override fun onBillingSetupFinished(setupResult: BillingResult) {
                    if (setupResult.responseCode != BillingClient.BillingResponseCode.OK) {
                        fail(setupResult, "setup")
                        return
                    }
                    val params = QueryPurchasesParams.newBuilder()
                        .setProductType(BillingClient.ProductType.INAPP)
                        .build()
                    client.queryPurchasesAsync(params) { queryResult, purchases ->
                        if (queryResult.responseCode != BillingClient.BillingResponseCode.OK) {
                            fail(queryResult, "purchase query")
                        } else {
                            finish(purchases.toOwnedPurchases())
                        }
                    }
                }

                override fun onBillingServiceDisconnected() {
                    if (cont.isActive) {
                        cont.resumeWith(
                            Result.failure(
                                InAppPurchaseQueryException(
                                    BillingClient.BillingResponseCode.SERVICE_DISCONNECTED,
                                    "Google Play Billing service disconnected"
                                )
                            )
                        )
                    }
                }
            })
        }
}

private fun List<Purchase>.toOwnedPurchases(): List<POwnedInAppPurchase> =
    filter { it.purchaseState == Purchase.PurchaseState.PURCHASED }
        .map {
            POwnedInAppPurchase(
                productIds = it.products,
                purchaseToken = it.purchaseToken,
                orderId = it.orderId,
                purchaseTime = it.purchaseTime,
                quantity = it.quantity.toLong(),
                isAcknowledged = it.isAcknowledged,
            )
        }
