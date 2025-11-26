package com.superwall.superwallkit_flutter.utils

import PAppUserOwnership
import PDeviceOwnership
import PEntitlement
import PEntitlementType
import PErrorInfo
import PErrorRedemptionResult
import PExpiredCodeInfo
import PExpiredCodeRedemptionResult
import PExpiredSubscriptionCode
import PInvalidCodeRedemptionResult
import POwnership
import PPurchaserInfo
import PRedemptionInfo
import PRedemptionPaywallInfo
import PRedemptionResult
import PStoreIdentifiers
import PStripeStoreIdentifiers
import PPaddleStoreIdentifiers
import PSuccessRedemptionResult
import PUnknownStoreIdentifiers
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.internal.PurchaserInfo
import com.superwall.sdk.models.internal.RedemptionInfo
import com.superwall.sdk.models.internal.RedemptionOwnership
import com.superwall.sdk.models.internal.RedemptionResult
import com.superwall.sdk.models.internal.StoreIdentifiers
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.jsonObject

object RedemptionResultMapper {
    fun toPRedemptionResult(redemptionResult: RedemptionResult): PRedemptionResult =
        when (redemptionResult) {
            is RedemptionResult.Success -> mapSuccessResult(redemptionResult)
            is RedemptionResult.Error -> mapErrorResult(redemptionResult)
            is RedemptionResult.Expired -> mapExpiredResult(redemptionResult)
            is RedemptionResult.InvalidCode -> mapInvalidCodeResult(redemptionResult)
            is RedemptionResult.ExpiredSubscription -> mapExpiredSubscriptionResult(redemptionResult)
        }

    private fun mapSuccessResult(success: RedemptionResult.Success): PSuccessRedemptionResult =
        PSuccessRedemptionResult(
            code = success.code,
            redemptionInfo = mapRedemptionInfo(success.redemptionInfo),
        )

    private fun mapErrorResult(error: RedemptionResult.Error): PErrorRedemptionResult =
        PErrorRedemptionResult(
            code = error.code,
            error = PErrorInfo(error.error.message),
        )

    private fun mapExpiredResult(expired: RedemptionResult.Expired): PExpiredCodeRedemptionResult =
        PExpiredCodeRedemptionResult(
            code = expired.code,
            info =
                PExpiredCodeInfo(
                    resent = expired.expired.resent,
                    obfuscatedEmail = expired.expired.obfuscatedEmail,
                ),
        )

    private fun mapInvalidCodeResult(invalidCode: RedemptionResult.InvalidCode): PInvalidCodeRedemptionResult =
        PInvalidCodeRedemptionResult(invalidCode.code)

    private fun mapExpiredSubscriptionResult(expiredSubscription: RedemptionResult.ExpiredSubscription): PExpiredSubscriptionCode =
        PExpiredSubscriptionCode(
            expiredSubscription.code,
            mapRedemptionInfo(expiredSubscription.redemptionInfo),
        )

    private fun mapRedemptionInfo(redemptionInfo: RedemptionInfo): PRedemptionInfo =
        PRedemptionInfo(
            ownership = mapOwnership(redemptionInfo.ownership),
            purchaserInfo = mapPurchaserInfo(redemptionInfo.purchaserInfo),
            paywallInfo = redemptionInfo.paywallInfo?.let { mapPaywallInfo(it) },
            entitlements = redemptionInfo.entitlements.map { mapEntitlement(it) },
        )

    private fun mapOwnership(ownership: RedemptionOwnership): POwnership =
        when (ownership) {
            is RedemptionOwnership.Device -> PDeviceOwnership(ownership.deviceId)
            is RedemptionOwnership.AppUser -> PAppUserOwnership(ownership.appUserId)
        }

    private fun mapPurchaserInfo(purchaserInfo: PurchaserInfo): PPurchaserInfo =
        PPurchaserInfo(
            appUserId = purchaserInfo.appUserId,
            email = purchaserInfo.email,
            storeIdentifiers = mapStoreIdentifiers(purchaserInfo.storeIdentifiers),
        )

    private fun mapStoreIdentifiers(storeIdentifiers: StoreIdentifiers): PStoreIdentifiers =
        when (storeIdentifiers) {
            is StoreIdentifiers.Paddle ->
                PPaddleStoreIdentifiers(
                    customerId = storeIdentifiers.paddleCustomerId,
                    subscriptionIds = storeIdentifiers.paddleSubscriptionIds,
                )
            is StoreIdentifiers.Stripe ->
                PStripeStoreIdentifiers(
                    customerId = storeIdentifiers.stripeCustomerId,
                    subscriptionIds = storeIdentifiers.subscriptionIds,
                )
            is StoreIdentifiers.Unknown ->
                PUnknownStoreIdentifiers(
                    store = "UNKNOWN",
                    additionalInfo = convertJsonMapToAnyMap(storeIdentifiers.properties),
                )
        }

    private fun mapPaywallInfo(paywallInfo: RedemptionResult.PaywallInfo): PRedemptionPaywallInfo =
        PRedemptionPaywallInfo(
            identifier = paywallInfo.identifier,
            placementName = paywallInfo.placementName,
            placementParams = convertJsonMapToAnyMap(paywallInfo.placementParams),
            variantId = paywallInfo.variantId,
            experimentId = paywallInfo.experimentId,
        )

    private fun mapEntitlement(entitlement: Entitlement): PEntitlement {
        return PEntitlement(
            id = entitlement.id,
            type = PEntitlementType.SERVICE_LEVEL,
            isActive = true,
            productIds = emptyList()
        )
    }

    private fun convertJsonMapToAnyMap(jsonMap: Map<String, JsonElement?>): Map<String, Any> {
        val result = mutableMapOf<String, Any>()

        jsonMap.forEach { (key, value) ->
            value?.let {
                result[key] =
                    when (it) {
                        is JsonPrimitive -> {
                            when {
                                it.isString -> it.content
                                it.content == "true" || it.content == "false" -> it.content.toBoolean()
                                it.content.toIntOrNull() != null -> it.content.toInt()
                                it.content.toDoubleOrNull() != null -> it.content.toDouble()
                                else -> it.content
                            }
                        }
                        is JsonObject -> convertJsonMapToAnyMap(it.jsonObject)
                        else -> it.toString()
                    }
            }
        }

        return result
    }
}
