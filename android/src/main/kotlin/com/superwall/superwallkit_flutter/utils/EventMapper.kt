package com.superwall.superwallkit_flutter.utils

import PSuperwallEventInfo
import PSurveyOption
import com.superwall.sdk.analytics.superwall.SuperwallEvent
import com.superwall.sdk.analytics.superwall.SuperwallEventInfo
import com.superwall.superwallkit_flutter.json.pigeonify
import pigeonify

/**
 * Utility class for mapping between PSuperwallEventInfoPigeon and SDK's SuperwallEventInfo
 */
class EventMapper {
    companion object {
        /**
         * Converts SDK's SuperwallEventInfo to PSuperwallEventInfoPigeon
         */
        fun toPigeonEventInfo(eventInfo: SuperwallEventInfo): PSuperwallEventInfo {
            val params = mapParamsForDart(eventInfo.params)
            return when (val event = eventInfo.event) {
                is SuperwallEvent.FirstSeen -> PSuperwallEventInfo(eventType = PEventType.FIRST_SEEN, params = params)
                is SuperwallEvent.AppOpen -> PSuperwallEventInfo(eventType = PEventType.APP_OPEN, params = params)
                is SuperwallEvent.AppLaunch -> PSuperwallEventInfo(eventType = PEventType.APP_LAUNCH, params = params)
                is SuperwallEvent.IdentityAlias -> PSuperwallEventInfo(eventType = PEventType.IDENTITY_ALIAS, params = params)
                is SuperwallEvent.AppInstall -> PSuperwallEventInfo(eventType = PEventType.APP_INSTALL, params = params)
                is SuperwallEvent.SessionStart -> PSuperwallEventInfo(eventType = PEventType.SESSION_START, params = params)
                is SuperwallEvent.ConfigAttributes -> PSuperwallEventInfo(eventType = PEventType.CONFIG_ATTRIBUTES, params = params)
                is SuperwallEvent.DeviceAttributes ->
                    PSuperwallEventInfo(
                        eventType = PEventType.DEVICE_ATTRIBUTES,
                        params = params,
                        deviceAttributes = event.attributes
                    )
                is SuperwallEvent.SubscriptionStatusDidChange -> PSuperwallEventInfo(eventType = PEventType.SUBSCRIPTION_STATUS_DID_CHANGE, params = params)
                is SuperwallEvent.AppClose -> PSuperwallEventInfo(eventType = PEventType.APP_CLOSE, params = params)
                is SuperwallEvent.DeepLink ->
                    PSuperwallEventInfo(
                        eventType = PEventType.DEEP_LINK,
                        params = params,
                        deepLinkUrl = event.uri.toString()
                    )
                is SuperwallEvent.TriggerFire ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRIGGER_FIRE,
                        params = params,
                        placementName = event.placementName,
                        result = event.result.pigeonify()
                    )
                is SuperwallEvent.PaywallOpen ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_OPEN,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                    )
                is SuperwallEvent.PaywallClose ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_CLOSE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                    )
                is SuperwallEvent.PaywallDecline ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_DECLINE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                    )
                is SuperwallEvent.TransactionStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_START,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        product = event.product.pigeonify()
                    )
                is SuperwallEvent.TransactionFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_FAIL,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        error = event.error.message
                    )
                is SuperwallEvent.TransactionAbandon ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_ABANDON,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        product = event.product.pigeonify()
                    )
                is SuperwallEvent.TransactionComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_COMPLETE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        transaction = event.transaction?.pigeonify(),
                        product = event.product.pigeonify()
                    )
                is SuperwallEvent.SubscriptionStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.SUBSCRIPTION_START,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        product = event.product.pigeonify()
                    )
                is SuperwallEvent.FreeTrialStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.FREE_TRIAL_START,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        product = event.product.pigeonify()
                    )
                is SuperwallEvent.TransactionRestore ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_RESTORE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        restoreType = event.restoreType.pigeonify()
                    )
                is SuperwallEvent.Restore.Start -> PSuperwallEventInfo(eventType = PEventType.RESTORE_START, params = params)
                is SuperwallEvent.Restore.Fail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.RESTORE_FAIL,
                        params = params,
                        message = event.reason
                    )
                is SuperwallEvent.Restore.Complete -> PSuperwallEventInfo(eventType = PEventType.RESTORE_COMPLETE, params = params)
                is SuperwallEvent.TransactionTimeout ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_TIMEOUT,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                    )
                is SuperwallEvent.UserAttributes ->
                    PSuperwallEventInfo(
                        eventType = PEventType.USER_ATTRIBUTES,
                        params = params,
                        userAttributes = event.attributes
                    )
                is SuperwallEvent.NonRecurringProductPurchase ->
                    PSuperwallEventInfo(
                        eventType = PEventType.NON_RECURRING_PRODUCT_PURCHASE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        product = event.product.pigeonify()
                    )
                is SuperwallEvent.PaywallResponseLoadStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESPONSE_LOAD_START,
                        params = params,
                        triggeredPlacementName = event.triggeredPlacementName
                    )
                is SuperwallEvent.PaywallResponseLoadNotFound ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESPONSE_LOAD_NOT_FOUND,
                        params = params,
                        triggeredPlacementName = event.triggeredPlacementName
                    )
                is SuperwallEvent.PaywallResponseLoadFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESPONSE_LOAD_FAIL,
                        params = params,
                        triggeredPlacementName = event.triggeredPlacementName
                    )
                is SuperwallEvent.PaywallResponseLoadComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESPONSE_LOAD_COMPLETE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        triggeredPlacementName = event.triggeredPlacementName
                    )
                is SuperwallEvent.PaywallWebviewLoadStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_START,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                    )
                is SuperwallEvent.PaywallWebviewLoadFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_FAIL,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        error = event.errorMessage.toString()
                    )
                is SuperwallEvent.PaywallWebviewLoadComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_COMPLETE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                    )
                is SuperwallEvent.PaywallWebviewLoadTimeout ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_TIMEOUT,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                    )
                is SuperwallEvent.PaywallWebviewLoadFallback ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_FALLBACK,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                    )
                is SuperwallEvent.PaywallProductsLoadStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_PRODUCTS_LOAD_START,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        triggeredPlacementName = event.triggeredPlacementName
                    )
                is SuperwallEvent.PaywallProductsLoadFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_PRODUCTS_LOAD_FAIL,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        triggeredPlacementName = event.triggeredPlacementName,
                        error = event.errorMessage
                    )
                is SuperwallEvent.PaywallProductsLoadComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_PRODUCTS_LOAD_COMPLETE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        triggeredPlacementName = event.triggeredPlacementName
                    )
                is SuperwallEvent.PaywallResourceLoadFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESOURCE_LOAD_FAIL,
                        params = params,
                        error = event.error
                    )
                is SuperwallEvent.PaywallPresentationRequest ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_PRESENTATION_REQUEST,
                        params = params,
                        status = event.status.pigeonify(),
                        reason = event.reason?.pigeonify()
                    )
                is SuperwallEvent.SurveyResponse ->
                    PSuperwallEventInfo(
                        eventType = PEventType.SURVEY_RESPONSE,
                        params = params,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        survey = event.survey.pigeonify(),
                        selectedOption = PSurveyOption(event.selectedOption.id, event.selectedOption.title),
                        customResponse = event.customResponse
                    )
                is SuperwallEvent.SurveyClose -> PSuperwallEventInfo(eventType = PEventType.SURVEY_CLOSE, params = params)
                is SuperwallEvent.ConfigRefresh -> PSuperwallEventInfo(eventType = PEventType.CONFIG_REFRESH, params = params)
                is SuperwallEvent.ConfigFail -> PSuperwallEventInfo(eventType = PEventType.CONFIG_FAIL, params = params)
                is SuperwallEvent.ConfirmAllAssignments -> PSuperwallEventInfo(eventType = PEventType.CONFIRM_ALL_ASSIGNMENTS, params = params)
                is SuperwallEvent.Reset -> PSuperwallEventInfo(eventType = PEventType.RESET, params = params)
                is SuperwallEvent.CustomPlacement ->
                    PSuperwallEventInfo(
                        eventType = PEventType.CUSTOM_PLACEMENT,
                        params = params,
                        paywallInfo = event.paywallInfo?.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        name = event.placementName
                    )
                is SuperwallEvent.ShimmerViewStart -> PSuperwallEventInfo(eventType = PEventType.SHIMMER_VIEW_START, params = params)
                is SuperwallEvent.ShimmerViewComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.SHIMMER_VIEW_COMPLETE,
                        params = params
                    )
                is SuperwallEvent.RedemptionStart -> PSuperwallEventInfo(eventType = PEventType.REDEMPTION_START, params = params)
                is SuperwallEvent.RedemptionComplete -> PSuperwallEventInfo(eventType = PEventType.REDEMPTION_COMPLETE, params = params)
                is SuperwallEvent.RedemptionFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.REDEMPTION_FAIL,
                        params = params,
                        error = event.rawName
                    )
                else -> PSuperwallEventInfo(eventType = PEventType.CUSTOM_PLACEMENT, params = params, name = event.rawName)
            }
        }


        /**
         * Maps Map<String, Any?> to Map<String, Object> for use in Dart
         * Handles all basic types, maps, and lists recursively
         */
        fun mapParamsForDart(params: Map<String, Any>?): Map<String, Object>? {
            if (params == null) return null
            
            return params.mapValues { (_, value) ->
                mapValueForDart(value)
            }
        }

        /**
         * Recursively maps any value to Object for use in Dart
         */
        private fun mapValueForDart(value: Any): Object {
            return when (value) {
                is String -> value as Object
                is Boolean -> value as Object
                is Int -> value as Object
                is Long -> value as Object
                is Float -> value as Object
                is Double -> value as Object
                is Map<*, *> -> {
                    @Suppress("UNCHECKED_CAST")
                    val stringMap = value.filter { it.value != null } as? Map<String, Any>
                    if (stringMap != null) {
                        mapParamsForDart(stringMap as Map<String, Any>) as Object
                    } else {
                        // Handle non-string key maps by converting to string keys
                        value.filter { it.value !=null } .mapKeys { it.key?.toString() ?: "null" }.mapValues { mapValueForDart(it.value!!) } as Object
                    }
                }
                is List<*> -> {
                    value.filterNotNull().map { mapValueForDart(it) } as Object
                }
                is Array<*> -> {
                    value.filterNotNull().map { mapValueForDart(it) } as Object
                }
                else -> value.toString() as Object
            }
        }
    }
}