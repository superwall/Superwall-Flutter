import com.superwall.sdk.analytics.superwall.SuperwallEvent
import com.superwall.sdk.analytics.superwall.SuperwallEventInfo
import com.superwall.sdk.store.abstractions.transactions.StoreTransaction
import com.superwall.superwallkit_flutter.json.toJson

suspend fun SuperwallEventInfo.toJson(): Map<String, Any> {
    return mapOf(
        "placement" to placement.toJson(),
        "params" to params
    )
}

suspend fun SuperwallEvent.toJson(): Map<String, Any?> {
    return when (this) {
        is SuperwallEvent.FirstSeen -> mapOf("placement" to "firstSeen")
        is SuperwallEvent.AppOpen -> mapOf("placement" to "appOpen")
        is SuperwallEvent.AppLaunch -> mapOf("placement" to "appLaunch")
        is SuperwallEvent.IdentityAlias -> mapOf("placement" to "identityAlias")
        is SuperwallEvent.AppInstall -> mapOf("placement" to "appInstall")
        is SuperwallEvent.SessionStart -> mapOf("placement" to "sessionStart")
        is SuperwallEvent.Reset -> mapOf("placement" to "reset")
        is SuperwallEvent.Restore.Start -> mapOf("placement" to "restoreStart")
        is SuperwallEvent.Restore.Complete -> mapOf("placement" to "restoreComplete")
        is SuperwallEvent.Restore.Fail -> {
            mapOf("placement" to "restoreFail")
            mapOf("message" to this.reason)
        }

        is SuperwallEvent.DeviceAttributes -> mapOf(
            "placement" to "deviceAttributes",
            "attributes" to this.attributes
        )

        //is SuperwallEvent.SubscriptionStatusDidChange -> mapOf("placement" to "subscriptionStatusDidChange")
        is SuperwallEvent.AppClose -> mapOf("placement" to "appClose")
        is SuperwallEvent.DeepLink -> mapOf("placement" to "deepLink", "url" to this.uri.toString())
        is SuperwallEvent.TriggerFire -> mapOf(
            "placement" to "triggerFire",
            "placementName" to this.placementName,
            "result" to this.result.toJson()
        )

        is SuperwallEvent.PaywallOpen -> mapOf(
            "placement" to "paywallOpen",
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallClose -> mapOf(
            "placement" to "paywallClose",
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallDecline -> mapOf(
            "placement" to "paywallDecline",
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.TransactionStart -> mapOf(
            "placement" to "transactionStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.TransactionFail -> mapOf(
            "placement" to "transactionFail",
            "error" to this.error.localizedMessage,
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.TransactionAbandon -> mapOf(
            "placement" to "transactionAbandon",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.TransactionComplete -> {
            val json = mutableMapOf<String, Any?>(
                "placement" to "transactionComplete",
                "product" to this.product.toJson(),
                "paywallInfoBridgeId" to ""
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
            "placement" to "subscriptionStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.FreeTrialStart -> mapOf(
            "placement" to "freeTrialStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.TransactionRestore -> mapOf(
            "placement" to "transactionRestore",
            "restoreType" to this.restoreType.toJson(),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.TransactionTimeout -> mapOf(
            "placement" to "transactionTimeout",
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.UserAttributes -> mapOf(
            "placement" to "userAttributes",
            "attributes" to this.attributes
        )

        is SuperwallEvent.NonRecurringProductPurchase -> mapOf(
            "placement" to "nonRecurringProductPurchase",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallResponseLoadStart -> mapOf(
            "placement" to "paywallResponseLoadStart",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: "")
        )

        is SuperwallEvent.PaywallResponseLoadNotFound -> mapOf(
            "placement" to "paywallResponseLoadNotFound",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: "")
        )

        is SuperwallEvent.PaywallResponseLoadFail -> mapOf(
            "placement" to "paywallResponseLoadFail",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: "")
        )

        is SuperwallEvent.PaywallResponseLoadComplete -> mapOf(
            "placement" to "paywallResponseLoadComplete",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: ""),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallWebviewLoadStart -> mapOf(
            "placement" to "paywallWebviewLoadStart",
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallWebviewLoadFail -> mapOf(
            "placement" to "paywallWebviewLoadFail",
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallWebviewLoadComplete -> mapOf(
            "placement" to "paywallWebviewLoadComplete",
            "paywallInfoBridgeId" to ""
        )
        is SuperwallEvent.PaywallWebviewLoadFallback -> mapOf(
            "placement" to "paywallWebviewLoadFallback",
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallWebviewLoadTimeout -> mapOf(
            "placement" to "paywallWebviewLoadTimeout",
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallProductsLoadStart -> mapOf(
            "placement" to "paywallProductsLoadStart",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: ""),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallProductsLoadFail -> mapOf(
            "placement" to "paywallProductsLoadFail",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: ""),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallProductsLoadComplete -> mapOf(
            "placement" to "paywallProductsLoadComplete",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: "")
        )

        is SuperwallEvent.SurveyResponse -> mapOf(
            "placement" to "surveyResponse",
            "survey" to this.survey.toJson(),
            "selectedOption" to this.selectedOption.toJson(),
            "customResponse" to (this.customResponse ?: ""),
            "paywallInfoBridgeId" to ""
        )

        is SuperwallEvent.PaywallPresentationRequest -> {
            val json = mutableMapOf(
                "placement" to "paywallPresentationRequest",
                "status" to this.status.toJson()
            )
            val reasonJson = this.reason?.toJson()
            if (reasonJson != null) {
                json["reason"] = reasonJson
            }
            return json
        }
        is SuperwallEvent.SurveyClose -> mapOf("placement" to "surveyClose")
        is SuperwallEvent.ConfigRefresh -> mapOf("placement" to "configRefresh")
        is SuperwallEvent.ConfigAttributes -> mapOf("placement" to "configAttributes")
        is SuperwallEvent.CustomPlacement -> mapOf(
            "placement" to "customPlacement",
            "name" to this.placementName,
            "params" to this.params,
            "paywallInfoBridgeId" to ""
        )
        is SuperwallEvent.ConfigFail -> mapOf("placement" to "configFail")
        is SuperwallEvent.ConfirmAllAssignments -> mapOf("placement" to "confirmAllAssignments")
        is SuperwallEvent.PaywallResourceLoadFail ->  mapOf("placement" to "paywallResourceLoadFail")
        is SuperwallEvent.ShimmerViewStart -> mapOf("placement" to "shimmerViewStart")
        is SuperwallEvent.ShimmerViewComplete ->  mapOf("placement" to "shimmerViewComplete")
        else -> {mapOf()}

    }
}