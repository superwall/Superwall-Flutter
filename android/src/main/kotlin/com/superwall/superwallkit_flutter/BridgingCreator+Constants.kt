package com.superwall.superwallkit_flutter

import com.superwall.superwallkit_flutter.bridges.BridgeInstance
import com.superwall.superwallkit_flutter.bridges.CompletionBlockProxyBridge
import com.superwall.superwallkit_flutter.bridges.ExperimentBridge
import com.superwall.superwallkit_flutter.bridges.PaywallInfoBridge
import com.superwall.superwallkit_flutter.bridges.PaywallPresentationHandlerProxyBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonEventNotFoundBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonHoldoutBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonNoRuleMatchBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonUserIsSubscribedBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseControllerProxyBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultCancelledBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultFailedBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultPendingBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultPurchasedBridge
import com.superwall.superwallkit_flutter.bridges.PurchaseResultRestoredBridge
import com.superwall.superwallkit_flutter.bridges.RestorationResultFailedBridge
import com.superwall.superwallkit_flutter.bridges.RestorationResultRestoredBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusActiveBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusInactiveBridge
import com.superwall.superwallkit_flutter.bridges.SubscriptionStatusUnknownBridge
import com.superwall.superwallkit_flutter.bridges.SuperwallBridge
import com.superwall.superwallkit_flutter.bridges.SuperwallDelegateProxyBridge
import kotlin.reflect.KClass

// Extension property for Constants in BridgingCreator
// TODO: Use bridgeClass for the key, but make sure to test in release mode
val BridgingCreator.bridgeMap: Map<String, Class<out BridgeInstance>>
    get() = mapOf(
        "SuperwallBridge" to SuperwallBridge::class.java,
        "SuperwallDelegateProxyBridge" to SuperwallDelegateProxyBridge::class.java,
        "PurchaseControllerProxyBridge" to PurchaseControllerProxyBridge::class.java,
        "CompletionBlockProxyBridge" to CompletionBlockProxyBridge::class.java,
        "SubscriptionStatusActiveBridge" to SubscriptionStatusActiveBridge::class.java,
        "SubscriptionStatusInactiveBridge" to SubscriptionStatusInactiveBridge::class.java,
        "SubscriptionStatusUnknownBridge" to SubscriptionStatusUnknownBridge::class.java,
        "PaywallPresentationHandlerProxyBridge" to PaywallPresentationHandlerProxyBridge::class.java,
        "PaywallSkippedReasonHoldoutBridge" to PaywallSkippedReasonHoldoutBridge::class.java,
        "PaywallSkippedReasonNoRuleMatchBridge" to PaywallSkippedReasonNoRuleMatchBridge::class.java,
        "PaywallSkippedReasonEventNotFoundBridge" to PaywallSkippedReasonEventNotFoundBridge::class.java,
        "PaywallSkippedReasonUserIsSubscribedBridge" to PaywallSkippedReasonUserIsSubscribedBridge::class.java,
        "ExperimentBridge" to ExperimentBridge::class.java,
        "PaywallInfoBridge" to PaywallInfoBridge::class.java,
        "PurchaseResultCancelledBridge" to PurchaseResultCancelledBridge::class.java,
        "PurchaseResultPurchasedBridge" to PurchaseResultPurchasedBridge::class.java,
        "PurchaseResultRestoredBridge" to PurchaseResultRestoredBridge::class.java,
        "PurchaseResultPendingBridge" to PurchaseResultPendingBridge::class.java,
        "PurchaseResultFailedBridge" to PurchaseResultFailedBridge::class.java,
        "RestorationResultRestoredBridge" to RestorationResultRestoredBridge::class.java,
        "RestorationResultFailedBridge" to RestorationResultFailedBridge::class.java
    )

//val BridgingCreator.Constants.bridgeTypes: List<KClass<out BridgeInstance>>
//    get() = listOf(
//        SuperwallBridge::class,
//        SuperwallDelegateProxyBridge::class,
//        PurchaseControllerProxyBridge::class,
//        CompletionBlockProxyBridge::class,
//        SubscriptionStatusActiveBridge::class,
//        SubscriptionStatusInactiveBridge::class,
//        SubscriptionStatusUnknownBridge::class,
//        PaywallPresentationHandlerProxyBridge::class,
//        PaywallSkippedReasonHoldoutBridge::class,
//        PaywallSkippedReasonNoRuleMatchBridge::class,
//        PaywallSkippedReasonEventNotFoundBridge::class,
//        PaywallSkippedReasonUserIsSubscribedBridge::class,
//        ExperimentBridge::class,
//        PaywallInfoBridge::class,
//        PurchaseResultCancelledBridge::class,
//        PurchaseResultPurchasedBridge::class,
//        PurchaseResultRestoredBridge::class,
//        PurchaseResultPendingBridge::class,
//        PurchaseResultFailedBridge::class,
//        RestorationResultRestoredBridge::class,
//        RestorationResultFailedBridge::class
//    )
//
//val BridgingCreator.bridgeMap: Map<String, KClass<out BridgeInstance>>
//    get() = BridgingCreator.Constants.bridgeTypes.associate {
//        it.java.getMethod("bridgeClass").invoke(null) as String to it
//    }
