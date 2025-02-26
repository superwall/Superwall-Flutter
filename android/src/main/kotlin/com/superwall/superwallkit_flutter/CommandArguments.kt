package com.superwall.superwallkit_flutter

import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.logger.LogLevel
import com.superwall.sdk.logger.LogScope
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.models.product.ProductItem
import com.superwall.sdk.models.triggers.TriggerResult
import com.superwall.sdk.paywall.presentation.PaywallCloseReason
import com.superwall.sdk.paywall.presentation.internal.state.PaywallResult
import com.superwall.sdk.store.Entitlements
import com.superwall.sdk.store.abstractions.product.StoreProduct
import com.superwall.superwallkit_flutter.json.JsonExtensions
import logLevelFromJson
import superwallOptionsFromJson
import toJson
import kotlin.reflect.KClass

/**
 * Type identifiers for CommandArguments to make the code resilient to obfuscation.
 */
enum class CommandArgumentType(val typeName: String) {
    UNIT("UNIT"),
    STRING("STRING"),
    MAP("MAP"),
    LOG_LEVEL("LOG_LEVEL"),
    SUPERWALL_OPTIONS("SUPERWALL_OPTIONS"),
    PAYWALL_CLOSE_REASON("PAYWALL_CLOSE_REASON"),
    ENTITLEMENTS("ENTITLEMENTS"),
    TRIGGER_RESULT("TRIGGER_RESULT"),
    PAYWALL_RESULT("PAYWALL_RESULT"),
    STORE_PRODUCT("STORE_PRODUCT"),
    PRODUCT_ITEM("PRODUCT_ITEM"),
    SUBSCRIPTION_STATUS("SUBSCRIPTION_STATUS")
    
}

/**
 * A sealed interface for command arguments that can be converted to and from JSON.
 * Each implementation represents a specific type of command argument.
 */
sealed interface CommandArguments {
    /**
     * The type identifier for this command argument.
     * This is used instead of class names to make the code resilient to obfuscation.
     */
    val type: String
    
    /**
     * Convert the command arguments to a JSON map.
     */
    fun toJson(): Map<String, Any?>

    companion object {
        /**
         * Create a CommandArguments instance from a JSON map.
         */
        fun fromJson(json: Map<String, Any?>, type: String): CommandArguments {
            return when (type) {
                CommandArgumentType.UNIT.typeName -> Void
                CommandArgumentType.STRING.typeName -> StringCommandArguments.fromJson(json)
                CommandArgumentType.MAP.typeName -> MapCommandArguments.fromJson(json)
                CommandArgumentType.LOG_LEVEL.typeName -> LogLevelCommandArguments.fromJson(json)
                CommandArgumentType.SUPERWALL_OPTIONS.typeName -> SuperwallOptionsCommandArguments.fromJson(json)
                CommandArgumentType.PAYWALL_CLOSE_REASON.typeName -> PaywallCloseReasonCommandArguments.fromJson(json)
                CommandArgumentType.ENTITLEMENTS.typeName -> EntitlementsCommandArguments.fromJson(json)
                CommandArgumentType.TRIGGER_RESULT.typeName -> TriggerResultCommandArguments.fromJson(json)
                CommandArgumentType.PAYWALL_RESULT.typeName -> PaywallResultCommandArguments.fromJson(json)
                CommandArgumentType.STORE_PRODUCT.typeName -> StoreProductCommandArguments.fromJson(json)
                CommandArgumentType.PRODUCT_ITEM.typeName -> ProductItemCommandArguments.fromJson(json)
                CommandArgumentType.SUBSCRIPTION_STATUS.typeName -> SubscriptionStatusCommandArguments.fromJson(json)
                else -> throw IllegalArgumentException("Unknown command argument type: $type")
            }
        }
    }
}

/**
 * Empty command arguments for commands that don't require any parameters.
 */
object Void : CommandArguments {
    override val type: String = CommandArgumentType.UNIT.typeName
    override fun toJson(): Map<String, Any?> = emptyMap()
}

/**
 * Simple wrapper for string arguments.
 */
data class StringCommandArguments(val value: String) : CommandArguments {
    override val type: String = CommandArgumentType.STRING.typeName
    override fun toJson(): Map<String, Any?> = mapOf("value" to value)
    
    companion object {
        fun fromJson(json: Map<String, Any?>): StringCommandArguments {
            return StringCommandArguments(json["value"] as String)
        }
    }
}

