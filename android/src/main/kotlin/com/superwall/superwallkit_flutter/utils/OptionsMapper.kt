package com.superwall.superwallkit_flutter.utils

import SuperwallOptions as HostOptions
import NetworkEnvironment as HostNetworkEnvironment
import LogLevel as HostLogLevel
import LogScope as HostLogScope
import PaywallOptions as HostPaywallOptions
import TransactionBackgroundView as HostTransactionBackgroundView

import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.config.options.PaywallOptions
import com.superwall.sdk.config.options.RestoreFailedAlert
import com.superwall.sdk.config.paywall.presentation.TransactionBackgroundView
import com.superwall.sdk.logger.LogLevel
import com.superwall.sdk.logger.LogScope
import java.util.EnumSet

/**
 * Maps a Host's SuperwallOptions (generated) to the SDK's SuperwallOptions
 */
fun HostOptions.toSdkOptions(): SuperwallOptions {
    val sdkOptions = SuperwallOptions()
    
    // Map paywalls options
    this.paywalls?.let { hostPaywalls ->
        sdkOptions.paywalls = hostPaywalls.toSdkPaywallOptions()
    }
    
    // Map network environment
    this.networkEnvironment?.let { hostNetworkEnvironment ->
        sdkOptions.networkEnvironment = when (hostNetworkEnvironment) {
            HostNetworkEnvironment.RELEASE -> SuperwallOptions.NetworkEnvironment.Release()
            HostNetworkEnvironment.RELEASE_CANDIDATE -> SuperwallOptions.NetworkEnvironment.ReleaseCandidate()
            HostNetworkEnvironment.DEVELOPER -> SuperwallOptions.NetworkEnvironment.Developer()
            else -> SuperwallOptions.NetworkEnvironment.Release()
        }
    }
    
    // Map other fields
    this.isExternalDataCollectionEnabled?.let { sdkOptions.isExternalDataCollectionEnabled = it }
    this.localeIdentifier?.let { sdkOptions.localeIdentifier = it }
    this.isGameControllerEnabled?.let { sdkOptions.isGameControllerEnabled = it }
    this.passIdentifiersToPlayStore?.let { sdkOptions.passIdentifiersToPlayStore = it }
    
    // Map logging
    this.logging?.let { hostLogging ->
        hostLogging.level?.let { hostLevel ->
            sdkOptions.logging.level = when (hostLevel) {
                HostLogLevel.DEBUG -> LogLevel.debug
                HostLogLevel.INFO -> LogLevel.info
                HostLogLevel.WARN -> LogLevel.warn
                HostLogLevel.ERROR -> LogLevel.error
                HostLogLevel.NONE -> LogLevel.none
                else -> LogLevel.warn
            }
        }
        
        hostLogging.scopes?.let { hostScopes ->
            val sdkScopes = EnumSet.noneOf(LogScope::class.java)
            
            hostScopes.forEach { hostScope ->
                when (hostScope) {
                    HostLogScope.LOCALIZATION_MANAGER -> sdkScopes.add(LogScope.localizationManager)
                    HostLogScope.BOUNCE_BUTTON -> sdkScopes.add(LogScope.bounceButton)
                    HostLogScope.CORE_DATA -> sdkScopes.add(LogScope.coreData)
                    HostLogScope.CONFIG_MANAGER -> sdkScopes.add(LogScope.configManager)
                    HostLogScope.IDENTITY_MANAGER -> sdkScopes.add(LogScope.identityManager)
                    HostLogScope.DEBUG_MANAGER -> sdkScopes.add(LogScope.debugManager)
                    HostLogScope.DEBUG_VIEW_CONTROLLER -> sdkScopes.add(LogScope.debugViewController)
                    HostLogScope.LOCALIZATION_VIEW_CONTROLLER -> sdkScopes.add(LogScope.localizationViewController)
                    HostLogScope.GAME_CONTROLLER_MANAGER -> sdkScopes.add(LogScope.gameControllerManager)
                    HostLogScope.DEVICE -> sdkScopes.add(LogScope.device)
                    HostLogScope.NETWORK -> sdkScopes.add(LogScope.network)
                    HostLogScope.PAYWALL_EVENTS -> sdkScopes.add(LogScope.paywallEvents)
                    HostLogScope.PRODUCTS_MANAGER -> sdkScopes.add(LogScope.productsManager)
                    HostLogScope.STORE_KIT_MANAGER -> sdkScopes.add(LogScope.storeKitManager)
                    HostLogScope.PLACEMENTS -> sdkScopes.add(LogScope.placements)
                    HostLogScope.RECEIPTS -> sdkScopes.add(LogScope.receipts)
                    HostLogScope.SUPERWALL_CORE -> sdkScopes.add(LogScope.superwallCore)
                    HostLogScope.PAYWALL_PRESENTATION -> sdkScopes.add(LogScope.paywallPresentation)
                    HostLogScope.TRANSACTIONS -> sdkScopes.add(LogScope.transactions)
                    HostLogScope.PAYWALL_VIEW_CONTROLLER -> sdkScopes.add(LogScope.paywallViewController)
                    HostLogScope.CACHE -> sdkScopes.add(LogScope.cache)
                    HostLogScope.ALL -> sdkScopes.add(LogScope.all)
                    else -> {}
                }
            }
            
            if (sdkScopes.isNotEmpty()) {
                sdkOptions.logging.scopes = sdkScopes
            }
        }
    }
    
    return sdkOptions
}

