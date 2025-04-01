package com.superwall.superwallkit_flutter.utils

import PSuperwallEventInfoPigeon
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
         * Converts a PSuperwallEventInfoPigeon to SDK's SuperwallEventInfo
         */
        fun fromPigeonEventInfo(pigeonEvent: PSuperwallEventInfoPigeon): SuperwallEventInfo {
            val event = when (pigeonEvent.eventType) {
                PEventType.FIRST_SEEN -> SuperwallEvent.FirstSeen()
                PEventType.APP_OPEN -> SuperwallEvent.AppOpen()
                PEventType.APP_LAUNCH -> SuperwallEvent.AppLaunch()
                PEventType.IDENTITY_ALIAS -> SuperwallEvent.IdentityAlias()
                PEventType.APP_INSTALL -> SuperwallEvent.AppInstall()
                PEventType.SESSION_START -> SuperwallEvent.SessionStart()
                PEventType.CONFIG_ATTRIBUTES -> SuperwallEvent.ConfigAttributes
                PEventType.DEVICE_ATTRIBUTES -> {
                    val attributes = pigeonEvent.params?.get("attributes") as? Map<String, Any> ?: emptyMap()
                    SuperwallEvent.DeviceAttributes(attributes)
                }
                PEventType.SUBSCRIPTION_STATUS_DID_CHANGE -> SuperwallEvent.SubscriptionStatusDidChange()
                PEventType.APP_CLOSE -> SuperwallEvent.AppClose()
                PEventType.DEEP_LINK -> {
                    val uri = pigeonEvent.params?.get("uri") as? String
                    if (uri != null) {
                        SuperwallEvent.DeepLink(Uri.parse(uri))
                    } else {
                        throw IllegalArgumentException("Deep link URI is required")
                    }
                }
                PEventType.TRIGGER_FIRE -> {
                    val placementName = pigeonEvent.params?.get("placementName") as? String
                    val result = pigeonEvent.params?.get("result") as? Map<String, Any>
                    if (placementName != null && result != null) {
                        SuperwallEvent.TriggerFire(placementName, result)
                    } else {
                        throw IllegalArgumentException("Placement name and result are required for trigger fire")
                    }
                }
                PEventType.PAYWALL_OPEN -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallOpen(paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for paywall open")
                    }
                }
                PEventType.PAYWALL_CLOSE -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallClose(paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for paywall close")
                    }
                }
                PEventType.PAYWALL_DECLINE -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallDecline(paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for paywall decline")
                    }
                }
                PEventType.TRANSACTION_START -> {
                    val product = pigeonEvent.params?.get("product") as? StoreProduct
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (product != null && paywallInfo != null) {
                        SuperwallEvent.TransactionStart(product, paywallInfo)
                    } else {
                        throw IllegalArgumentException("Product and PaywallInfo are required for transaction start")
                    }
                }
                PEventType.TRANSACTION_FAIL -> {
                    val error = pigeonEvent.params?.get("error") as? TransactionError
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (error != null && paywallInfo != null) {
                        SuperwallEvent.TransactionFail(error, paywallInfo)
                    } else {
                        throw IllegalArgumentException("Error and PaywallInfo are required for transaction fail")
                    }
                }
                PEventType.TRANSACTION_ABANDON -> {
                    val product = pigeonEvent.params?.get("product") as? StoreProduct
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (product != null && paywallInfo != null) {
                        SuperwallEvent.TransactionAbandon(product, paywallInfo)
                    } else {
                        throw IllegalArgumentException("Product and PaywallInfo are required for transaction abandon")
                    }
                }
                PEventType.TRANSACTION_COMPLETE -> {
                    val transaction = pigeonEvent.params?.get("transaction") as? StoreTransactionType
                    val product = pigeonEvent.params?.get("product") as? StoreProduct
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (product != null && paywallInfo != null) {
                        SuperwallEvent.TransactionComplete(transaction, product, paywallInfo)
                    } else {
                        throw IllegalArgumentException("Product and PaywallInfo are required for transaction complete")
                    }
                }
                PEventType.SUBSCRIPTION_START -> {
                    val product = pigeonEvent.params?.get("product") as? StoreProduct
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (product != null && paywallInfo != null) {
                        SuperwallEvent.SubscriptionStart(product, paywallInfo)
                    } else {
                        throw IllegalArgumentException("Product and PaywallInfo are required for subscription start")
                    }
                }
                PEventType.FREE_TRIAL_START -> {
                    val product = pigeonEvent.params?.get("product") as? StoreProduct
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (product != null && paywallInfo != null) {
                        SuperwallEvent.FreeTrialStart(product, paywallInfo)
                    } else {
                        throw IllegalArgumentException("Product and PaywallInfo are required for free trial start")
                    }
                }
                PEventType.TRANSACTION_RESTORE -> {
                    val restoreType = pigeonEvent.params?.get("restoreType") as? RestoreType
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (restoreType != null && paywallInfo != null) {
                        SuperwallEvent.TransactionRestore(restoreType, paywallInfo)
                    } else {
                        throw IllegalArgumentException("RestoreType and PaywallInfo are required for transaction restore")
                    }
                }
                PEventType.RESTORE_START -> SuperwallEvent.Restore.Start
                PEventType.RESTORE_FAIL -> {
                    val reason = pigeonEvent.params?.get("reason") as? String
                    if (reason != null) {
                        SuperwallEvent.Restore.Fail(reason)
                    } else {
                        throw IllegalArgumentException("Reason is required for restore fail")
                    }
                }
                PEventType.RESTORE_COMPLETE -> SuperwallEvent.Restore.Complete
                PEventType.TRANSACTION_TIMEOUT -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.TransactionTimeout(paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for transaction timeout")
                    }
                }
                PEventType.USER_ATTRIBUTES -> {
                    val attributes = pigeonEvent.params?.get("attributes") as? Map<String, Any> ?: emptyMap()
                    SuperwallEvent.UserAttributes(attributes)
                }
                PEventType.NON_RECURRING_PRODUCT_PURCHASE -> {
                    val product = pigeonEvent.params?.get("product") as? TransactionProduct
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (product != null && paywallInfo != null) {
                        SuperwallEvent.NonRecurringProductPurchase(product, paywallInfo)
                    } else {
                        throw IllegalArgumentException("Product and PaywallInfo are required for non-recurring product purchase")
                    }
                }
                PEventType.PAYWALL_RESPONSE_LOAD_START -> {
                    val triggeredPlacementName = pigeonEvent.params?.get("triggeredPlacementName") as? String
                    SuperwallEvent.PaywallResponseLoadStart(triggeredPlacementName)
                }
                PEventType.PAYWALL_RESPONSE_LOAD_NOT_FOUND -> {
                    val triggeredPlacementName = pigeonEvent.params?.get("triggeredPlacementName") as? String
                    SuperwallEvent.PaywallResponseLoadNotFound(triggeredPlacementName)
                }
                PEventType.PAYWALL_RESPONSE_LOAD_FAIL -> {
                    val triggeredPlacementName = pigeonEvent.params?.get("triggeredPlacementName") as? String
                    SuperwallEvent.PaywallResponseLoadFail(triggeredPlacementName)
                }
                PEventType.PAYWALL_RESPONSE_LOAD_COMPLETE -> {
                    val triggeredPlacementName = pigeonEvent.params?.get("triggeredPlacementName") as? String
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallResponseLoadComplete(triggeredPlacementName, paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for paywall response load complete")
                    }
                }
                PEventType.PAYWALL_WEBVIEW_LOAD_START -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallWebviewLoadStart(paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for webview load start")
                    }
                }
                PEventType.PAYWALL_WEBVIEW_LOAD_FAIL -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    val errorMessage = pigeonEvent.params?.get("errorMessage") as? WebviewError
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallWebviewLoadFail(paywallInfo, errorMessage)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for webview load fail")
                    }
                }
                PEventType.PAYWALL_WEBVIEW_LOAD_COMPLETE -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallWebviewLoadComplete(paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for webview load complete")
                    }
                }
                PEventType.PAYWALL_WEBVIEW_LOAD_TIMEOUT -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallWebviewLoadTimeout(paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for webview load timeout")
                    }
                }
                PEventType.PAYWALL_WEBVIEW_LOAD_FALLBACK -> {
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallWebviewLoadFallback(paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for webview load fallback")
                    }
                }
                PEventType.PAYWALL_PRODUCTS_LOAD_START -> {
                    val triggeredPlacementName = pigeonEvent.params?.get("triggeredPlacementName") as? String
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallProductsLoadStart(triggeredPlacementName, paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for products load start")
                    }
                }
                PEventType.PAYWALL_PRODUCTS_LOAD_FAIL -> {
                    val errorMessage = pigeonEvent.params?.get("errorMessage") as? String
                    val triggeredPlacementName = pigeonEvent.params?.get("triggeredPlacementName") as? String
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallProductsLoadFail(errorMessage, triggeredPlacementName, paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for products load fail")
                    }
                }
                PEventType.PAYWALL_PRODUCTS_LOAD_COMPLETE -> {
                    val triggeredPlacementName = pigeonEvent.params?.get("triggeredPlacementName") as? String
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (paywallInfo != null) {
                        SuperwallEvent.PaywallProductsLoadComplete(triggeredPlacementName, paywallInfo)
                    } else {
                        throw IllegalArgumentException("PaywallInfo is required for products load complete")
                    }
                }
                PEventType.PAYWALL_RESOURCE_LOAD_FAIL -> {
                    val url = pigeonEvent.params?.get("url") as? String
                    val error = pigeonEvent.params?.get("error") as? String
                    if (url != null && error != null) {
                        SuperwallEvent.PaywallResourceLoadFail(url, error)
                    } else {
                        throw IllegalArgumentException("URL and error are required for resource load fail")
                    }
                }
                PEventType.PAYWALL_PRESENTATION_REQUEST -> {
                    val status = pigeonEvent.params?.get("status") as? PaywallPresentationRequestStatus
                    val reason = pigeonEvent.params?.get("reason") as? PaywallPresentationRequestStatusReason
                    if (status != null) {
                        SuperwallEvent.PaywallPresentationRequest(status, reason)
                    } else {
                        throw IllegalArgumentException("Status is required for presentation request")
                    }
                }
                PEventType.SURVEY_RESPONSE -> {
                    val survey = pigeonEvent.params?.get("survey") as? Survey
                    val selectedOption = pigeonEvent.params?.get("selectedOption") as? SurveyOption
                    val customResponse = pigeonEvent.params?.get("customResponse") as? String
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    if (survey != null && selectedOption != null && paywallInfo != null) {
                        SuperwallEvent.SurveyResponse(survey, selectedOption, customResponse, paywallInfo)
                    } else {
                        throw IllegalArgumentException("Survey, selected option, and PaywallInfo are required for survey response")
                    }
                }
                PEventType.SURVEY_CLOSE -> SuperwallEvent.SurveyClose()
                PEventType.CONFIG_REFRESH -> SuperwallEvent.ConfigRefresh
                PEventType.CONFIG_FAIL -> SuperwallEvent.ConfigFail
                PEventType.CONFIRM_ALL_ASSIGNMENTS -> SuperwallEvent.ConfirmAllAssignments
                PEventType.RESET -> SuperwallEvent.Reset
                PEventType.CUSTOM_PLACEMENT -> {
                    val placementName = pigeonEvent.params?.get("placementName") as? String
                    val paywallInfo = pigeonEvent.paywallInfoBridgeId?.let { PaywallInfoMapper.fromPPaywallInfo(it) }
                    val params = pigeonEvent.params?.get("params") as? Map<String, Any> ?: emptyMap()
                    if (placementName != null && paywallInfo != null) {
                        SuperwallEvent.CustomPlacement(placementName, paywallInfo, params)
                    } else {
                        throw IllegalArgumentException("Placement name and PaywallInfo are required for custom placement")
                    }
                }
                PEventType.SHIMMER_VIEW_START -> SuperwallEvent.ShimmerViewStart
                PEventType.SHIMMER_VIEW_COMPLETE -> {
                    val duration = pigeonEvent.params?.get("duration") as? Double
                    if (duration != null) {
                        SuperwallEvent.ShimmerViewComplete(duration)
                    } else {
                        throw IllegalArgumentException("Duration is required for shimmer view complete")
                    }
                }
                else -> throw IllegalArgumentException("Unsupported event type: ${pigeonEvent.eventType}")
            }

            return SuperwallEventInfo(event, pigeonEvent.params ?: emptyMap())
        }

        /**
         * Converts SDK's SuperwallEventInfo to PSuperwallEventInfoPigeon
         */
        fun toPigeonEventInfo(eventInfo: SuperwallEventInfo): PSuperwallEventInfoPigeon {
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

            val paywallInfoBridgeId = when (eventInfo.event) {
                is SuperwallEvent.PaywallOpen -> (eventInfo.event as SuperwallEvent.PaywallOpen).paywallInfo.identifier
                is SuperwallEvent.PaywallClose -> (eventInfo.event as SuperwallEvent.PaywallClose).paywallInfo.identifier
                is SuperwallEvent.PaywallDecline -> (eventInfo.event as SuperwallEvent.PaywallDecline).paywallInfo.identifier
                is SuperwallEvent.TransactionStart -> (eventInfo.event as SuperwallEvent.TransactionStart).paywallInfo.identifier
                is SuperwallEvent.TransactionFail -> (eventInfo.event as SuperwallEvent.TransactionFail).paywallInfo.identifier
                is SuperwallEvent.TransactionAbandon -> (eventInfo.event as SuperwallEvent.TransactionAbandon).paywallInfo.identifier
                is SuperwallEvent.TransactionComplete -> (eventInfo.event as SuperwallEvent.TransactionComplete).paywallInfo.identifier
                is SuperwallEvent.SubscriptionStart -> (eventInfo.event as SuperwallEvent.SubscriptionStart).paywallInfo.identifier
                is SuperwallEvent.FreeTrialStart -> (eventInfo.event as SuperwallEvent.FreeTrialStart).paywallInfo.identifier
                is SuperwallEvent.TransactionRestore -> (eventInfo.event as SuperwallEvent.TransactionRestore).paywallInfo.identifier
                is SuperwallEvent.TransactionTimeout -> (eventInfo.event as SuperwallEvent.TransactionTimeout).paywallInfo.identifier
                is SuperwallEvent.NonRecurringProductPurchase -> (eventInfo.event as SuperwallEvent.NonRecurringProductPurchase).paywallInfo.identifier
                is SuperwallEvent.PaywallResponseLoadComplete -> (eventInfo.event as SuperwallEvent.PaywallResponseLoadComplete).paywallInfo.identifier
                is SuperwallEvent.PaywallWebviewLoadStart -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadStart).paywallInfo.identifier
                is SuperwallEvent.PaywallWebviewLoadFail -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadFail).paywallInfo.identifier
                is SuperwallEvent.PaywallWebviewLoadComplete -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadComplete).paywallInfo.identifier
                is SuperwallEvent.PaywallWebviewLoadTimeout -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadTimeout).paywallInfo.identifier
                is SuperwallEvent.PaywallWebviewLoadFallback -> (eventInfo.event as SuperwallEvent.PaywallWebviewLoadFallback).paywallInfo.identifier
                is SuperwallEvent.PaywallProductsLoadStart -> (eventInfo.event as SuperwallEvent.PaywallProductsLoadStart).paywallInfo.identifier
                is SuperwallEvent.PaywallProductsLoadFail -> (eventInfo.event as SuperwallEvent.PaywallProductsLoadFail).paywallInfo.identifier
                is SuperwallEvent.PaywallProductsLoadComplete -> (eventInfo.event as SuperwallEvent.PaywallProductsLoadComplete).paywallInfo.identifier
                is SuperwallEvent.SurveyResponse -> (eventInfo.event as SuperwallEvent.SurveyResponse).paywallInfo.identifier
                is SuperwallEvent.CustomPlacement -> (eventInfo.event as SuperwallEvent.CustomPlacement).paywallInfo.identifier
                else -> null
            }

            return PSuperwallEventInfoPigeon(
                eventType = eventType,
                params = params?.filterValues { it!=null } as Map<String,Any>?,
                paywallInfoBridgeId = paywallInfoBridgeId
            )
        }
    }
} 