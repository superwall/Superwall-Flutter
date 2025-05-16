package com.superwall.superwallkit_flutter.utils

import PSuperwallEventInfo
import PSurveyOption
import android.net.Uri
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
            return when (val event = eventInfo.event) {
                is SuperwallEvent.FirstSeen -> PSuperwallEventInfo(eventType = PEventType.FIRST_SEEN)
                is SuperwallEvent.AppOpen -> PSuperwallEventInfo(eventType = PEventType.APP_OPEN)
                is SuperwallEvent.AppLaunch -> PSuperwallEventInfo(eventType = PEventType.APP_LAUNCH)
                is SuperwallEvent.IdentityAlias -> PSuperwallEventInfo(eventType = PEventType.IDENTITY_ALIAS)
                is SuperwallEvent.AppInstall -> PSuperwallEventInfo(eventType = PEventType.APP_INSTALL)
                is SuperwallEvent.SessionStart -> PSuperwallEventInfo(eventType = PEventType.SESSION_START)
                is SuperwallEvent.ConfigAttributes -> PSuperwallEventInfo(eventType = PEventType.CONFIG_ATTRIBUTES)
                is SuperwallEvent.DeviceAttributes -> PSuperwallEventInfo(
                    eventType = PEventType.DEVICE_ATTRIBUTES,
                    deviceAttributes = event.attributes
                )
                is SuperwallEvent.SubscriptionStatusDidChange -> PSuperwallEventInfo(eventType = PEventType.SUBSCRIPTION_STATUS_DID_CHANGE)
                is SuperwallEvent.AppClose -> PSuperwallEventInfo(eventType = PEventType.APP_CLOSE)
                is SuperwallEvent.DeepLink -> PSuperwallEventInfo(
                    eventType = PEventType.DEEP_LINK,
                    deepLinkUrl = event.uri.toString()
                )
                is SuperwallEvent.TriggerFire -> PSuperwallEventInfo(
                    eventType = PEventType.TRIGGER_FIRE,
                    placementName = event.placementName,
                    result = event.result.pigeonify()
                )
                is SuperwallEvent.PaywallOpen -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_OPEN,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallClose -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_CLOSE,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallDecline -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_DECLINE,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.TransactionStart -> PSuperwallEventInfo(
                    eventType = PEventType.TRANSACTION_START,
                    product = event.product.pigeonify(),
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.TransactionFail -> PSuperwallEventInfo(
                    eventType = PEventType.TRANSACTION_FAIL,
                    error = event.error.message,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.TransactionAbandon -> PSuperwallEventInfo(
                    eventType = PEventType.TRANSACTION_ABANDON,
                    product = event.product.pigeonify(),
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.TransactionComplete -> PSuperwallEventInfo(
                    eventType = PEventType.TRANSACTION_COMPLETE,
                    transaction = event.transaction?.pigeonify(),
                    product = event.product.pigeonify(),
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.SubscriptionStart -> PSuperwallEventInfo(
                    eventType = PEventType.SUBSCRIPTION_START,
                    product = event.product.pigeonify(),
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.FreeTrialStart -> PSuperwallEventInfo(
                    eventType = PEventType.FREE_TRIAL_START,
                    product = event.product.pigeonify(),
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.TransactionRestore -> PSuperwallEventInfo(
                    eventType = PEventType.TRANSACTION_RESTORE,
                    restoreType = event.restoreType.pigeonify(),
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.Restore.Start -> PSuperwallEventInfo(eventType = PEventType.RESTORE_START)
                is SuperwallEvent.Restore.Fail -> PSuperwallEventInfo(
                    eventType = PEventType.RESTORE_FAIL,
                    message = event.reason
                )
                is SuperwallEvent.Restore.Complete -> PSuperwallEventInfo(eventType = PEventType.RESTORE_COMPLETE)
                is SuperwallEvent.TransactionTimeout -> PSuperwallEventInfo(
                    eventType = PEventType.TRANSACTION_TIMEOUT,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.UserAttributes -> PSuperwallEventInfo(
                    eventType = PEventType.USER_ATTRIBUTES,
                    userAttributes = event.attributes
                )
                is SuperwallEvent.NonRecurringProductPurchase -> PSuperwallEventInfo(
                    eventType = PEventType.NON_RECURRING_PRODUCT_PURCHASE,
                    product = event.product.pigeonify(),
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallResponseLoadStart -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_RESPONSE_LOAD_START,
                    triggeredPlacementName = event.triggeredPlacementName
                )
                is SuperwallEvent.PaywallResponseLoadNotFound -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_RESPONSE_LOAD_NOT_FOUND,
                    triggeredPlacementName = event.triggeredPlacementName
                )
                is SuperwallEvent.PaywallResponseLoadFail -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_RESPONSE_LOAD_FAIL,
                    triggeredPlacementName = event.triggeredPlacementName
                )
                is SuperwallEvent.PaywallResponseLoadComplete -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_RESPONSE_LOAD_COMPLETE,
                    triggeredPlacementName = event.triggeredPlacementName,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallWebviewLoadStart -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_WEBVIEW_LOAD_START,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallWebviewLoadFail -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_WEBVIEW_LOAD_FAIL,
                    error = event.errorMessage.toString(),
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallWebviewLoadComplete -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_WEBVIEW_LOAD_COMPLETE,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallWebviewLoadTimeout -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_WEBVIEW_LOAD_TIMEOUT,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallWebviewLoadFallback -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_WEBVIEW_LOAD_FALLBACK,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallProductsLoadStart -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_PRODUCTS_LOAD_START,
                    triggeredPlacementName = event.triggeredPlacementName,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallProductsLoadFail -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_PRODUCTS_LOAD_FAIL,
                    error = event.errorMessage,
                    triggeredPlacementName = event.triggeredPlacementName,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallProductsLoadComplete -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_PRODUCTS_LOAD_COMPLETE,
                    triggeredPlacementName = event.triggeredPlacementName,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.PaywallResourceLoadFail -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_RESOURCE_LOAD_FAIL,
                    error = event.error
                )
                is SuperwallEvent.PaywallPresentationRequest -> PSuperwallEventInfo(
                    eventType = PEventType.PAYWALL_PRESENTATION_REQUEST,
                    status = event.status.pigeonify(),
                    reason = event.reason?.pigeonify()
                )
                is SuperwallEvent.SurveyResponse -> PSuperwallEventInfo(
                    eventType = PEventType.SURVEY_RESPONSE,
                    survey = event.survey.pigeonify(),
                    selectedOption = PSurveyOption(event.selectedOption.id, event.selectedOption.title),
                    customResponse = event.customResponse,
                    paywallInfo = event.paywallInfo.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.SurveyClose -> PSuperwallEventInfo(eventType = PEventType.SURVEY_CLOSE)
                is SuperwallEvent.ConfigRefresh -> PSuperwallEventInfo(eventType = PEventType.CONFIG_REFRESH)
                is SuperwallEvent.ConfigFail -> PSuperwallEventInfo(eventType = PEventType.CONFIG_FAIL)
                is SuperwallEvent.ConfirmAllAssignments -> PSuperwallEventInfo(eventType = PEventType.CONFIRM_ALL_ASSIGNMENTS)
                is SuperwallEvent.Reset -> PSuperwallEventInfo(eventType = PEventType.RESET)
                is SuperwallEvent.CustomPlacement -> PSuperwallEventInfo(
                    eventType = PEventType.CUSTOM_PLACEMENT,
                    name = event.placementName,
                    params = event.params,
                    paywallInfo = event.paywallInfo?.let { PaywallInfoMapper.toPPaywallInfo(it) }
                )
                is SuperwallEvent.ShimmerViewStart -> PSuperwallEventInfo(eventType = PEventType.SHIMMER_VIEW_START)
                is SuperwallEvent.ShimmerViewComplete -> PSuperwallEventInfo(
                    eventType = PEventType.SHIMMER_VIEW_COMPLETE
                )
                is SuperwallEvent.RedemptionStart -> PSuperwallEventInfo(eventType = PEventType.REDEMPTION_START)
                is SuperwallEvent.RedemptionComplete -> PSuperwallEventInfo(eventType = PEventType.REDEMPTION_COMPLETE)
                is SuperwallEvent.RedemptionFail -> PSuperwallEventInfo(
                    eventType = PEventType.REDEMPTION_FAIL,
                    error = event.rawName
                )
                else -> PSuperwallEventInfo(eventType = PEventType.CUSTOM_PLACEMENT, name = event.rawName)
            }
        }
    }
}