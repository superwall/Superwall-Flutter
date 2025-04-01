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