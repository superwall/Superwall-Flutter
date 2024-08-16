import com.superwall.sdk.analytics.superwall.SuperwallEvent
import com.superwall.sdk.analytics.superwall.SuperwallEventInfo
import com.superwall.sdk.store.abstractions.transactions.StoreTransaction
import com.superwall.superwallkit_flutter.bridges.createBridgeId
import com.superwall.superwallkit_flutter.json.toJson

fun SuperwallEventInfo.toJson(): Map<String, Any> {
    return mapOf(
        "event" to event.toJson(),
        "params" to params
    )
}

fun SuperwallEvent.toJson(): Map<String, Any?> {
    return when (this) {
        is SuperwallEvent.FirstSeen -> mapOf("event" to "firstSeen")
        is SuperwallEvent.AppOpen -> mapOf("event" to "appOpen")
        is SuperwallEvent.AppLaunch -> mapOf("event" to "appLaunch")
        is SuperwallEvent.IdentityAlias -> mapOf("event" to "identityAlias")
        is SuperwallEvent.AppInstall -> mapOf("event" to "appInstall")
        is SuperwallEvent.SessionStart -> mapOf("event" to "sessionStart")
        is SuperwallEvent.Reset -> mapOf("event" to "reset")
        is SuperwallEvent.Restore.Start -> mapOf("event" to "restoreStart")
        is SuperwallEvent.Restore.Complete -> mapOf("event" to "restoreComplete")
        is SuperwallEvent.Restore.Fail -> {
            mapOf("event" to "restoreFail")
            mapOf("message" to this.reason)
        }

        is SuperwallEvent.DeviceAttributes -> mapOf(
            "event" to "deviceAttributes",
            "attributes" to this.attributes
        )

        is SuperwallEvent.SubscriptionStatusDidChange -> mapOf("event" to "subscriptionStatusDidChange")
        is SuperwallEvent.AppClose -> mapOf("event" to "appClose")
        is SuperwallEvent.DeepLink -> mapOf("event" to "deepLink", "url" to this.uri.toString())
        is SuperwallEvent.TriggerFire -> mapOf(
            "event" to "triggerFire",
            "eventName" to this.eventName,
            "result" to this.result.toJson()
        )

        is SuperwallEvent.PaywallOpen -> mapOf(
            "event" to "paywallOpen",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallClose -> mapOf(
            "event" to "paywallClose",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallDecline -> mapOf(
            "event" to "paywallDecline",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.TransactionStart -> mapOf(
            "event" to "transactionStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.TransactionFail -> mapOf(
            "event" to "transactionFail",
            "error" to this.error.localizedMessage,
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.TransactionAbandon -> mapOf(
            "event" to "transactionAbandon",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.TransactionComplete -> {
            val json = mutableMapOf<String, Any?>(
                "event" to "transactionComplete",
                "product" to this.product.toJson(),
                "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
            )
            val transaction = this.transaction as? StoreTransaction
            val transactionJson = transaction?.toJson()
            if (transactionJson != null) {
                json["transaction"] = transactionJson
            }

            json["transaction"] = transaction?.toJson()
            return json
        }

        is SuperwallEvent.SubscriptionStart -> mapOf(
            "event" to "subscriptionStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.FreeTrialStart -> mapOf(
            "event" to "freeTrialStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.TransactionRestore -> mapOf(
            "event" to "transactionRestore",
            "restoreType" to this.restoreType.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.TransactionTimeout -> mapOf(
            "event" to "transactionTimeout",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.UserAttributes -> mapOf(
            "event" to "userAttributes",
            "attributes" to this.attributes
        )

        is SuperwallEvent.NonRecurringProductPurchase -> mapOf(
            "event" to "nonRecurringProductPurchase",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallResponseLoadStart -> mapOf(
            "event" to "paywallResponseLoadStart",
            "triggeredEventName" to (this.triggeredEventName ?: "")
        )

        is SuperwallEvent.PaywallResponseLoadNotFound -> mapOf(
            "event" to "paywallResponseLoadNotFound",
            "triggeredEventName" to (this.triggeredEventName ?: "")
        )

        is SuperwallEvent.PaywallResponseLoadFail -> mapOf(
            "event" to "paywallResponseLoadFail",
            "triggeredEventName" to (this.triggeredEventName ?: "")
        )

        is SuperwallEvent.PaywallResponseLoadComplete -> mapOf(
            "event" to "paywallResponseLoadComplete",
            "triggeredEventName" to (this.triggeredEventName ?: ""),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallWebviewLoadStart -> mapOf(
            "event" to "paywallWebviewLoadStart",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallWebviewLoadFail -> mapOf(
            "event" to "paywallWebviewLoadFail",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallWebviewLoadComplete -> mapOf(
            "event" to "paywallWebviewLoadComplete",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )
        is SuperwallEvent.PaywallWebviewLoadFallback -> mapOf(
            "event" to "paywallWebviewLoadFallback",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallWebviewLoadTimeout -> mapOf(
            "event" to "paywallWebviewLoadTimeout",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallProductsLoadStart -> mapOf(
            "event" to "paywallProductsLoadStart",
            "triggeredEventName" to (this.triggeredEventName ?: ""),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallProductsLoadFail -> mapOf(
            "event" to "paywallProductsLoadFail",
            "triggeredEventName" to (this.triggeredEventName ?: ""),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallProductsLoadComplete -> mapOf(
            "event" to "paywallProductsLoadComplete",
            "triggeredEventName" to (this.triggeredEventName ?: "")
        )

        is SuperwallEvent.SurveyResponse -> mapOf(
            "event" to "surveyResponse",
            "survey" to this.survey.toJson(),
            "selectedOption" to this.selectedOption.toJson(),
            "customResponse" to (this.customResponse ?: ""),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallEvent.PaywallPresentationRequest -> {
            val json = mutableMapOf(
                "event" to "paywallPresentationRequest",
                "status" to this.status.toJson()
            )
            val reasonJson = this.reason?.toJson()
            if (reasonJson != null) {
                json["reason"] = reasonJson
            }
            return json
        }
        is SuperwallEvent.SurveyClose -> mapOf("event" to "surveyClose")
        is SuperwallEvent.ConfigRefresh -> mapOf("event" to "configRefresh")
        is SuperwallEvent.ConfigAttributes -> mapOf("event" to "configAttributes")
        is SuperwallEvent.CustomPlacement -> mapOf(
            "event" to "customPlacement",
            "name" to this.placementName,
            "params" to this.params,
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )
        is SuperwallEvent.ErrorThrown -> mapOf("event" to "errorThrown")
    }
}