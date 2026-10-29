package com.superwall.superwallkit_flutter

import PActive
import PConfigurationStatus
import PConfigureCompletionGenerated
import PConfigureCompletionHost
import PConfirmedAssignment
import FlutterError
import PAdConsent
import PCustomerCenterConfiguration
import PCustomerCenterDelegateGenerated
import PCustomerCenterDelegateHost
import PCustomerInfo
import PEntitlement
import PExperiment
import PEntitlements
import PFeatureHandlerGenerated
import PFeatureHandlerHost
import PIdentityOptions
import PIntegrationAttribute
import PInactive
import PPaywallInfo
import PPaywallPresentationHandlerGenerated
import PPaywallPresentationHandlerHost
import PPresentationResult
import PPlacementNotFoundPresentationResult
import PNoAudienceMatchPresentationResult
import PPaywallPresentationResult
import PHoldoutPresentationResult
import PPaywallNotAvailablePresentationResult
import POnBackPressedGenerated
import POwnedInAppPurchase
import PPurchaseCancelled
import PPurchaseControllerGenerated
import PPurchaseControllerHost
import PPurchaseFailed
import PPurchasePending
import PPurchasePurchased
import PPurchaseResult
import PRestorationFailed
import PRestorationRestored
import PRestorationResult
import PSubscriptionStatus
import PSuperwallDelegateGenerated
import PSuperwallHostApi
import PSuperwallHostApi.Companion.setUp
import PStoreProduct
import PSuperwallOptions
import PUnknown
import PVariant
import PVariantType
import PigeonEventSink
import StreamSubscriptionStatusStreamHandler
import StreamCustomerInfoStreamHandler
import android.app.Activity
import android.app.Application
import com.superwall.sdk.Superwall
import com.superwall.sdk.models.attribution.AttributionProvider
import com.superwall.sdk.billing.BillingError
import com.superwall.sdk.delegate.PurchaseResult
import com.superwall.sdk.config.models.ConfigurationStatus
import com.superwall.sdk.identity.IdentityOptions
import com.superwall.sdk.identity.identify
import com.superwall.sdk.identity.setUserAttributes
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.models.triggers.Experiment
import com.superwall.sdk.store.abstractions.product.StoreProduct
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.superwallkit_flutter.json.JsonExtensions
import com.superwall.superwallkit_flutter.utils.toSdkOptions
import com.superwall.superwallkit_flutter.utils.toSdk
import com.superwall.superwallkit_flutter.utils.toPigeon
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import logLevelFromJson
import pigeonify
import toJson
import androidx.core.net.toUri
import com.superwall.sdk.paywall.presentation.register
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper
import com.superwall.superwallkit_flutter.utils.CustomerCenterMapper.toSdk
import com.superwall.superwallkit_flutter.utils.CustomerInfoMapper
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.delegate.RestorationResult
import com.superwall.sdk.logger.LogLevel
import com.superwall.sdk.misc.ActivityProvider
import com.superwall.sdk.paywall.presentation.get_presentation_result.getPresentationResult
import com.superwall.sdk.paywall.presentation.result.PresentationResult
import com.superwall.superwallkit_flutter.utils.SubscriptionStatusMapper.fromPigeon
import com.superwall.superwallkit_flutter.utils.SubscriptionStatusMapper.toPigeon
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.flow.collectLatest