/**
 * Generic map arguments for commands that take arbitrary key-value pairs.
 */
data class MapCommandArguments(val map: Map<String, Any?>) : CommandArguments {
    override val type: String = CommandArgumentType.MAP.typeName
    override fun toJson(): Map<String, Any?> = map
    
    companion object {
        fun fromJson(json: Map<String, Any?>): MapCommandArguments {
            return MapCommandArguments(json)
        }
    }
}

/**
 * LogLevel command arguments.
 */
data class LogLevelCommandArguments(val logLevel: LogLevel) : CommandArguments {
    override val type: String = CommandArgumentType.LOG_LEVEL.typeName
    override fun toJson(): Map<String, Any?> = mapOf("value" to logLevel.toJson())
    
    companion object {
        fun fromJson(json: Map<String, Any?>): LogLevelCommandArguments {
            val levelString = json["value"] as String
            val logLevel = JsonExtensions.logLevelFromJson(levelString) ?: LogLevel.none
            return LogLevelCommandArguments(logLevel)
        }
    }
}

/**
 * Extension function to convert LogLevel to JSON string.
 */
fun LogLevel.toJson(): String {
    return when (this) {
        LogLevel.debug -> "debug"
        LogLevel.info -> "info"
        LogLevel.warn -> "warn"
        LogLevel.error -> "error"
        LogLevel.none -> "none"
        else -> "unknown"
    }
}

/**
 * SuperwallOptions command arguments.
 */
data class SuperwallOptionsCommandArguments(val options: SuperwallOptions) : CommandArguments {
    override val type: String = CommandArgumentType.SUPERWALL_OPTIONS.typeName
    override fun toJson(): Map<String, Any?> {
        throw NotImplementedError()
    }
    
    companion object {
        fun fromJson(json: Map<String, Any?>): SuperwallOptionsCommandArguments {
            return SuperwallOptionsCommandArguments(JsonExtensions.superwallOptionsFromJson(json) ?: SuperwallOptions())
        }
    }
}

/**
 * Extension function to convert LogScope to JSON string.
 */
fun LogScope.toJson(): String {
    return when (this) {
        LogScope.localizationManager -> "localizationmanager"
        LogScope.bounceButton -> "bouncebutton" 
        LogScope.coreData -> "coredata"
        LogScope.configManager -> "configmanager"
        LogScope.identityManager -> "identitymanager"
        LogScope.debugManager -> "debugmanager"
        LogScope.debugView -> "debugviewcontroller"
        LogScope.localizationView -> "localizationviewcontroller"
        LogScope.gameControllerManager -> "gamecontrollermanager"
        LogScope.device -> "device"
        LogScope.network -> "network"
        LogScope.paywallEvents -> "paywallevents"
        LogScope.productsManager -> "productsmanager"
        LogScope.storeKitManager -> "storekitmanager"
        LogScope.placements -> "placements"
        LogScope.receipts -> "receipts"
        LogScope.superwallCore -> "superwallcore"
        LogScope.transactions -> "transactions"
        LogScope.jsEvaluator -> "jsevaluator"
        LogScope.paywallPresentation -> "paywallpresentation"
        LogScope.paywallTransactions -> "paywalltransactions"
        LogScope.paywallView -> "paywallviewcontroller"
        LogScope.nativePurchaseController -> "nativepurchasecontroller"
        LogScope.cache -> "cache"
        LogScope.all -> "all"
        else -> "unknown"
    }
}

/**
 * PaywallCloseReason command arguments.
 */
data class PaywallCloseReasonCommandArguments(val reason: PaywallCloseReason) : CommandArguments {
    override val type: String = CommandArgumentType.PAYWALL_CLOSE_REASON.typeName
    override fun toJson(): Map<String, Any?> = mapOf("value" to reason.toJson())
    
    companion object {
        fun fromJson(json: Map<String, Any?>): PaywallCloseReasonCommandArguments {
            val reasonString = json["value"] as String
            val reason = when (reasonString) {
                "systemLogic" -> PaywallCloseReason.SystemLogic
                "forNextPaywall" -> PaywallCloseReason.ForNextPaywall
                "webViewFailedToLoad" -> PaywallCloseReason.WebViewFailedToLoad
                "manualClose" -> PaywallCloseReason.ManualClose
                "none" -> PaywallCloseReason.None
                else -> PaywallCloseReason.None
            }
            return PaywallCloseReasonCommandArguments(reason)
        }
    }
}