/**
 * Maps a Host's PaywallOptions to the SDK's PaywallOptions
 */
fun HostPaywallOptions.toSdkPaywallOptions(): PaywallOptions {
    val sdkPaywallOptions = PaywallOptions()
    
    // Map fields
    this.isHapticFeedbackEnabled?.let { sdkPaywallOptions.isHapticFeedbackEnabled = it }
    this.shouldShowPurchaseFailureAlert?.let { sdkPaywallOptions.shouldShowPurchaseFailureAlert = it }
    this.shouldPreload?.let { sdkPaywallOptions.shouldPreload = it }
    this.automaticallyDismiss?.let { sdkPaywallOptions.automaticallyDismiss = it }
    
    // Map restore failed options
    this.restoreFailed?.let { hostRestoreFailed ->
        val restoreFailedAlert = RestoreFailedAlert()
        
        hostRestoreFailed.title?.let { restoreFailedAlert.title = it }
        hostRestoreFailed.message?.let { restoreFailedAlert.message = it }
        hostRestoreFailed.closeButtonTitle?.let { restoreFailedAlert.closeButtonTitle = it }
        
        sdkPaywallOptions.restoreFailed = restoreFailedAlert
    }
    
    // Map transaction background view
    this.transactionBackgroundView?.let { hostTransactionBgView ->
        sdkPaywallOptions.transactionBackgroundView = when (hostTransactionBgView) {
            HostTransactionBackgroundView.SPINNER -> TransactionBackgroundView.SPINNER
            HostTransactionBackgroundView.NONE -> TransactionBackgroundView.NONE
            else -> TransactionBackgroundView.SPINNER
        }
    }
    
    return sdkPaywallOptions
}

/**
 * Utility class for mapping between PPaywallInfo and SDK's PaywallInfo
 */