class SuperwallHost(
    val context: () -> Application,
    val binaryMessenger: () -> BinaryMessenger
) : PSuperwallHostApi, StreamSubscriptionStatusStreamHandler() {

    private val mainScope = CoroutineScope(Dispatchers.Main)
    private val ioScope = CoroutineScope(Dispatchers.IO)
    private var latestStreamJob: Job? = null
    private val inAppPurchaseQuery = InAppPurchaseQuery(context)
    private val customerInfoStreamHandler = CustomerInfoStreamHandlerImpl()
    private var delegateHost: SuperwallDelegateHost? = null

    init {
        setUp(binaryMessenger = binaryMessenger(), this)
        register(binaryMessenger(), this)
        StreamCustomerInfoStreamHandler.register(binaryMessenger(), customerInfoStreamHandler)
    }

    fun dispose() {
        customerInfoStreamHandler.dispose()
        mainScope.cancel()
        ioScope.cancel()
        delegateHost?.let {
            val sdk = runCatching { Superwall.instance }.getOrNull()
            if (sdk != null && sdk.delegate === it) sdk.delegate = null
            it.dispose()
        }
        delegateHost = null
        setUp(binaryMessenger = binaryMessenger(), api = null)
        EventChannel(binaryMessenger(), "dev.flutter.pigeon.superwallkit_flutter.SuperwallEventStreams.streamCustomerInfo")
            .setStreamHandler(null)
        EventChannel(binaryMessenger(), "dev.flutter.pigeon.superwallkit_flutter.SuperwallEventStreams.streamSubscriptionStatus")
            .setStreamHandler(null)
    }
    override fun configure(
        apiKey: String,
        purchaseController: PPurchaseControllerHost?,
        options: PSuperwallOptions?,
        completion: PConfigureCompletionHost?,
        callback: (Result<Unit>) -> Unit,
    ) {
        val sdkOptions = (options?.toSdkOptions() ?: SuperwallOptions()).apply {
            logging.level = LogLevel.debug

            // Set up onBackPressed callback if provided
            options?.paywalls?.onBackPressedHost?.let {
                val onBackPressedHost = OnBackPressedHost {
                    POnBackPressedGenerated(binaryMessenger())
                }
                paywalls.onBackPressed = onBackPressedHost.onBackPressed
            }
        }
        Superwall.configure(
            applicationContext = context().applicationContext as Application,
            apiKey = apiKey,
            options = sdkOptions,
            purchaseController = if (purchaseController != null) {
                PurchaseControllerHost { PPurchaseControllerGenerated(binaryMessenger()) }
            } else null,
            activityProvider = object : ActivityProvider {
                override fun getCurrentActivity(): Activity? {
                    return SuperwallkitFlutterPlugin.currentActivity
                }
            },
            completion = if (completion != null) {
                { result: Result<Unit> ->
                    PConfigureCompletionGenerated(binaryMessenger()).onConfigureCompleted(
                        result.isSuccess,
                        {})
                }
            } else null
        )
    }

    override fun reset() {
        Superwall.instance.reset()
    }

    override fun setDelegate(hasDelegate: Boolean) {
        delegateHost?.dispose()
        delegateHost = if (hasDelegate) {
            SuperwallDelegateHost { PSuperwallDelegateGenerated(binaryMessenger()) }
        } else null
        Superwall.instance.delegate = delegateHost
    }

    override fun confirmAllAssignments(callback: (Result<List<PConfirmedAssignment>>) -> Unit) {
        ioScope.launch {
            callback(Superwall.instance.confirmAllAssignments().map {
                it.map {
                    PConfirmedAssignment(it.experimentId, it.variant.let {
                        PVariant(
                            id = it.id, paywallId = it.paywallId, type =
                                when (it.type) {
                                    Experiment.Variant.VariantType.TREATMENT -> PVariantType.TREATMENT
                                    Experiment.Variant.VariantType.HOLDOUT -> PVariantType.HOLDOUT
                                }
                        )
                    })
                }
            })
        }
    }

    override fun getLogLevel(): String {
        return Superwall.instance.logLevel.toJson()
    }

    override fun setLogLevel(logLevel: String) {
        JsonExtensions.logLevelFromJson(logLevel)?.let {
            Superwall.instance.logLevel = it
        }
    }

    override fun getUserAttributes(): Map<String, Any> {
        return Superwall.instance.userAttributes
    }

    override fun setUserAttributes(userAttributes: Map<String, Any>) {
        Superwall.instance.setUserAttributes(userAttributes)
    }

    override fun setIntegrationAttribute(attribute: PIntegrationAttribute, value: String?) {
        setIntegrationAttributes(mapOf(attribute to value))
    }

    override fun setIntegrationAttributes(attributes: Map<PIntegrationAttribute, String?>) {
        val (providerAttributes, userAttributes) =
            attributes.entries.partition { it.key.toAttributionProvider() != null }

        if (userAttributes.isNotEmpty()) {
            Superwall.instance.setUserAttributes(
                userAttributes.associate { it.key.toAttributeKey() to it.value }
            )
        }

        if (providerAttributes.isNotEmpty()) {
            // The native call replaces every integration attribute, so merge into the current ones.
            val merged = Superwall.instance.integrationAttributes
                .mapNotNull { (rawName, value) ->
                    AttributionProvider.values().firstOrNull { it.rawName == rawName }
                        ?.let { it to value }
                }
                .toMap()
                .toMutableMap()
            providerAttributes.forEach { (attribute, value) ->
                val provider = attribute.toAttributionProvider() ?: return@forEach
                if (value == null) merged.remove(provider) else merged[provider] = value
            }
            Superwall.instance.setIntegrationAttributes(merged)
        }
    }

    override fun getDeviceAttributes(callback: (Result<Map<String, Any>>) -> Unit) {
        ioScope.launch {
            val unfiltered: Map<String, Any?> = Superwall.instance.deviceAttributes()
            val attributes: Map<String, Any> = unfiltered.filterNot {
                it.value == null
            }.toMap() as Map<String, Any>
            callback(Result.success(attributes))
        }
    }

    override fun getLocaleIdentifier(): String? {
        return Superwall.instance.localeIdentifier
    }

    override fun setLocaleIdentifier(localeIdentifier: String?) {
        Superwall.instance.localeIdentifier = localeIdentifier
    }

    // Unspecified is reported as the default, both granted, like iOS.
    override fun getAdConsent(): PAdConsent {
        return Superwall.instance.adConsent.toPigeon()
    }

    override fun setAdConsent(adConsent: PAdConsent) {
        Superwall.instance.adConsent = adConsent.toSdk()
    }

    override fun getUserId(): String {
        return Superwall.instance.userId
    }

    override fun getIsLoggedIn(): Boolean {
        return Superwall.instance.isLoggedIn
    }

    override fun getIsInitialized(): Boolean {
        return Superwall.initialized;
    }

    override fun identify(userId: String, identityOptions: PIdentityOptions?) {
        Superwall.instance.identify(userId, options = identityOptions?.let {
            IdentityOptions(
                (it.restorePaywallAssignments == true)
            )
        })
    }

    override fun getEntitlements(): PEntitlements {
        return PEntitlements(
            active = Superwall.instance.entitlements.active.map { CustomerInfoMapper.toPigeon(it) },
            inactive = Superwall.instance.entitlements.inactive.map { CustomerInfoMapper.toPigeon(it) },
            all = Superwall.instance.entitlements.all.map { CustomerInfoMapper.toPigeon(it) },
            web = Superwall.instance.entitlements.web.map { CustomerInfoMapper.toPigeon(it) }
        )
    }

    override fun getEntitlementsByProductIds(productIds: List<String>): List<PEntitlement> {
        return Superwall.instance.entitlements.byProductIds(productIds.toSet())
            .map { CustomerInfoMapper.toPigeon(it) }
    }

    override fun getCustomerInfo(callback: (Result<PCustomerInfo>) -> Unit) {
        callback(runCatching { CustomerInfoMapper.toPigeon(Superwall.instance.getCustomerInfo()) })
    }

    override fun getSubscriptionStatus(): PSubscriptionStatus {
        return Superwall.instance.subscriptionStatus.value.toPigeon()
    }

    override fun setSubscriptionStatus(subscriptionStatus: PSubscriptionStatus) {
        Superwall.instance.setSubscriptionStatus(
            subscriptionStatus.fromPigeon()
        )
    }

    override fun getConfigurationStatus(): PConfigurationStatus {
        return Superwall.instance.configurationState.let {
            when (it) {
                ConfigurationStatus.Configured -> PConfigurationStatus.CONFIGURED
                ConfigurationStatus.Failed -> PConfigurationStatus.FAILED
                ConfigurationStatus.Pending -> PConfigurationStatus.PENDING
            }
        }
    }

    override fun getIsConfigured(): Boolean {
        return Superwall.instance.configurationState is ConfigurationStatus.Configured
    }

    override fun getIsPaywallPresented(): Boolean {
        return Superwall.instance.isPaywallPresented
    }

    override fun preloadAllPaywalls() {
        Superwall.instance.preloadAllPaywalls()
    }

    override fun preloadPaywallsForPlacements(placementNames: List<String>) {
        Superwall.instance.preloadPaywalls(placementNames.toSet())
    }

    override fun handleDeepLink(url: String): Boolean {
        return Superwall.handleDeepLink(url.toUri()).getOrNull() ?: false
    }

    override fun togglePaywallSpinner(isHidden: Boolean) {
        Superwall.instance.togglePaywallSpinner(isHidden)
    }

    override fun getLatestPaywallInfo(): PPaywallInfo? {
        return Superwall.instance.latestPaywallInfo?.let {
            PaywallInfoMapper.toPPaywallInfo(it)
        }
    }

    override fun getPresentationResult(
        placement: String,
        params: Map<String, Any>?,
        callback: (Result<PPresentationResult>) -> Unit
    ) {
        fun toPExperiment(experiment: Experiment) =
            PExperiment(
                id = experiment.id,
                groupId = experiment.groupId,
                variant = PVariant(
                    id = experiment.variant.id,
                    type = when (experiment.variant.type) {
                        Experiment.Variant.VariantType.TREATMENT -> PVariantType.TREATMENT
                        else -> PVariantType.HOLDOUT
                    },
                    paywallId = experiment.variant.paywallId
                )
            )

        ioScope.launch {
            Superwall.instance.getPresentationResult(placement, params).fold({
                when (it) {
                    is PresentationResult.PlacementNotFound -> PPlacementNotFoundPresentationResult(
                        false
                    )

                    is PresentationResult.NoAudienceMatch -> PNoAudienceMatchPresentationResult(
                        false
                    )

                    is PresentationResult.Paywall -> PPaywallPresentationResult(
                        toPExperiment(it.experiment)
                    )

                    is PresentationResult.Holdout -> PHoldoutPresentationResult(
                        toPExperiment(it.experiment)
                    )

                    is PresentationResult.PaywallNotAvailable -> PPaywallNotAvailablePresentationResult(
                        false
                    )

                }.let {
                    callback(Result.success(it))
                }
            }, {
                callback(Result.failure(it))
            })
        }
    }

    override fun registerPlacement(
        placement: String,
        params: Map<String, Any>?,
        handler: PPaywallPresentationHandlerHost?,
        feature: PFeatureHandlerHost?,
        callback: (Result<Unit>) -> Unit
    ) {
        val host = if (handler != null) PaywallPresentationHandlerHost({
            PPaywallPresentationHandlerGenerated(binaryMessenger(), placement)
        }) else null

        Superwall.instance.register(
            placement, params, host?.handler, if (feature != null) {
                {
                    PFeatureHandlerGenerated(binaryMessenger(), placement).onFeature(
                        feature.hostId ?: "", {}
                    )
                }
            } else null
        )
        callback(Result.success(Unit))
    }

    override fun dismiss() {
        ioScope.launch {
            Superwall.instance.dismiss()
        }
    }

    override fun presentCustomerCenter(
        configuration: PCustomerCenterConfiguration?,
        delegate: PCustomerCenterDelegateHost?,
        callback: (Result<Unit>) -> Unit
    ) {
        val host = delegate?.let {
            CustomerCenterDelegateHost(
                PCustomerCenterDelegateGenerated(binaryMessenger(), it.hostId ?: "")
            )
        }
        mainScope.launch {
            val result = runCatching {
                Superwall.instance.presentCustomerCenter(
                    configuration = configuration?.toSdk(),
                    delegate = host,
                    onDismiss = host?.let { { it.onDismiss() } },
                )
            }
            callback(result)
        }
    }

    override fun dismissCustomerCenter(callback: (Result<Unit>) -> Unit) {
        mainScope.launch {
            try {
                Superwall.instance.dismissCustomerCenter { callback(Result.success(Unit)) }
            } catch (e: Throwable) {
                callback(Result.failure(e))
            }
        }
    }

    override fun getOverrideProductsByName(): Map<String, String>? {
        return Superwall.instance.overrideProductsByName
    }

    override fun setOverrideProductsByName(overrideProducts: Map<String, String>?) {
        Superwall.instance.overrideProductsByName = overrideProducts?:emptyMap()
    }

    override fun consume(purchaseToken: String, callback: (Result<String>) -> Unit) {
        ioScope.launch {
            callback(Superwall.instance.consume(purchaseToken))
        }
    }

    override fun getProducts(
        productIds: List<String>,
        callback: (Result<List<PStoreProduct>>) -> Unit
    ) {
        ioScope.launch {
            val ids = productIds.distinct()
            if (ids.isEmpty()) {
                callback(Result.success(emptyList()))
                return@launch
            }
            val result = Superwall.instance.getProducts(*ids.toTypedArray()).fold(
                onSuccess = { Result.success(it) },
                onFailure = { batchError ->
                    // An identifier the store previously failed to return fails the whole batch,
                    // so retry each identifier on its own and omit the unknown ones.
                    val individual = ids.map { id ->
                        async { Superwall.instance.getProducts(id) }
                    }.awaitAll()
                    val found = individual.mapNotNull { it.getOrNull() }
                        .fold(emptyMap<String, StoreProduct>()) { acc, map -> acc + map }
                    if (found.isEmpty() && batchError.isBillingError()) {
                        Result.failure(batchError)
                    } else {
                        Result.success(found)
                    }
                }
            ).map { productsById ->
                ids.mapNotNull { productsById[it]?.pigeonify() }
            }
            callback(result)
        }
    }

    override fun purchase(productId: String, callback: (Result<PPurchaseResult>) -> Unit) {
        ioScope.launch {
            val result = Superwall.instance.purchase(productId).fold(
                onSuccess = {
                    when (it) {
                        is PurchaseResult.Purchased -> PPurchasePurchased()
                        is PurchaseResult.Cancelled -> PPurchaseCancelled()
                        is PurchaseResult.Pending -> PPurchasePending()
                        is PurchaseResult.Failed -> PPurchaseFailed(it.errorMessage)
                    }
                },
                onFailure = {
                    PPurchaseFailed(it.localizedMessage ?: it.toString())
                }
            )
            callback(Result.success(result))
        }
    }

    override fun queryInAppPurchases(callback: (Result<List<POwnedInAppPurchase>>) -> Unit) {
        ioScope.launch {
            callback(runCatching { inAppPurchaseQuery.queryPurchased() })
        }
    }

    override fun onListen(p0: Any?, sink: PigeonEventSink<PSubscriptionStatus>) {
        latestStreamJob = ioScope.launch {
            Superwall.instance.subscriptionStatus.collectLatest {
                mainScope.launch {
                    sink.success(it.toPigeon())
                }
            }
        }
    }

    override fun onCancel(p0: Any?) {
        latestStreamJob?.cancel()
    }

    override fun restorePurchases(callback: (Result<PRestorationResult>) -> Unit) {
        ioScope.launch {
            val res = Superwall.instance.restorePurchases().map {
                when (it) {
                    is RestorationResult.Restored -> PRestorationRestored()
                    is RestorationResult.Failed -> PRestorationFailed(
                        it.error?.localizedMessage ?: "Unknown error"
                    )
                }
            }
            callback(res)
        }
    }
}

