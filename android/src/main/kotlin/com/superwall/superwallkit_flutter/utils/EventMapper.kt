package com.superwall.superwallkit_flutter.utils

import PSuperwallEventInfo
import android.net.Uri
import com.superwall.sdk.analytics.superwall.SuperwallEvent
import com.superwall.sdk.analytics.superwall.SuperwallEventInfo
import com.superwall.sdk.paywall.presentation.PaywallInfo
import com.superwall.sdk.store.abstractions.product.StoreProduct
import com.superwall.sdk.store.transactions.RestoreType
import com.superwall.sdk.store.transactions.TransactionError
import com.superwall.sdk.paywall.view.webview.WebviewError
import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatus
import com.superwall.sdk.paywall.presentation.internal.PaywallPresentationRequestStatusReason
import com.superwall.sdk.config.models.Survey
import com.superwall.sdk.config.models.SurveyOption

/**
 * Utility class for mapping between PSuperwallEventInfoPigeon and SDK's SuperwallEventInfo
 */
class EventMapper {
    companion object {
        /**
         * Converts SDK's SuperwallEventInfo to PSuperwallEventInfoPigeon
         */
        fun toPigeonEventInfo(eventInfo: SuperwallEventInfo): PSuperwallEventInfo {
            val eventType = when (eventInfo.event) {
                is SuperwallEvent.FirstSeen -> PEventType.FIRST_SEEN
                is SuperwallEvent.AppOpen -> PEventType.APP_OPEN
                is SuperwallEvent.AppLaunch -> PEventType.APP_LAUNCH
                is SuperwallEvent.IdentityAlias -> PEventType.IDENTITY_ALIAS
                is SuperwallEvent.AppInstall -> PEventType.APP_INSTALL
                is SuperwallEvent.SessionStart -> PEventType.SESSION_START
                is SuperwallEvent.ConfigAttributes -> PEventType.CONFIG_ATTRIBUTES
                is SuperwallEvent.DeviceAttributes -> PEventType.DEVICE_ATTRIBUTES
                is SuperwallEvent.SubscriptionStatusDidChange -> PEventType.SUBSCRIPTION_STATUS_DID_CHANGE
                is SuperwallEvent.AppClose -> PEventType.APP_CLOSE
                is SuperwallEvent.DeepLink -> PEventType.DEEP_LINK
                is SuperwallEvent.TriggerFire -> PEventType.TRIGGER_FIRE
                is SuperwallEvent.PaywallOpen -> PEventType.PAYWALL_OPEN
                is SuperwallEvent.PaywallClose -> PEventType.PAYWALL_CLOSE
                is SuperwallEvent.PaywallDecline -> PEventType.PAYWALL_DECLINE
                is SuperwallEvent.TransactionStart -> PEventType.TRANSACTION_START
                is SuperwallEvent.TransactionFail -> PEventType.TRANSACTION_FAIL
                is SuperwallEvent.TransactionAbandon -> PEventType.TRANSACTION_ABANDON
                is SuperwallEvent.TransactionComplete -> PEventType.TRANSACTION_COMPLETE
                is SuperwallEvent.SubscriptionStart -> PEventType.SUBSCRIPTION_START
                is SuperwallEvent.FreeTrialStart -> PEventType.FREE_TRIAL_START
                is SuperwallEvent.TransactionRestore -> PEventType.TRANSACTION_RESTORE
                is SuperwallEvent.Restore.Start -> PEventType.RESTORE_START
                is SuperwallEvent.Restore.Fail -> PEventType.RESTORE_FAIL
                is SuperwallEvent.Restore.Complete -> PEventType.RESTORE_COMPLETE
                is SuperwallEvent.TransactionTimeout -> PEventType.TRANSACTION_TIMEOUT
                is SuperwallEvent.UserAttributes -> PEventType.USER_ATTRIBUTES
                is SuperwallEvent.NonRecurringProductPurchase -> PEventType.NON_RECURRING_PRODUCT_PURCHASE
                is SuperwallEvent.PaywallResponseLoadStart -> PEventType.PAYWALL_RESPONSE_LOAD_START
                is SuperwallEvent.PaywallResponseLoadNotFound -> PEventType.PAYWALL_RESPONSE_LOAD_NOT_FOUND
                is SuperwallEvent.PaywallResponseLoadFail -> PEventType.PAYWALL_RESPONSE_LOAD_FAIL
                is SuperwallEvent.PaywallResponseLoadComplete -> PEventType.PAYWALL_RESPONSE_LOAD_COMPLETE
                is SuperwallEvent.PaywallWebviewLoadStart -> PEventType.PAYWALL_WEBVIEW_LOAD_START
                is SuperwallEvent.PaywallWebviewLoadFail -> PEventType.PAYWALL_WEBVIEW_LOAD_FAIL
                is SuperwallEvent.PaywallWebviewLoadComplete -> PEventType.PAYWALL_WEBVIEW_LOAD_COMPLETE
                is SuperwallEvent.PaywallWebviewLoadTimeout -> PEventType.PAYWALL_WEBVIEW_LOAD_TIMEOUT
                is SuperwallEvent.PaywallWebviewLoadFallback -> PEventType.PAYWALL_WEBVIEW_LOAD_FALLBACK
                is SuperwallEvent.PaywallProductsLoadStart -> PEventType.PAYWALL_PRODUCTS_LOAD_START
                is SuperwallEvent.PaywallProductsLoadFail -> PEventType.PAYWALL_PRODUCTS_LOAD_FAIL
                is SuperwallEvent.PaywallProductsLoadComplete -> PEventType.PAYWALL_PRODUCTS_LOAD_COMPLETE
                is SuperwallEvent.PaywallResourceLoadFail -> PEventType.PAYWALL_RESOURCE_LOAD_FAIL
                is SuperwallEvent.PaywallPresentationRequest -> PEventType.PAYWALL_PRESENTATION_REQUEST
                is SuperwallEvent.SurveyResponse -> PEventType.SURVEY_RESPONSE
                is SuperwallEvent.SurveyClose -> PEventType.SURVEY_CLOSE
                is SuperwallEvent.ConfigRefresh -> PEventType.CONFIG_REFRESH
                is SuperwallEvent.ConfigFail -> PEventType.CONFIG_FAIL
                is SuperwallEvent.ConfirmAllAssignments -> PEventType.CONFIRM_ALL_ASSIGNMENTS
                is SuperwallEvent.Reset -> PEventType.RESET
                is SuperwallEvent.CustomPlacement -> PEventType.CUSTOM_PLACEMENT
                is SuperwallEvent.ShimmerViewStart -> PEventType.SHIMMER_VIEW_START
                is SuperwallEvent.ShimmerViewComplete -> PEventType.SHIMMER_VIEW_COMPLETE
                else -> throw IllegalArgumentException("Unsupported event type: ${eventInfo.event}")
            }

            val params = when (eventInfo.event) {
                is SuperwallEvent.DeepLink -> mapOf("uri" to (eventInfo.event as SuperwallEvent.DeepLink).uri.toString())
                is SuperwallEvent.TriggerFire -> mapOf(
                    "placementName" to (eventInfo.event as SuperwallEvent.TriggerFire).placementName,
                    "result" to (eventInfo.event as SuperwallEvent.TriggerFire).result
                )
                is SuperwallEvent.TransactionStart -> mapOf("product" to (eventInfo.event as SuperwallEvent.TransactionStart).product)
                is SuperwallEvent.TransactionFail -> mapOf("error" to (eventInfo.event as SuperwallEvent.TransactionFail).error)
                is SuperwallEvent.TransactionAbandon -> mapOf("product" to (eventInfo.event as SuperwallEvent.TransactionAbandon).product)
                is SuperwallEvent.TransactionComplete -> mapOf(
                    "transaction" to (eventInfo.event as SuperwallEvent.TransactionComplete).transaction,
                    "product" to (eventInfo.event as SuperwallEvent.TransactionComplete).product
                )
                is SuperwallEvent.SubscriptionStart -> mapOf("product" to (eventInfo.event as SuperwallEvent.SubscriptionStart).product)
                is SuperwallEvent.FreeTrialStart -> mapOf("product" to (eventInfo.event as SuperwallEvent.FreeTrialStart).product)
                is SuperwallEvent.TransactionRestore -> mapOf("restoreType" to (eventInfo.event as SuperwallEvent.TransactionRestore).restoreType)
                is SuperwallEvent.Restore.Fail -> mapOf("reason" to (eventInfo.event as SuperwallEvent.Restore.Fail).reason)
                is SuperwallEvent.TransactionTimeout -> emptyMap()
                is SuperwallEvent.UserAttributes -> mapOf("attributes" to (eventInfo.event as SuperwallEvent.UserAttributes).attributes)
                is SuperwallEvent.NonRecurringProductPurchase -> mapOf("product" to (eventInfo.event as SuperwallEvent.NonRecurringProductPurchase).product)
                is SuperwallEvent.PaywallResponseLoadStart -> mapOf("triggeredPlacementName" to (eventInfo.event as SuperwallEvent.PaywallResponseLoadStart).triggeredPlacementName)
                is SuperwallEvent.PaywallResponseLoadNotFound -> mapOf("triggeredPlacementName" to (eventInfo.event as SuperwallEvent.PaywallResponseLoadNotFound).triggeredPlacementName)
                is SuperwallEvent.PaywallResponseLoadFail -> mapOf("triggeredPlacementName" to (eventInfo.event as SuperwallEvent.PaywallResponseLoadFail).triggeredPlacementName)
                is SuperwallEvent.PaywallResponseLoadComplete -> mapOf("triggeredPlacementName" to (eventInfo.event as SuperwallEvent.PaywallResponseLoadComplete).triggeredPlacementName)
                is SuperwallEvent.PaywallWebviewLoadFail -> mapOf("errorMessage" to (eventInfo.event as SuperwallEvent.PaywallWebviewLoadFail).errorMessage)
                is SuperwallEvent.PaywallProductsLoadStart -> mapOf("triggeredPlacementName" to (eventInfo.event as SuperwallEvent.PaywallProductsLoadStart).triggeredPlacementName)
                is SuperwallEvent.PaywallProductsLoadFail -> mapOf(
                    "errorMessage" to (eventInfo.event as SuperwallEvent.PaywallProductsLoadFail).errorMessage,
                    "triggeredPlacementName" to (eventInfo.event as SuperwallEvent.PaywallProductsLoadFail).triggeredPlacementName
                )
                is SuperwallEvent.PaywallProductsLoadComplete -> mapOf("triggeredPlacementName" to (eventInfo.event as SuperwallEvent.PaywallProductsLoadComplete).triggeredPlacementName)
                is SuperwallEvent.PaywallResourceLoadFail -> mapOf(
                    "url" to (eventInfo.event as SuperwallEvent.PaywallResourceLoadFail).url,
                    "error" to (eventInfo.event as SuperwallEvent.PaywallResourceLoadFail).error
                )
                is SuperwallEvent.PaywallPresentationRequest -> mapOf(
                    "status" to (eventInfo.event as SuperwallEvent.PaywallPresentationRequest).status,
                    "reason" to (eventInfo.event as SuperwallEvent.PaywallPresentationRequest).reason
                )
                is SuperwallEvent.SurveyResponse -> mapOf(
                    "survey" to (eventInfo.event as SuperwallEvent.SurveyResponse).survey,
                    "selectedOption" to (eventInfo.event as SuperwallEvent.SurveyResponse).selectedOption,
                    "customResponse" to (eventInfo.event as SuperwallEvent.SurveyResponse).customResponse
                )
                is SuperwallEvent.CustomPlacement -> mapOf(
                    "placementName" to (eventInfo.event as SuperwallEvent.CustomPlacement).placementName,
                    "params" to (eventInfo.event as SuperwallEvent.CustomPlacement).params
                )
                is SuperwallEvent.ShimmerViewComplete -> mapOf("duration" to (eventInfo.event as SuperwallEvent.ShimmerViewComplete).duration)
                else -> emptyMap()
            }

            val paywallInfo= when (eventInfo.event) {
                is SuperwallEvent.PaywallOpen -> (eventInfo.event as SuperwallEvent.PaywallOpen).paywallInfo
                is SuperwallEvent.PaywallClose -> (eventInfo.event as SuperwallEvent.PaywallClose).paywallInfo
                is SuperwallEvent.PaywallDecline -> (eventInfo.event as SuperwallEvent.PaywallDecline).paywallInfo
                is SuperwallEvent.TransactionStart -> (eventInfo.event as SuperwallEvent.TransactionStart).paywallInfo
                is SuperwallEvent.TransactionFail -> (eventInfo.event as SuperwallEvent.TransactionFail).paywallInfo
                is SuperwallEvent.TransactionAbandon -> (eventInfo.event as SuperwallEvent.TransactionAbandon).paywallInfo
                is SuperwallEvent.TransactionComplete -> (eventInfo.event as SuperwallEvent.TransactionComplete).paywallInfo
                is SuperwallEvent.SubscriptionStart -> (eventInfo.event as SuperwallEvent.SubscriptionStart).paywallInfo
                is SuperwallEvent.FreeTrialStart -> (eventInfo.event as SuperwallEvent.FreeTrialStart).paywallInfo
                is SuperwallEvent.TransactionRestore -> (eventInfo.event as SuperwallEvent.TransactionRestore).paywallInfo
                is SuperwallEvent.TransactionTimeout -> (eventInfo.event as SuperwallEvent.TransactionTimeout).paywallInfo
                is SuperwallEvent.NonRecurringProductPurchase -> (eventInfo.event as SuperwallEvent.NonRecurringProductPurchase).paywallInfo
                is SuperwallEvent.PaywallResponseLoadComplete -> (eventInfo.event as SuperwallEvent.PaywallResponseLoadComplete).paywallInfo
                is SuperwallEvent.PaywallWebviewLoadStart -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadStart).paywallInfo
                is SuperwallEvent.PaywallWebviewLoadFail -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadFail).paywallInfo
                is SuperwallEvent.PaywallWebviewLoadComplete -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadComplete).paywallInfo
                is SuperwallEvent.PaywallWebviewLoadTimeout -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadTimeout).paywallInfo
                is SuperwallEvent.PaywallWebviewLoadFallback -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadFallback).paywallInfo
                is SuperwallEvent.PaywallProductsLoadStart -> (eventInfo.event as SuperwallEvent.PaywallProductsLoadStart).paywallInfo
                is SuperwallEvent.PaywallProductsLoadFail -> (eventInfo.event as SuperwallEvent.PaywallProductsLoadFail).paywallInfo
                is SuperwallEvent.PaywallProductsLoadComplete -> (eventInfo.event as SuperwallEvent.PaywallProductsLoadComplete).paywallInfo
                is SuperwallEvent.SurveyResponse -> (eventInfo.event as SuperwallEvent.SurveyResponse).paywallInfo
                is SuperwallEvent.CustomPlacement -> (eventInfo.event as SuperwallEvent.CustomPlacement).paywallInfo
                else -> null
            }

            return PSuperwallEventInfo(
                eventType = eventType,
                params = params?.filterValues { it!=null } as Map<String,Any>?,
                paywallInfo = paywallInfo?.let { PaywallInfoMapper.toPPaywallInfo(it) }
            )
        }
    }
} 