class PaywallInfoMapper {
    companion object {
        /**
         * Converts a PPaywallInfo (generated from Pigeon) to SDK's PaywallInfo
         */
        fun fromPPaywallInfo(pPaywallInfo: PPaywallInfo): com.superwall.sdk.paywall.presentation.PaywallInfo {
            // Convert products to ProductItem list
            val products = pPaywallInfo.products?.map { productMap ->
                // Create ProductItem from product map - simplified for demonstration
                // In a real implementation, you would have a proper conversion logic here
                com.superwall.sdk.models.product.ProductItem(
                    id = (productMap["id"] as? String) ?: "",
                    name = (productMap["name"] as? String) ?: "",
                    fullProductId = (productMap["fullProductId"] as? String) ?: "",
                    rawPrice = (productMap["price"] as? Double) ?: 0.0,
                    price = (productMap["localizedPrice"] as? String) ?: "",
                    period = (productMap["period"] as? String) ?: "",
                    periodUnit = (productMap["periodUnit"] as? String) ?: "",
                    periodCount = (productMap["periodCount"] as? Int) ?: 0,
                    periodText = (productMap["periodText"] as? String) ?: "",
                    locale = (productMap["locale"] as? String) ?: "",
                    isFamilyShareable = (productMap["isFamilyShareable"] as? Boolean) ?: false
                )
            } ?: emptyList()

            // Create a basic PaywallURL
            val paywallUrl = com.superwall.sdk.models.paywall.PaywallURL(pPaywallInfo.url ?: "")
            
            // Create experiment if experimentBridgeId exists
            val experiment = pPaywallInfo.experimentBridgeId?.let {
                // In a real implementation, you'd retrieve the experiment from a cache or repository
                // This is a simplified version
                com.superwall.sdk.models.triggers.Experiment(
                    id = it,
                    groupId = "",
                    variant = com.superwall.sdk.models.triggers.Variant(
                        id = "",
                        type = com.superwall.sdk.models.triggers.VariantType.TREATMENT,
                        paywallId = pPaywallInfo.identifier
                    )
                )
            }

            // Convert featureGatingBehavior
            val featureGatingBehavior = when (pPaywallInfo.featureGatingBehavior?.get("type") as? String) {
                "nonGated" -> com.superwall.sdk.models.config.FeatureGatingBehavior.NonGated
                "gated" -> com.superwall.sdk.models.config.FeatureGatingBehavior.Gated
                else -> com.superwall.sdk.models.config.FeatureGatingBehavior.NonGated
            }

            // Convert closeReason
            val closeReason = when (pPaywallInfo.closeReason?.get("type") as? String) {
                "none" -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.None
                "user" -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.User
                "webView" -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.WebView
                else -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.None
            }

            // Convert localNotifications, computedPropertyRequests, and surveys
            // These would need proper mapping in a real implementation
            val localNotifications = pPaywallInfo.localNotifications?.map {
                com.superwall.sdk.models.paywall.LocalNotification(
                    title = (it["title"] as? String) ?: "",
                    body = (it["body"] as? String) ?: "",
                    delay = (it["delay"] as? Double) ?: 0.0
                )
            } ?: emptyList()

            val computedPropertyRequests = pPaywallInfo.computedPropertyRequests?.map {
                com.superwall.sdk.models.config.ComputedPropertyRequest(
                    eventName = (it["eventName"] as? String) ?: "",
                    parameters = (it["parameters"] as? Map<String, Any>) ?: emptyMap(),
                    assignments = emptyList() // This would need proper conversion
                )
            } ?: emptyList()

            val surveys = pPaywallInfo.surveys?.map {
                com.superwall.sdk.config.models.Survey(
                    id = (it["id"] as? String) ?: "",
                    title = (it["title"] as? String) ?: "",
                    message = (it["message"] as? String) ?: "",
                    options = ((it["options"] as? List<Map<String, Any>>)?.map { option ->
                        com.superwall.sdk.config.models.SurveyOption(
                            id = (option["id"] as? String) ?: "",
                            title = (option["title"] as? String) ?: ""
                        )
                    } ?: emptyList())
                )
            } ?: emptyList()

            // For presentation info, create a basic one
            val presentation = com.superwall.sdk.models.paywall.PaywallPresentationInfo(
                com.superwall.sdk.models.paywall.PaywallPresentationStyle.NONE,
                0
            )

            // Return PaywallInfo with available data
            return com.superwall.sdk.paywall.presentation.PaywallInfo(
                databaseId = pPaywallInfo.identifier ?: "",
                identifier = pPaywallInfo.identifier ?: "",
                name = pPaywallInfo.name ?: "",
                url = paywallUrl,
                experiment = experiment,
                products = products,
                productIds = pPaywallInfo.productIds?.toList() ?: emptyList(),
                presentedByEventWithName = pPaywallInfo.presentedByPlacementWithName,
                presentedByEventWithId = pPaywallInfo.presentedByPlacementWithId,
                presentedByEventAt = pPaywallInfo.presentedByPlacementAt,
                presentedBy = pPaywallInfo.presentedBy ?: "programmatically",
                presentationSourceType = pPaywallInfo.presentationSourceType,
                responseLoadStartTime = pPaywallInfo.responseLoadStartTime,
                responseLoadCompleteTime = pPaywallInfo.responseLoadCompleteTime,
                responseLoadFailTime = pPaywallInfo.responseLoadFailTime,
                responseLoadDuration = pPaywallInfo.responseLoadDuration,
                webViewLoadStartTime = pPaywallInfo.webViewLoadStartTime,
                webViewLoadCompleteTime = pPaywallInfo.webViewLoadCompleteTime,
                webViewLoadFailTime = pPaywallInfo.webViewLoadFailTime,
                webViewLoadDuration = pPaywallInfo.webViewLoadDuration,
                productsLoadStartTime = pPaywallInfo.productsLoadStartTime,
                productsLoadCompleteTime = pPaywallInfo.productsLoadCompleteTime,
                productsLoadFailTime = pPaywallInfo.productsLoadFailTime,
                shimmerLoadStartTime = null,
                shimmerLoadCompleteTime = null,
                productsLoadDuration = pPaywallInfo.productsLoadDuration,
                paywalljsVersion = pPaywallInfo.paywalljsVersion,
                isFreeTrialAvailable = pPaywallInfo.isFreeTrialAvailable ?: false,
                featureGatingBehavior = featureGatingBehavior,
                closeReason = closeReason,
                localNotifications = localNotifications,
                computedPropertyRequests = computedPropertyRequests,
                surveys = surveys,
                presentation = presentation,
                buildId = "", // Not available in PPaywallInfo
                cacheKey = "", // Not available in PPaywallInfo
                isScrollEnabled = true // Default value, not available in PPaywallInfo
            )
        }

        /**
         * Converts SDK's PaywallInfo to PPaywallInfo
         */
        fun toPPaywallInfo(paywallInfo: com.superwall.sdk.paywall.presentation.PaywallInfo): PPaywallInfo {
            val pPaywallInfo = PPaywallInfo()
            
            // Map basic properties
            pPaywallInfo.identifier = paywallInfo.identifier
            pPaywallInfo.name = paywallInfo.name
            pPaywallInfo.url = paywallInfo.url.toString()
            
            // Map experiment if available
            paywallInfo.experiment?.let {
                pPaywallInfo.experimentBridgeId = it.id
            }
            
            // Map product IDs
            pPaywallInfo.productIds = paywallInfo.productIds
            
            // Map products - convert ProductItem objects to Maps
            pPaywallInfo.products = paywallInfo.products.map { product ->
                mapOf(
                    "id" to product.id,
                    "name" to product.name,
                    "fullProductId" to product.fullProductId,
                    "price" to product.rawPrice,
                    "localizedPrice" to product.price,
                    "period" to product.period,
                    "periodUnit" to product.periodUnit,
                    "periodCount" to product.periodCount,
                    "periodText" to product.periodText,
                    "locale" to product.locale,
                    "isFamilyShareable" to product.isFamilyShareable
                ) as Map<String, Object>
            }
            
            // Map presentation-related properties
            pPaywallInfo.presentedByPlacementWithName = paywallInfo.presentedByEventWithName
            pPaywallInfo.presentedByPlacementWithId = paywallInfo.presentedByEventWithId
            pPaywallInfo.presentedByPlacementAt = paywallInfo.presentedByEventAt
            pPaywallInfo.presentedBy = paywallInfo.presentedBy
            pPaywallInfo.presentationSourceType = paywallInfo.presentationSourceType
            
            // Map loading times
            pPaywallInfo.responseLoadStartTime = paywallInfo.responseLoadStartTime
            pPaywallInfo.responseLoadCompleteTime = paywallInfo.responseLoadCompleteTime
            pPaywallInfo.responseLoadFailTime = paywallInfo.responseLoadFailTime
            pPaywallInfo.responseLoadDuration = paywallInfo.responseLoadDuration
            pPaywallInfo.webViewLoadStartTime = paywallInfo.webViewLoadStartTime
            pPaywallInfo.webViewLoadCompleteTime = paywallInfo.webViewLoadCompleteTime
            pPaywallInfo.webViewLoadFailTime = paywallInfo.webViewLoadFailTime
            pPaywallInfo.webViewLoadDuration = paywallInfo.webViewLoadDuration
            pPaywallInfo.productsLoadStartTime = paywallInfo.productsLoadStartTime
            pPaywallInfo.productsLoadCompleteTime = paywallInfo.productsLoadCompleteTime
            pPaywallInfo.productsLoadFailTime = paywallInfo.productsLoadFailTime
            pPaywallInfo.productsLoadDuration = paywallInfo.productsLoadDuration
            
            // Map other properties
            pPaywallInfo.paywalljsVersion = paywallInfo.paywalljsVersion
            pPaywallInfo.isFreeTrialAvailable = paywallInfo.isFreeTrialAvailable
            
            // Map feature gating behavior
            pPaywallInfo.featureGatingBehavior = when (paywallInfo.featureGatingBehavior) {
                is com.superwall.sdk.models.config.FeatureGatingBehavior.Gated -> mapOf("type" to "gated") as Map<String, Object>
                else -> mapOf("type" to "nonGated") as Map<String, Object>
            }
            
            // Map close reason
            pPaywallInfo.closeReason = when (paywallInfo.closeReason) {
                is com.superwall.sdk.paywall.presentation.PaywallCloseReason.User -> mapOf("type" to "user") as Map<String, Object>
                is com.superwall.sdk.paywall.presentation.PaywallCloseReason.WebView -> mapOf("type" to "webView") as Map<String, Object>
                else -> mapOf("type" to "none") as Map<String, Object>
            }
            
            // Map local notifications
            pPaywallInfo.localNotifications = paywallInfo.localNotifications.map { notification ->
                mapOf(
                    "title" to notification.title,
                    "body" to notification.body,
                    "delay" to notification.delay
                ) as Map<String, Object>
            }
            
            // Map computed property requests
            pPaywallInfo.computedPropertyRequests = paywallInfo.computedPropertyRequests.map { request ->
                mapOf(
                    "eventName" to request.eventName,
                    "parameters" to request.parameters
                ) as Map<String, Object>
            }
            
            // Map surveys
            pPaywallInfo.surveys = paywallInfo.surveys.map { survey ->
                mapOf(
                    "id" to survey.id,
                    "title" to survey.title,
                    "message" to survey.message,
                    "options" to survey.options.map { option ->
                        mapOf(
                            "id" to option.id,
                            "title" to option.title
                        )
                    }
                ) as Map<String, Object>
            }
            
            return pPaywallInfo
        }
    }
} 