private fun Throwable.isBillingError(): Boolean =
    generateSequence(this) { it.cause }.any { it is BillingError }

// MARK: - PIntegrationAttribute Extension

/**
 * The native [AttributionProvider] for attributes that are set through
 * `Superwall.setIntegrationAttributes` rather than as `$`-prefixed user attributes.
 */
fun PIntegrationAttribute.toAttributionProvider(): AttributionProvider? {
    return when (this) {
        PIntegrationAttribute.AIRBRIDGE_ID -> AttributionProvider.AIRBRIDGE_ID
        else -> null
    }
}

fun PIntegrationAttribute.toAttributeKey(): String {
    return when (this) {
        PIntegrationAttribute.ADJUST_ID -> "\$adjust_id"
        PIntegrationAttribute.AMPLITUDE_DEVICE_ID -> "\$amplitude_device_id"
        PIntegrationAttribute.AMPLITUDE_USER_ID -> "\$amplitude_user_id"
        PIntegrationAttribute.APPSFLYER_ID -> "\$appsflyer_id"
        PIntegrationAttribute.BRAZE_ALIAS_NAME -> "\$braze_alias_name"
        PIntegrationAttribute.BRAZE_ALIAS_LABEL -> "\$braze_alias_label"
        PIntegrationAttribute.ONESIGNAL_ID -> "\$onesignal_id"
        PIntegrationAttribute.FB_ANON_ID -> "\$fb_anon_id"
        PIntegrationAttribute.FIREBASE_APP_INSTANCE_ID -> "\$firebase_app_instance_id"
        PIntegrationAttribute.ITERABLE_USER_ID -> "\$iterable_user_id"
        PIntegrationAttribute.ITERABLE_CAMPAIGN_ID -> "\$iterable_campaign_id"
        PIntegrationAttribute.ITERABLE_TEMPLATE_ID -> "\$iterable_template_id"
        PIntegrationAttribute.MIXPANEL_DISTINCT_ID -> "\$mixpanel_distinct_id"
        PIntegrationAttribute.MPARTICLE_ID -> "\$mparticle_id"
        PIntegrationAttribute.CLEVERTAP_ID -> "\$clevertap_id"
        PIntegrationAttribute.AIRSHIP_CHANNEL_ID -> "\$airship_channel_id"
        PIntegrationAttribute.KOCHAVA_DEVICE_ID -> "\$kochava_device_id"
        PIntegrationAttribute.TENJIN_ID -> "\$tenjin_id"
        PIntegrationAttribute.POSTHOG_USER_ID -> "\$posthog_user_id"
        PIntegrationAttribute.CUSTOMERIO_ID -> "\$customerio_id"
        PIntegrationAttribute.APPSTACK_ID -> "\$appstack_id"
        PIntegrationAttribute.AIRBRIDGE_ID -> "\$airbridge_id"
    }
}