/**
 * Extension function to convert PaywallCloseReason to JSON string.
 */
fun PaywallCloseReason.toJson(): String {
    return when (this) {
        PaywallCloseReason.SystemLogic -> "systemLogic"
        PaywallCloseReason.ForNextPaywall -> "forNextPaywall"
        PaywallCloseReason.WebViewFailedToLoad -> "webViewFailedToLoad"
        PaywallCloseReason.ManualClose -> "manualClose"
        PaywallCloseReason.None -> "none"
    }
}

/**
 * Entitlements command arguments.
 */
data class EntitlementsCommandArguments(val entitlements: Entitlements) : CommandArguments {
    override val type: String = CommandArgumentType.ENTITLEMENTS.typeName
    override fun toJson(): Map<String, Any?> {
        return mapOf(
            "active" to entitlements.active.map { it.toJson() },
            "inactive" to entitlements.inactive.map { it.toJson() },
            "all" to entitlements.all.map { it.toJson() }
        )
    }
    
    companion object {
        fun fromJson(json: Map<String, Any?>): EntitlementsCommandArguments {
            throw NotImplementedError("Not implemented")
        }
    }
}

/**
 * Extension function to convert Entitlement to JSON map.
 */
fun Entitlement.toJson(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "type" to type.raw
    )
}

/**
 * Extension function to convert Map to Entitlement.
 */
fun Map<String, Any>.toEntitlement(): Entitlement {
    return Entitlement(
        id = this["id"] as String,
        type = Entitlement.Type.SERVICE_LEVEL
    )
}

/**
 * SubscriptionStatus command arguments.
 */
data class SubscriptionStatusCommandArguments(val status: SubscriptionStatus) : CommandArguments {
    override val type: String = CommandArgumentType.SUBSCRIPTION_STATUS.typeName
    override fun toJson(): Map<String, Any?> {
        return when (status) {
            is SubscriptionStatus.Active -> mapOf(
                "type" to "active",
                "entitlements" to status.entitlements.map { it.toJson() }
            )
            is SubscriptionStatus.Inactive -> mapOf("type" to "inactive")
            is SubscriptionStatus.Unknown -> mapOf("type" to "unknown")
        }
    }
    
    companion object {
        fun fromJson(json: Map<String, Any?>): SubscriptionStatusCommandArguments {
            val type = json["type"] as String
            val status = when (type) {
                "active" -> {
                    val entitlementsList = (json["entitlements"] as? List<Map<String, Any>>)?.map { it.toEntitlement() } ?: emptyList()
                    SubscriptionStatus.Active(entitlementsList.toSet())
                }
                "inactive" -> SubscriptionStatus.Inactive
                else -> SubscriptionStatus.Unknown
            }
            return SubscriptionStatusCommandArguments(status)
        }
    }
}

/**
 * TriggerResult command arguments.
 */
data class TriggerResultCommandArguments(val result: TriggerResult) : CommandArguments {
    override val type: String = CommandArgumentType.TRIGGER_RESULT.typeName
    override fun toJson(): Map<String, Any?> {
           return result.toJson()
    }
    
    companion object {
        fun fromJson(json: Map<String, Any?>): TriggerResultCommandArguments {
            val resultType = json["result"] as String
            val result = when (resultType) {
                "placementNotFound" -> TriggerResult.PlacementNotFound
                "noAudienceMatch" -> TriggerResult.NoAudienceMatch
                // Note: These cases would require more complex handling with bridge instances
                // For simplicity, we're returning placeholder values
                "paywall" -> TriggerResult.PlacementNotFound // Placeholder
                "holdout" -> TriggerResult.PlacementNotFound // Placeholder
                "error" -> TriggerResult.Error(Exception(json["error"] as? String ?: "Unknown error"))
                else -> TriggerResult.PlacementNotFound
            }
            return TriggerResultCommandArguments(result)
        }
    }
}

/**
 * PaywallResult command arguments.
 */
