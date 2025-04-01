package com.superwall.superwallkit_flutter

import PActive
import PConfigurationStatus
import PConfirmedAssignment
import PEntitlement
import PIdentityOptions
import PInactive
import PPurchaseControllerHost
import PSubscriptionStatus
import PSuperwallHostApi
import PSuperwallHostApi.Companion.setUp
import PSuperwallOptions
import PUnknown
import PVariant
import PVariantType
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
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger

class SuperwallHost(
    val context: () -> Application,
    binaryMessenger: BinaryMessenger
) : PSuperwallHostApi {

    init {
        setUp(binaryMessenger = binaryMessenger, this)
    }

    private val ioScope = CoroutineScope(Dispatchers.IO)

    override fun configure(
        apiKey: String,
        purchaseController: PPurchaseControllerHost?, //TODO pass in controller as proxy here
        options: PSuperwallOptions?,
        callback: (Result<Unit>) -> Unit
    ) {
        val sdkOptions = options?.toSdkOptions()
        Superwall.configure(
            applicationContext = context(), apiKey = apiKey, options = sdkOptions,
            completion = callback
        )
    }

    //TODO missing delegate method

    override fun reset() {
        Superwall.instance.reset()
    }

    override fun setDelegate(delegateProxyBridgeId: String) {
        TODO("Not yet implemented")
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

    override fun getEntitlements(): List<PEntitlement> {
        return Superwall.instance.entitlements.active.map {
            PEntitlement(it.id)
        }
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
        TODO("Not yet implemented")
    }

    override fun dismiss() {
        ioScope.launch {
            Superwall.instance.dismiss()
        }
    }

    override fun registerPlacement(placement: String, params: Map<String, Any>?) {
        TODO("Not yet implemented")
    }
}