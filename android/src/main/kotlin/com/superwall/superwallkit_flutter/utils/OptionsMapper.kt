package com.superwall.superwallkit_flutter.utils

import PComputedPropertyRequest
import PEntitlement
import PEntitlementType
import PExperiment
import PLocalNotification
import PPaywallInfo
import PPaywallOptions
import PProduct
import PSuperwallOptions
import PSurvey
import PSurveyOption
import PVariant
import com.superwall.sdk.billing.DecomposedProductIds
import com.superwall.sdk.config.options.PaywallOptions
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.logger.LogLevel
import com.superwall.sdk.logger.LogScope
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.product.Offer
import com.superwall.sdk.models.product.PlayStoreProduct
import com.superwall.sdk.models.product.ProductItem
import com.superwall.sdk.models.triggers.Experiment
import com.superwall.sdk.store.abstractions.product.OfferType
import java.util.EnumSet

/**
 * Maps a Host's SuperwallOptions (generated) to the SDK's SuperwallOptions
 */
fun PSuperwallOptions.toSdkOptions(): SuperwallOptions {
    val sdkOptions = SuperwallOptions()

    this.paywalls?.let { hostPaywalls ->
        sdkOptions.paywalls = hostPaywalls.toSdkPaywallOptions()
    }

    this.networkEnvironment?.let { hostNetworkEnvironment ->
        sdkOptions.networkEnvironment =
            when (hostNetworkEnvironment) {
                PNetworkEnvironment.RELEASE -> SuperwallOptions.NetworkEnvironment.Release()
                PNetworkEnvironment.RELEASE_CANDIDATE -> SuperwallOptions.NetworkEnvironment.ReleaseCandidate()
                PNetworkEnvironment.DEVELOPER -> SuperwallOptions.NetworkEnvironment.Developer()
                else -> SuperwallOptions.NetworkEnvironment.Release()
            }
    }

    this.isExternalDataCollectionEnabled?.let { sdkOptions.isExternalDataCollectionEnabled = it }
    this.localeIdentifier?.let { sdkOptions.localeIdentifier = it }
    this.isGameControllerEnabled?.let { sdkOptions.isGameControllerEnabled = it }
    this.passIdentifiersToPlayStore?.let { sdkOptions.passIdentifiersToPlayStore = it }

    this.logging?.let { hostLogging ->
        hostLogging.level?.let { hostLevel ->
            sdkOptions.logging.level =
                when (hostLevel) {
                    PLogLevel.DEBUG -> LogLevel.debug
                    PLogLevel.INFO -> LogLevel.info
                    PLogLevel.WARN -> LogLevel.warn
                    PLogLevel.ERROR -> LogLevel.error
                    PLogLevel.NONE -> LogLevel.none
                    else -> LogLevel.warn
                }
        }

        hostLogging.scopes?.let { hostScopes ->
            val sdkScopes = EnumSet.noneOf(LogScope::class.java)

            hostScopes.forEach { hostScope ->
                when (hostScope) {
                    PLogScope.LOCALIZATION_MANAGER -> sdkScopes.add(LogScope.localizationManager)
                    PLogScope.BOUNCE_BUTTON -> sdkScopes.add(LogScope.bounceButton)
                    PLogScope.CORE_DATA -> sdkScopes.add(LogScope.coreData)
                    PLogScope.CONFIG_MANAGER -> sdkScopes.add(LogScope.configManager)
                    PLogScope.IDENTITY_MANAGER -> sdkScopes.add(LogScope.identityManager)
                    PLogScope.DEBUG_MANAGER -> sdkScopes.add(LogScope.debugManager)
                    PLogScope.DEBUG_VIEW_CONTROLLER -> sdkScopes.add(LogScope.debugView)
                    PLogScope.LOCALIZATION_VIEW_CONTROLLER -> sdkScopes.add(LogScope.localizationView)
                    PLogScope.GAME_CONTROLLER_MANAGER -> sdkScopes.add(LogScope.gameControllerManager)
                    PLogScope.DEVICE -> sdkScopes.add(LogScope.device)
                    PLogScope.NETWORK -> sdkScopes.add(LogScope.network)
                    PLogScope.PAYWALL_EVENTS -> sdkScopes.add(LogScope.paywallEvents)
                    PLogScope.PRODUCTS_MANAGER -> sdkScopes.add(LogScope.productsManager)
                    PLogScope.STORE_KIT_MANAGER -> sdkScopes.add(LogScope.storeKitManager)
                    PLogScope.PLACEMENTS -> sdkScopes.add(LogScope.placements)
                    PLogScope.RECEIPTS -> sdkScopes.add(LogScope.receipts)
                    PLogScope.SUPERWALL_CORE -> sdkScopes.add(LogScope.superwallCore)
                    PLogScope.PAYWALL_PRESENTATION -> sdkScopes.add(LogScope.paywallPresentation)
                    PLogScope.TRANSACTIONS -> sdkScopes.add(LogScope.transactions)
                    PLogScope.PAYWALL_VIEW_CONTROLLER -> sdkScopes.add(LogScope.paywallView)
                    PLogScope.CACHE -> sdkScopes.add(LogScope.cache)
                    PLogScope.ALL -> sdkScopes.add(LogScope.all)
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
fun PPaywallOptions.toSdkPaywallOptions(): PaywallOptions {
    val sdkPaywallOptions = PaywallOptions()

    this.isHapticFeedbackEnabled?.let { sdkPaywallOptions.isHapticFeedbackEnabled = it }
    this.shouldShowPurchaseFailureAlert?.let {
        sdkPaywallOptions.shouldShowPurchaseFailureAlert = it
    }
    this.shouldPreload?.let { sdkPaywallOptions.shouldPreload = it }
    this.automaticallyDismiss?.let { sdkPaywallOptions.automaticallyDismiss = it }

    this.restoreFailed?.let { hostRestoreFailed ->
        val restoreFailedAlert = sdkPaywallOptions.restoreFailed

        hostRestoreFailed.title?.let { restoreFailedAlert.title = it }
        hostRestoreFailed.message?.let { restoreFailedAlert.message = it }
        hostRestoreFailed.closeButtonTitle?.let { restoreFailedAlert.closeButtonTitle = it }

        sdkPaywallOptions.restoreFailed = restoreFailedAlert
    }

    this.transactionBackgroundView?.let { hostTransactionBgView ->
        sdkPaywallOptions.transactionBackgroundView =
            when (hostTransactionBgView) {
                PTransactionBackgroundView.SPINNER -> PaywallOptions.TransactionBackgroundView.SPINNER
                else -> PaywallOptions.TransactionBackgroundView.SPINNER
            }
    }

    this.overrideProductsByName?.let { hostOverrides ->
        sdkPaywallOptions.overrideProductsByName = hostOverrides
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
            val products =
                pPaywallInfo.products?.map { product ->
                    val decomposedProductIds = DecomposedProductIds.from(product.id ?: "")
                    val offer = decomposedProductIds.offerType
                    ProductItem(
                        compositeId = product.id ?: "",
                        name = product.name ?: "",
                        entitlements =
                            product.entitlements
                                ?.map {
                                    Entitlement(it.id!!)
                                }?.toSet() ?: emptySet(),
                        type =
                            ProductItem.StoreProductType.PlayStore(
                                PlayStoreProduct(
                                    productIdentifier = decomposedProductIds.subscriptionId,
                                    basePlanIdentifier = decomposedProductIds.basePlanId,
                                    offer =
                                        when {
                                            offer is OfferType.Offer ->
                                                Offer.Specified(
                                                    offerIdentifier = decomposedProductIds.offerType.id!!,
                                                )
                                            else -> Offer.Automatic()
                                        },
                                ),
                            ),
                    )
                } ?: emptyList()

            val paywallUrl =
                com.superwall.sdk.models.paywall
                    .PaywallURL(pPaywallInfo.url ?: "")

            val experiment =
                pPaywallInfo.experiment?.let {
                    Experiment(
                        id = it.id,
                        groupId = it.groupId,
                        variant =
                            Experiment.Variant(
                                id = it.variant.id,
                                type =
                                    when (it.variant.type) {
                                        PVariantType.TREATMENT -> Experiment.Variant.VariantType.TREATMENT
                                        PVariantType.HOLDOUT -> Experiment.Variant.VariantType.HOLDOUT
                                    },
                                paywallId = it.variant.paywallId,
                            ),
                    )
                }

            val featureGatingBehavior =
                when (pPaywallInfo.featureGatingBehavior) {
                    PFeatureGatingBehavior.GATED -> com.superwall.sdk.models.config.FeatureGatingBehavior.Gated
                    PFeatureGatingBehavior.NON_GATED -> com.superwall.sdk.models.config.FeatureGatingBehavior.NonGated
                    else -> com.superwall.sdk.models.config.FeatureGatingBehavior.NonGated
                }

            val closeReason =
                when (pPaywallInfo.closeReason) {
                    PPaywallCloseReason.SYSTEM_LOGIC -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.SystemLogic
                    PPaywallCloseReason.FOR_NEXT_PAYWALL -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.ForNextPaywall
                    PPaywallCloseReason.WEB_VIEW_FAILED_TO_LOAD -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.WebViewFailedToLoad
                    PPaywallCloseReason.MANUAL_CLOSE -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.ManualClose
                    PPaywallCloseReason.NONE -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.None
                    else -> com.superwall.sdk.paywall.presentation.PaywallCloseReason.None
                }

            val localNotifications =
                pPaywallInfo.localNotifications?.map { notification ->
                    com.superwall.sdk.models.paywall.LocalNotification(
                        id = notification.id.toInt(),
                        type =
                            when (notification.type) {
                                PLocalNotificationType.TRIAL_STARTED -> com.superwall.sdk.models.paywall.LocalNotificationType.TrialStarted
                                PLocalNotificationType.UNSUPPORTED -> com.superwall.sdk.models.paywall.LocalNotificationType.Unsupported
                                else -> com.superwall.sdk.models.paywall.LocalNotificationType.Unsupported
                            },
                        title = notification.title,
                        subtitle = notification.subtitle,
                        body = notification.body,
                        delay = notification.delay.toLong(),
                    )
                } ?: emptyList()

            val computedPropertyRequests =
                pPaywallInfo.computedPropertyRequests?.map { request ->
                    com.superwall.sdk.models.config.ComputedPropertyRequest(
                        type =
                            when (request.type) {
                                PComputedPropertyRequestType.MINUTES_SINCE -> com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.MINUTES_SINCE
                                PComputedPropertyRequestType.HOURS_SINCE -> com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.HOURS_SINCE
                                PComputedPropertyRequestType.DAYS_SINCE -> com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.DAYS_SINCE
                                PComputedPropertyRequestType.MONTHS_SINCE -> com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.MONTHS_SINCE
                                PComputedPropertyRequestType.YEARS_SINCE -> com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.YEARS_SINCE
                                else -> com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.DAYS_SINCE
                            },
                        eventName = request.eventName,
                    )
                } ?: emptyList()

            val surveys =
                pPaywallInfo.surveys?.map { survey ->
                    com.superwall.sdk.config.models.Survey(
                        id = survey.id,
                        assignmentKey = survey.assignmentKey,
                        title = survey.title,
                        message = survey.message,
                        options =
                            survey.options.map { option ->
                                com.superwall.sdk.config.models.SurveyOption(
                                    id = option.id ?: "",
                                    title = option.text ?: "",
                                )
                            },
                        presentationCondition =
                            when (survey.presentationCondition) {
                                PSurveyShowCondition.ON_MANUAL_CLOSE -> com.superwall.sdk.config.models.SurveyShowCondition.ON_MANUAL_CLOSE
                                PSurveyShowCondition.ON_PURCHASE -> com.superwall.sdk.config.models.SurveyShowCondition.ON_PURCHASE
                                else -> com.superwall.sdk.config.models.SurveyShowCondition.ON_MANUAL_CLOSE
                            },
                        presentationProbability = survey.presentationProbability,
                        includeOtherOption = survey.includeOtherOption,
                        includeCloseOption = survey.includeCloseOption,
                    )
                } ?: emptyList()

            val presentation =
                com.superwall.sdk.models.paywall.PaywallPresentationInfo(
                    com.superwall.sdk.models.paywall.PaywallPresentationStyle.NONE,
                    0,
                )

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
                buildId = "",
                cacheKey = "",
                isScrollEnabled = true,
            )
        }

        /**
         * Converts SDK's PaywallInfo to PPaywallInfo
         */
        fun toPPaywallInfo(paywallInfo: com.superwall.sdk.paywall.presentation.PaywallInfo): PPaywallInfo {
            val experiment =
                paywallInfo.experiment?.let {
                    PExperiment(
                        id = it.id,
                        groupId = it.groupId,
                        variant =
                            PVariant(
                                id = it.variant.id,
                                type =
                                    when (it.variant.type) {
                                        Experiment.Variant.VariantType.TREATMENT -> PVariantType.TREATMENT
                                        Experiment.Variant.VariantType.HOLDOUT -> PVariantType.HOLDOUT
                                    },
                                paywallId = it.variant.paywallId,
                            ),
                    )
                }

            val products =
                paywallInfo.products.map { product ->
                    PProduct(
                        id = product.fullProductId,
                        name = product.name,
                        entitlements =
                            product.entitlements.map {
                                PEntitlement(
                                    id = it.id,
                                    type = PEntitlementType.SERVICE_LEVEL,
                                    isActive = true,
                                    productIds = emptyList()
                                )
                            },
                    )
                }

            val featureGatingBehavior =
                when (paywallInfo.featureGatingBehavior) {
                    is com.superwall.sdk.models.config.FeatureGatingBehavior.Gated -> PFeatureGatingBehavior.GATED
                    else -> PFeatureGatingBehavior.NON_GATED
                }

            val closeReason =
                when (paywallInfo.closeReason) {
                    is com.superwall.sdk.paywall.presentation.PaywallCloseReason.SystemLogic -> PPaywallCloseReason.SYSTEM_LOGIC
                    is com.superwall.sdk.paywall.presentation.PaywallCloseReason.ForNextPaywall -> PPaywallCloseReason.FOR_NEXT_PAYWALL
                    is com.superwall.sdk.paywall.presentation.PaywallCloseReason.WebViewFailedToLoad -> PPaywallCloseReason.WEB_VIEW_FAILED_TO_LOAD
                    is com.superwall.sdk.paywall.presentation.PaywallCloseReason.ManualClose -> PPaywallCloseReason.MANUAL_CLOSE
                    else -> PPaywallCloseReason.NONE
                }

            val localNotifications =
                paywallInfo.localNotifications.map { notification ->
                    PLocalNotification(
                        id = notification.id.toLong(),
                        type =
                            when (notification.type) {
                                is com.superwall.sdk.models.paywall.LocalNotificationType.TrialStarted -> PLocalNotificationType.TRIAL_STARTED
                                else -> PLocalNotificationType.UNSUPPORTED
                            },
                        title = notification.title,
                        subtitle = notification.subtitle,
                        body = notification.body,
                        delay = notification.delay,
                    )
                }

            val computedPropertyRequests =
                paywallInfo.computedPropertyRequests.map { request ->
                    val pType =
                        when (request.type) {
                            com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.MINUTES_SINCE -> PComputedPropertyRequestType.MINUTES_SINCE
                            com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.HOURS_SINCE -> PComputedPropertyRequestType.HOURS_SINCE
                            com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.DAYS_SINCE -> PComputedPropertyRequestType.DAYS_SINCE
                            com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.MONTHS_SINCE -> PComputedPropertyRequestType.MONTHS_SINCE
                            com.superwall.sdk.models.config.ComputedPropertyRequest.ComputedPropertyRequestType.YEARS_SINCE -> PComputedPropertyRequestType.YEARS_SINCE
                            else -> PComputedPropertyRequestType.DAYS_SINCE
                        }
                    PComputedPropertyRequest(
                        type = pType,
                        eventName = request.eventName,
                    )
                }

            val surveys =
                paywallInfo.surveys.map { survey ->
                    val pSurveyOptions =
                        survey.options.map { option ->
                            PSurveyOption(
                                id = option.id,
                                text = option.title,
                            )
                        }
                    PSurvey(
                        id = survey.id,
                        assignmentKey = survey.assignmentKey,
                        title = survey.title,
                        message = survey.message,
                        options = pSurveyOptions,
                        presentationCondition =
                            when (survey.presentationCondition) {
                                com.superwall.sdk.config.models.SurveyShowCondition.ON_MANUAL_CLOSE -> PSurveyShowCondition.ON_MANUAL_CLOSE
                                com.superwall.sdk.config.models.SurveyShowCondition.ON_PURCHASE -> PSurveyShowCondition.ON_PURCHASE
                                else -> PSurveyShowCondition.ON_MANUAL_CLOSE
                            },
                        presentationProbability = survey.presentationProbability,
                        includeOtherOption = survey.includeOtherOption,
                        includeCloseOption = survey.includeCloseOption,
                    )
                }

            return PPaywallInfo(
                identifier = paywallInfo.identifier,
                name = paywallInfo.name,
                experiment = experiment,
                productIds = paywallInfo.productIds,
                products = products,
                url = paywallInfo.url.toString(),
                presentedByPlacementWithName = paywallInfo.presentedByEventWithName,
                presentedByPlacementWithId = paywallInfo.presentedByEventWithId,
                presentedByPlacementAt = paywallInfo.presentedByEventAt,
                presentedBy = paywallInfo.presentedBy,
                presentationSourceType = paywallInfo.presentationSourceType,
                responseLoadStartTime = paywallInfo.responseLoadStartTime,
                responseLoadCompleteTime = paywallInfo.responseLoadCompleteTime,
                responseLoadFailTime = paywallInfo.responseLoadFailTime,
                responseLoadDuration = paywallInfo.responseLoadDuration,
                webViewLoadStartTime = paywallInfo.webViewLoadStartTime,
                webViewLoadCompleteTime = paywallInfo.webViewLoadCompleteTime,
                webViewLoadFailTime = paywallInfo.webViewLoadFailTime,
                webViewLoadDuration = paywallInfo.webViewLoadDuration,
                productsLoadStartTime = paywallInfo.productsLoadStartTime,
                productsLoadCompleteTime = paywallInfo.productsLoadCompleteTime,
                productsLoadFailTime = paywallInfo.productsLoadFailTime,
                productsLoadDuration = paywallInfo.productsLoadDuration,
                paywalljsVersion = paywallInfo.paywalljsVersion,
                isFreeTrialAvailable = paywallInfo.isFreeTrialAvailable,
                featureGatingBehavior = featureGatingBehavior,
                closeReason = closeReason,
                localNotifications = localNotifications,
                computedPropertyRequests = computedPropertyRequests,
                surveys = surveys,
            )
        }
    }
} 
