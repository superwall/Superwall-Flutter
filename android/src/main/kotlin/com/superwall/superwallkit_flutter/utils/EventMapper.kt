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
        fun toPigeonEventInfo(eventInfo: SuperwallEventInfo): PSuperwallEventInfo =
            val params = mapParamsForDart(eventInfo.params)
            return when (val event = eventInfo.event) {
                is SuperwallEvent.FirstSeen -> PSuperwallEventInfo(eventType = PEventType.FIRST_SEEN, params = params)
                is SuperwallEvent.AppOpen -> PSuperwallEventInfo(eventType = PEventType.APP_OPEN, params = params)
                is SuperwallEvent.AppLaunch -> PSuperwallEventInfo(eventType = PEventType.APP_LAUNCH)
                is SuperwallEvent.IdentityAlias -> PSuperwallEventInfo(eventType = PEventType.IDENTITY_ALIAS, params = params)
                is SuperwallEvent.AppInstall -> PSuperwallEventInfo(eventType = PEventType.APP_INSTALL, params = params)
                is SuperwallEvent.SessionStart -> PSuperwallEventInfo(eventType = PEventType.SESSION_START, params = params)
                is SuperwallEvent.ConfigAttributes -> PSuperwallEventInfo(eventType = PEventType.CONFIG_ATTRIBUTES, params = params)
                is SuperwallEvent.DeviceAttributes ->
                    PSuperwallEventInfo(
                        eventType = PEventType.DEVICE_ATTRIBUTES,
                        deviceAttributes = event.attributes,
                        params = params,
                    )
                is SuperwallEvent.SubscriptionStatusDidChange -> PSuperwallEventInfo(eventType = PEventType.SUBSCRIPTION_STATUS_DID_CHANGE, params = params)
                is SuperwallEvent.AppClose -> PSuperwallEventInfo(eventType = PEventType.APP_CLOSE, params = params)
                is SuperwallEvent.DeepLink ->
                    PSuperwallEventInfo(
                        eventType = PEventType.DEEP_LINK,
                        deepLinkUrl = event.uri.toString(),
                        params = params,
                    )
                is SuperwallEvent.TriggerFire ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRIGGER_FIRE,
                        placementName = event.placementName,
                        result = event.result.pigeonify(),
                        params = params,
                    )
                is SuperwallEvent.PaywallOpen ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_OPEN,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallClose ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_CLOSE,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallDecline ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_DECLINE,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.TransactionStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_START,
                        product = event.product.pigeonify(),
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.TransactionFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_FAIL,
                        error = event.error.message,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.TransactionAbandon ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_ABANDON,
                        product = event.product.pigeonify(),
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.TransactionComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_COMPLETE,
                        transaction = event.transaction?.pigeonify(),
                        product = event.product.pigeonify(),
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.SubscriptionStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.SUBSCRIPTION_START,
                        product = event.product.pigeonify(),
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.FreeTrialStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.FREE_TRIAL_START,
                        product = event.product.pigeonify(),
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.TransactionRestore ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_RESTORE,
                        restoreType = event.restoreType.pigeonify(),
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.Restore.Start -> PSuperwallEventInfo(eventType = PEventType.RESTORE_START)
                is SuperwallEvent.Restore.Fail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.RESTORE_FAIL,
                        message = event.reason,
                        params = params,
                    )
                is SuperwallEvent.Restore.Complete -> PSuperwallEventInfo(eventType = PEventType.RESTORE_COMPLETE)
                is SuperwallEvent.TransactionTimeout ->
                    PSuperwallEventInfo(
                        eventType = PEventType.TRANSACTION_TIMEOUT,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.UserAttributes ->
                    PSuperwallEventInfo(
                        eventType = PEventType.USER_ATTRIBUTES,
                        userAttributes = event.attributes,
                        params = params,
                    )
                is SuperwallEvent.NonRecurringProductPurchase ->
                    PSuperwallEventInfo(
                        eventType = PEventType.NON_RECURRING_PRODUCT_PURCHASE,
                        product = event.product.pigeonify(),
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallResponseLoadStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESPONSE_LOAD_START,
                        triggeredPlacementName = event.triggeredPlacementName,
                        params = params,
                    )
                is SuperwallEvent.PaywallResponseLoadNotFound ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESPONSE_LOAD_NOT_FOUND,
                        triggeredPlacementName = event.triggeredPlacementName,
                        params = params,
                    )
                is SuperwallEvent.PaywallResponseLoadFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESPONSE_LOAD_FAIL,
                        triggeredPlacementName = event.triggeredPlacementName,
                        params = params,
                    )
                is SuperwallEvent.PaywallResponseLoadComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESPONSE_LOAD_COMPLETE,
                        triggeredPlacementName = event.triggeredPlacementName,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallWebviewLoadStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_START,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallWebviewLoadFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_FAIL,
                        error = event.errorMessage.toString(),
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallWebviewLoadComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_COMPLETE,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallWebviewLoadTimeout ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_TIMEOUT,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallWebviewLoadFallback ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_WEBVIEW_LOAD_FALLBACK,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallProductsLoadStart ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_PRODUCTS_LOAD_START,
                        triggeredPlacementName = event.triggeredPlacementName,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallProductsLoadFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_PRODUCTS_LOAD_FAIL,
                        error = event.errorMessage,
                        triggeredPlacementName = event.triggeredPlacementName,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallProductsLoadComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_PRODUCTS_LOAD_COMPLETE,
                        triggeredPlacementName = event.triggeredPlacementName,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.PaywallResourceLoadFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_RESOURCE_LOAD_FAIL,
                        error = event.error,
                        params = params,
                    )
                is SuperwallEvent.PaywallPresentationRequest ->
                    PSuperwallEventInfo(
                        eventType = PEventType.PAYWALL_PRESENTATION_REQUEST,
                        status = event.status.pigeonify(),
                        reason = event.reason?.pigeonify(),
                        params = params,
                    )
                is SuperwallEvent.SurveyResponse ->
                    PSuperwallEventInfo(
                        eventType = PEventType.SURVEY_RESPONSE,
                        survey = event.survey.pigeonify(),
                        selectedOption = PSurveyOption(event.selectedOption.id, event.selectedOption.title),
                        customResponse = event.customResponse,
                        paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) },
                        params = params,
                    )
                is SuperwallEvent.SurveyClose -> PSuperwallEventInfo(eventType = PEventType.SURVEY_CLOSE, params = params)
                is SuperwallEvent.ConfigRefresh -> PSuperwallEventInfo(eventType = PEventType.CONFIG_REFRESH, params = params)
                is SuperwallEvent.ConfigFail -> PSuperwallEventInfo(eventType = PEventType.CONFIG_FAIL, params = params)
                is SuperwallEvent.ConfirmAllAssignments -> PSuperwallEventInfo(eventType = PEventType.CONFIRM_ALL_ASSIGNMENTS, params = params)
                is SuperwallEvent.Reset -> PSuperwallEventInfo(eventType = PEventType.RESET, params = params)
                is SuperwallEvent.CustomPlacement ->
                    PSuperwallEventInfo(
                        eventType = PEventType.CUSTOM_PLACEMENT,
                        name = event.placementName,
                        params = params,
                        paywallInfo = event.paywallInfo?.let { PaywallInfoMapper.toPPaywallInfo(it) },
                    )
                is SuperwallEvent.ShimmerViewStart -> PSuperwallEventInfo(eventType = PEventType.SHIMMER_VIEW_START, params = params)
                is SuperwallEvent.ShimmerViewComplete ->
                    PSuperwallEventInfo(
                        eventType = PEventType.SHIMMER_VIEW_COMPLETE,
                        params = params,
                    )
                is SuperwallEvent.RedemptionStart -> PSuperwallEventInfo(eventType = PEventType.REDEMPTION_START, params = params)
                is SuperwallEvent.RedemptionComplete -> PSuperwallEventInfo(eventType = PEventType.REDEMPTION_COMPLETE, params = params)
                is SuperwallEvent.RedemptionFail ->
                    PSuperwallEventInfo(
                        eventType = PEventType.REDEMPTION_FAIL,
                        error = event.rawName,
                        params = params,
                    )
                else -> PSuperwallEventInfo(eventType = PEventType.CUSTOM_PLACEMENT, name = event.rawName, params = params)
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
