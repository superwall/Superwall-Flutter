package com.superwall.superwallkit_flutter

import PActive
import PConfigurationStatus
import PConfigureCompletionGenerated
import PConfigureCompletionHost
import PConfirmedAssignment
import PEntitlement
import PEntitlements
import PFeatureHandlerGenerated
import PFeatureHandlerHost
import PIdentityOptions
import PInactive
import PPaywallInfo
import PPaywallPresentationHandlerGenerated
import PPaywallPresentationHandlerHost
import PPurchaseControllerGenerated
import PPurchaseControllerHost
import PSubscriptionStatus
import PSuperwallDelegateGenerated
import PSuperwallHostApi
import PSuperwallHostApi.Companion.setUp
import PSuperwallOptions
import PUnknown
import PVariant
import PVariantType
import android.app.Activity
import android.app.Application
import com.superwall.sdk.Superwall
import com.superwall.sdk.config.models.ConfigurationStatus
import com.superwall.sdk.identity.IdentityOptions
import com.superwall.sdk.identity.identify
import com.superwall.sdk.identity.setUserAttributes
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.models.triggers.Experiment
import com.superwall.sdk.paywall.presentation.dismiss
import com.superwall.superwallkit_flutter.json.JsonExtensions
import com.superwall.superwallkit_flutter.utils.toSdkOptions
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import logLevelFromJson
import toJson
import androidx.core.net.toUri
import com.superwall.sdk.paywall.presentation.register
import com.superwall.superwallkit_flutter.utils.PaywallInfoMapper
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import android.util.Log
import com.superwall.sdk.config.options.SuperwallOptions
import com.superwall.sdk.logger.LogLevel
import com.superwall.sdk.misc.ActivityProvider

class SuperwallHost(
    val context: () -> Application,
    val binaryMessenger: () -> BinaryMessenger
) : PSuperwallHostApi {

    init {
        setUp(binaryMessenger = binaryMessenger(), this)
    }

    private val ioScope = CoroutineScope(Dispatchers.IO)

    override fun configure(
        apiKey: String,
        purchaseController: PPurchaseControllerHost?,
        options: PSuperwallOptions?,
        completion: PConfigureCompletionHost?,
        callback: (Result<Unit>) -> Unit,
    ) {
        val sdkOptions = (options?.toSdkOptions() ?: SuperwallOptions()).apply {
            logging.level = LogLevel.debug
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
        Superwall.instance.delegate =
            if (hasDelegate)
                SuperwallDelegateHost({
                    PSuperwallDelegateGenerated(binaryMessenger())
                }) else null
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

    override fun getLocaleIdentifier(): String? {
        return Superwall.instance.localeIdentifier
    }

    override fun setLocaleIdentifier(localeIdentifier: String?) {
        Superwall.instance.localeIdentifier = localeIdentifier
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
            active = Superwall.instance.entitlements.active.map {
                PEntitlement(it.id)
            }, inactive = Superwall.instance.entitlements.inactive.map {
                PEntitlement(it.id)
            }, all = Superwall.instance.entitlements.all.map {
                PEntitlement(it.id)
            })
    }


    override fun getSubscriptionStatus(): PSubscriptionStatus {
        return Superwall.instance.subscriptionStatus.value.let {
            when (it) {
                is SubscriptionStatus.Active -> PActive(it.entitlements.map {
                    PEntitlement(it.id)
                })

                is SubscriptionStatus.Inactive -> PInactive(false)
                is SubscriptionStatus.Unknown -> PUnknown(false)
            }
        }
    }

    override fun setSubscriptionStatus(subscriptionStatus: PSubscriptionStatus) {
        Superwall.instance.setSubscriptionStatus(
            when (subscriptionStatus) {
                is PActive -> SubscriptionStatus.Active(
                    subscriptionStatus.entitlements.map {
                        Entitlement(it.id!!)
                    }.toSet()
                )

                is PInactive -> SubscriptionStatus.Inactive
                else -> SubscriptionStatus.Unknown
            }
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
        return Superwall.instance.configurationState == ConfigurationStatus.Configured
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
        return Superwall.instance.handleDeepLink(url.toUri()).getOrNull() ?: false
    }

    override fun togglePaywallSpinner(isHidden: Boolean) {
        Superwall.instance.togglePaywallSpinner(isHidden)
    }

    override fun getLatestPaywallInfo(): PPaywallInfo? {
        return Superwall.instance.latestPaywallInfo?.let {
            PaywallInfoMapper.toPPaywallInfo(it)
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

        Log.e("SuperwallHost", "registerPlacement $placement")
        Superwall.instance.register(
            placement, params, host?.handler, if (feature != null) {
                {
                    PFeatureHandlerGenerated(binaryMessenger(), placement).onFeature(
                        feature.hostId ?: "", {}
                    )
                }
            } else null
        )
    }

    override fun dismiss() {
        ioScope.launch {
            Superwall.instance.dismiss()
        }
    }
}