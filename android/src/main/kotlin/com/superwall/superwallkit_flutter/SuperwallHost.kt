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
import PEventTrackingBehavior
import PExperiment
import PEntitlements
import PFeatureHandlerGenerated
import PFeatureHandlerHost
import PIdentityOptions
import PIntegrationAttribute
import PInactive
import PInterfaceStyle
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
import com.superwall.sdk.config.options.EventTrackingBehavior
import com.superwall.sdk.identity.IdentityOptions
import com.superwall.sdk.identity.identify
import com.superwall.sdk.identity.setUserAttributes
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.models.triggers.Experiment
import com.superwall.sdk.network.device.InterfaceStyle
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
    // The native SDK applies integration attributes after a delay, so its getter can lag behind
    // the last map set here. Attributes set in quick succession are merged into this instead.
    private var latestIntegrationAttributes: Map<AttributionProvider, String>? = null

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

    override fun getAssignments(): List<PConfirmedAssignment> {
        return Superwall.instance.getAssignments().getOrThrow().map {
            PConfirmedAssignment(
                it.experimentId,
                PVariant(
                    id = it.variant.id,
                    paywallId = it.variant.paywallId,
                    type = when (it.variant.type) {
                        Experiment.Variant.VariantType.TREATMENT -> PVariantType.TREATMENT
                        Experiment.Variant.VariantType.HOLDOUT -> PVariantType.HOLDOUT
                    }
                )
            )
        }
    }

    override fun refreshConfiguration() {
        Superwall.instance.refreshConfiguration()
    }

    override fun getEventTrackingBehavior(): PEventTrackingBehavior {
        return when (Superwall.instance.eventTrackingBehavior) {
            EventTrackingBehavior.ALL -> PEventTrackingBehavior.ALL
            EventTrackingBehavior.SUPERWALL_ONLY -> PEventTrackingBehavior.SUPERWALL_ONLY
            EventTrackingBehavior.NONE -> PEventTrackingBehavior.NONE
        }
    }

    override fun setEventTrackingBehavior(behavior: PEventTrackingBehavior) {
        Superwall.instance.eventTrackingBehavior = behavior.toSdk()
    }

    override fun setInterfaceStyle(interfaceStyle: PInterfaceStyle?) {
        Superwall.instance.setInterfaceStyle(
            when (interfaceStyle) {
                PInterfaceStyle.LIGHT -> InterfaceStyle.LIGHT
                PInterfaceStyle.DARK -> InterfaceStyle.DARK
                null -> null
            }
        )
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

    override fun setUserAttributes(userAttributes: Map<String, Any?>) {
        Superwall.instance.setUserAttributes(userAttributes)
    }

    override fun setIntegrationAttribute(attribute: PIntegrationAttribute, value: String?) {
        setIntegrationAttributes(mapOf(attribute to value))
    }

    override fun setIntegrationAttributes(attributes: Map<PIntegrationAttribute, String?>) {
        // Attributes without a native provider are ignored.
        val providerAttributes =
            attributes.entries.mapNotNull { (attribute, value) ->
                attribute.toAttributionProvider()?.let { it to value }
            }
        if (providerAttributes.isEmpty()) return

        // The native call replaces every integration attribute, so merge into the current ones.
        val current = latestIntegrationAttributes ?: Superwall.instance.integrationAttributes
            .mapNotNull { (rawName, value) ->
                AttributionProvider.values().firstOrNull { it.rawName == rawName }
                    ?.let { it to value }
            }
            .toMap()
        val merged = current.toMutableMap()
        providerAttributes.forEach { (provider, value) ->
            if (value == null) merged.remove(provider) else merged[provider] = value
        }
        latestIntegrationAttributes = merged
        Superwall.instance.setIntegrationAttributes(merged)
    }

    override fun getIntegrationAttributes(): Map<String, String> {
        return Superwall.instance.integrationAttributes
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

    override fun setPushToken(token: String) {
        Superwall.instance.setPushToken(token)
    }

    override fun optOutOfNotifications() {
        Superwall.instance.optOutOfNotifications()
    }

    override fun optInToNotifications() {
        Superwall.instance.optInToNotifications()
    }

    override fun handleNotificationOpen(data: Map<String, String>) {
        Superwall.instance.handleNotificationOpen(data)
    }

    override fun cancelAllScheduledNotifications() {
        Superwall.instance.cancelAllScheduledNotifications()
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
 * The native [AttributionProvider] to set through `Superwall.setIntegrationAttributes`, or
 * `null` when the Android SDK has none. They can't go through `setUserAttributes` as
 * `$`-prefixed keys: the native SDK drops every user attribute whose key starts with `$`.
 */
fun PIntegrationAttribute.toAttributionProvider(): AttributionProvider? {
    return when (this) {
        PIntegrationAttribute.ADJUST_ID -> AttributionProvider.ADJUST_ID
        PIntegrationAttribute.AMPLITUDE_DEVICE_ID -> AttributionProvider.AMPLITUDE_DEVICE_ID
        PIntegrationAttribute.AMPLITUDE_USER_ID -> AttributionProvider.AMPLITUDE_USER_ID
        PIntegrationAttribute.APPSFLYER_ID -> AttributionProvider.APPSFLYER_ID
        PIntegrationAttribute.BRAZE_ALIAS_NAME -> AttributionProvider.BRAZE_ALIAS_NAME
        PIntegrationAttribute.BRAZE_ALIAS_LABEL -> AttributionProvider.BRAZE_ALIAS_LABEL
        PIntegrationAttribute.ONESIGNAL_ID -> AttributionProvider.ONESIGNAL_ID
        PIntegrationAttribute.FB_ANON_ID -> AttributionProvider.FB_ANON_ID
        PIntegrationAttribute.FIREBASE_APP_INSTANCE_ID -> AttributionProvider.FIREBASE_APP_INSTANCE_ID
        PIntegrationAttribute.ITERABLE_USER_ID -> AttributionProvider.ITERABLE_USER_ID
        PIntegrationAttribute.ITERABLE_CAMPAIGN_ID -> AttributionProvider.ITERABLE_CAMPAIGN_ID
        PIntegrationAttribute.ITERABLE_TEMPLATE_ID -> AttributionProvider.ITERABLE_TEMPLATE_ID
        PIntegrationAttribute.MIXPANEL_DISTINCT_ID -> AttributionProvider.MIXPANEL_DISTINCT_ID
        PIntegrationAttribute.MPARTICLE_ID -> AttributionProvider.MPARTICLE_ID
        PIntegrationAttribute.CLEVERTAP_ID -> AttributionProvider.CLEVERTAP_ID
        PIntegrationAttribute.AIRSHIP_CHANNEL_ID -> AttributionProvider.AIRSHIP_CHANNEL_ID
        PIntegrationAttribute.KOCHAVA_DEVICE_ID -> AttributionProvider.KOCHAVA_DEVICE_ID
        PIntegrationAttribute.TENJIN_ID -> AttributionProvider.TENJIN_ID
        PIntegrationAttribute.POSTHOG_USER_ID -> AttributionProvider.POSTHOG_USER_ID
        PIntegrationAttribute.CUSTOMERIO_ID -> AttributionProvider.CUSTOMERIO_ID
        PIntegrationAttribute.APPSTACK_ID -> AttributionProvider.APPSTACK
        PIntegrationAttribute.AIRBRIDGE_ID -> AttributionProvider.AIRBRIDGE_ID
        PIntegrationAttribute.SINGULAR_DEVICE_ID -> AttributionProvider.SINGULAR_DEVICE_ID
        PIntegrationAttribute.META -> AttributionProvider.META
        PIntegrationAttribute.AMPLITUDE -> AttributionProvider.AMPLITUDE
        PIntegrationAttribute.MIXPANEL -> AttributionProvider.MIXPANEL
        PIntegrationAttribute.GOOGLE_ADS -> AttributionProvider.GOOGLE_ADS
        PIntegrationAttribute.GOOGLE_APP_SET_ID -> AttributionProvider.GOOGLE_APP_SET
        PIntegrationAttribute.CUSTOM -> AttributionProvider.CUSTOM
        // iOS only.
        PIntegrationAttribute.FIREBASE_INSTALLATION_ID -> null
    }
}