data class PaywallResultCommandArguments(val result: PaywallResult) : CommandArguments {
    override val type: String = CommandArgumentType.PAYWALL_RESULT.typeName
    override fun toJson(): Map<String, Any?> {
        return when (result) {
            is PaywallResult.Purchased -> mapOf(
                "type" to "purchased",
                "product" to mapOf(
                    "productId" to result.productId
                )
            )
            is PaywallResult.Restored -> mapOf("type" to "restored")
            is PaywallResult.Declined -> mapOf("type" to "declined")
        }
    }
    
    companion object {
        fun fromJson(json: Map<String, Any?>): PaywallResultCommandArguments {
            val resultType = json["type"] as String
            val result = when (resultType) {
                "purchased" -> {
                    val product = json["product"] as? Map<String, Any>
                    val productId = product?.get("productId") as? String ?: ""
                    PaywallResult.Purchased(productId)
                }
                "restored" -> PaywallResult.Restored()
                "declined" -> PaywallResult.Declined()
                else -> PaywallResult.Declined()
            }
            return PaywallResultCommandArguments(result)
        }
    }
}

/**
 * StoreProduct command arguments.
 */
data class StoreProductCommandArguments(val product: StoreProduct) : CommandArguments {
    override val type: String = CommandArgumentType.STORE_PRODUCT.typeName
    override fun toJson(): Map<String, Any?> {
        val dateFormatter = java.time.format.DateTimeFormatter.ISO_DATE_TIME
            .withLocale(java.util.Locale.getDefault())

        val json = mutableMapOf<String, Any?>(
            "productIdentifier" to product.productIdentifier,
            "localizedPrice" to product.localizedPrice,
            "localizedSubscriptionPeriod" to product.localizedSubscriptionPeriod,
            "period" to product.period,
            "periodly" to product.periodly,
            "periodWeeks" to product.periodWeeks,
            "periodWeeksString" to product.periodWeeksString,
            "periodMonths" to product.periodMonths,
            "periodMonthsString" to product.periodMonthsString,
            "periodYears" to product.periodYears,
            "periodYearsString" to product.periodYearsString,
            "periodDays" to product.periodDays,
            "periodDaysString" to product.periodDaysString,
            "dailyPrice" to product.dailyPrice,
            "weeklyPrice" to product.weeklyPrice,
            "monthlyPrice" to product.monthlyPrice,
            "yearlyPrice" to product.yearlyPrice,
            "hasFreeTrial" to product.hasFreeTrial,
            "trialPeriodEndDateString" to product.trialPeriodEndDateString,
            "localizedTrialPeriodPrice" to product.localizedTrialPeriodPrice,
            "trialPeriodPrice" to product.trialPeriodPrice.toDouble(),
            "trialPeriodDays" to product.trialPeriodDays,
            "trialPeriodDaysString" to product.trialPeriodDaysString,
            "trialPeriodWeeks" to product.trialPeriodWeeks,
            "trialPeriodWeeksString" to product.trialPeriodWeeksString,
            "trialPeriodMonths" to product.trialPeriodMonths,
            "trialPeriodMonthsString" to product.trialPeriodMonthsString,
            "trialPeriodYears" to product.trialPeriodYears,
            "trialPeriodYearsString" to product.trialPeriodYearsString,
            "trialPeriodText" to product.trialPeriodText,
            "locale" to product.locale,
            "languageCode" to product.languageCode,
            "currencyCode" to product.currencyCode,
            "currencySymbol" to product.currencySymbol,
            "regionCode" to product.regionCode,
            "price" to product.price.toDouble()
        )

        product.trialPeriodEndDate?.let {
            val instant = it.toInstant()
            json["trialPeriodEndDate"] = instant.atZone(java.time.ZoneId.systemDefault()).format(dateFormatter)
        } ?: run {
            json["trialPeriodEndDate"] = null
        }

        return json
    }

    companion object {
        fun fromJson(json: Map<String, Any?>): StoreProductCommandArguments {
            throw NotImplementedError("Not implemented")
        }
    }
}

/**
 * ProductItem command arguments.
 */
data class ProductItemCommandArguments(val product: ProductItem) : CommandArguments {
    override val type: String = CommandArgumentType.PRODUCT_ITEM.typeName
    override fun toJson(): Map<String, Any?> {
        return mapOf(
            "type" to product.name,
            "entitlements" to product.entitlements.map { it.toJson() }
        )
    }
    
    companion object {
        fun fromJson(json: Map<String, Any?>): ProductItemCommandArguments {
            throw NotImplementedError("Not implemented")
        }
    }
} 