import com.superwall.sdk.analytics.superwall.SuperwallPlacement
import com.superwall.sdk.analytics.superwall.SuperwallPlacementInfo
import com.superwall.sdk.store.abstractions.transactions.StoreTransaction
import com.superwall.superwallkit_flutter.bridges.createBridgeId
import com.superwall.superwallkit_flutter.json.toJson

suspend fun SuperwallPlacementInfo.toJson(): Map<String, Any> {
    return mapOf(
        "placement" to placement.toJson(),
        "params" to params
    )
}

suspend fun SuperwallPlacement.toJson(): Map<String, Any?> {
    return when (this) {
        is SuperwallPlacement.FirstSeen -> mapOf("placement" to "firstSeen")
        is SuperwallPlacement.AppOpen -> mapOf("placement" to "appOpen")
        is SuperwallPlacement.AppLaunch -> mapOf("placement" to "appLaunch")
        is SuperwallPlacement.IdentityAlias -> mapOf("placement" to "identityAlias")
        is SuperwallPlacement.AppInstall -> mapOf("placement" to "appInstall")
        is SuperwallPlacement.SessionStart -> mapOf("placement" to "sessionStart")
        is SuperwallPlacement.Reset -> mapOf("placement" to "reset")
        is SuperwallPlacement.Restore.Start -> mapOf("placement" to "restoreStart")
        is SuperwallPlacement.Restore.Complete -> mapOf("placement" to "restoreComplete")
        is SuperwallPlacement.Restore.Fail -> {
            mapOf("placement" to "restoreFail")
            mapOf("message" to this.reason)
        }

        is SuperwallPlacement.DeviceAttributes -> mapOf(
            "placement" to "deviceAttributes",
            "attributes" to this.attributes
        )

        is SuperwallPlacement.SubscriptionStatusDidChange -> mapOf("placement" to "subscriptionStatusDidChange")
        is SuperwallPlacement.AppClose -> mapOf("placement" to "appClose")
        is SuperwallPlacement.DeepLink -> mapOf("placement" to "deepLink", "url" to this.uri.toString())
        is SuperwallPlacement.TriggerFire -> mapOf(
            "placement" to "triggerFire",
            "placementName" to this.placementName,
            "result" to this.result.toJson()
        )

        is SuperwallPlacement.PaywallOpen -> mapOf(
            "placement" to "paywallOpen",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallClose -> mapOf(
            "placement" to "paywallClose",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallDecline -> mapOf(
            "placement" to "paywallDecline",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.TransactionStart -> mapOf(
            "placement" to "transactionStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.TransactionFail -> mapOf(
            "placement" to "transactionFail",
            "error" to this.error.localizedMessage,
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.TransactionAbandon -> mapOf(
            "placement" to "transactionAbandon",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.TransactionComplete -> {
            val json = mutableMapOf<String, Any?>(
                "placement" to "transactionComplete",
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

        is SuperwallPlacement.SubscriptionStart -> mapOf(
            "placement" to "subscriptionStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.FreeTrialStart -> mapOf(
            "placement" to "freeTrialStart",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.TransactionRestore -> mapOf(
            "placement" to "transactionRestore",
            "restoreType" to this.restoreType.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.TransactionTimeout -> mapOf(
            "placement" to "transactionTimeout",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.UserAttributes -> mapOf(
            "placement" to "userAttributes",
            "attributes" to this.attributes
        )

        is SuperwallPlacement.NonRecurringProductPurchase -> mapOf(
            "placement" to "nonRecurringProductPurchase",
            "product" to this.product.toJson(),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallResponseLoadStart -> mapOf(
            "placement" to "paywallResponseLoadStart",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: "")
        )

        is SuperwallPlacement.PaywallResponseLoadNotFound -> mapOf(
            "placement" to "paywallResponseLoadNotFound",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: "")
        )

        is SuperwallPlacement.PaywallResponseLoadFail -> mapOf(
            "placement" to "paywallResponseLoadFail",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: "")
        )

        is SuperwallPlacement.PaywallResponseLoadComplete -> mapOf(
            "placement" to "paywallResponseLoadComplete",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: ""),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallWebviewLoadStart -> mapOf(
            "placement" to "paywallWebviewLoadStart",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallWebviewLoadFail -> mapOf(
            "placement" to "paywallWebviewLoadFail",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallWebviewLoadComplete -> mapOf(
            "placement" to "paywallWebviewLoadComplete",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )
        is SuperwallPlacement.PaywallWebviewLoadFallback -> mapOf(
            "placement" to "paywallWebviewLoadFallback",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallWebviewLoadTimeout -> mapOf(
            "placement" to "paywallWebviewLoadTimeout",
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallProductsLoadStart -> mapOf(
            "placement" to "paywallProductsLoadStart",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: ""),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallProductsLoadFail -> mapOf(
            "placement" to "paywallProductsLoadFail",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: ""),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallProductsLoadComplete -> mapOf(
            "placement" to "paywallProductsLoadComplete",
            "triggeredPlacementName" to (this.triggeredPlacementName ?: "")
        )

        is SuperwallPlacement.SurveyResponse -> mapOf(
            "placement" to "surveyResponse",
            "survey" to this.survey.toJson(),
            "selectedOption" to this.selectedOption.toJson(),
            "customResponse" to (this.customResponse ?: ""),
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )

        is SuperwallPlacement.PaywallPresentationRequest -> {
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
        is SuperwallPlacement.SurveyClose -> mapOf("placement" to "surveyClose")
        is SuperwallPlacement.ConfigRefresh -> mapOf("placement" to "configRefresh")
        is SuperwallPlacement.ConfigAttributes -> mapOf("placement" to "configAttributes")
        is SuperwallPlacement.CustomPlacement -> mapOf(
            "placement" to "customPlacement",
            "name" to this.placementName,
            "params" to this.params,
            "paywallInfoBridgeId" to this.paywallInfo.createBridgeId()
        )
        is SuperwallPlacement.ConfigFail -> mapOf("placement" to "configFail")
        is SuperwallPlacement.ConfirmAllAssignments -> mapOf("placement" to "confirmAllAssignments")
        is SuperwallPlacement.PaywallResourceLoadFail ->  mapOf("placement" to "paywallResourceLoadFail")
        is SuperwallPlacement.ShimmerViewComplete ->  mapOf("placement" to "shimmerViewComplete")
        else -> {mapOf()}

    }
}