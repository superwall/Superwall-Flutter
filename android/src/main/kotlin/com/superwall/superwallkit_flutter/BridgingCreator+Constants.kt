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

// Extension property for Constants in BridgingCreator
val BridgingCreator.Constants.bridgeTypes: List<Class<out BridgeInstance>>
    get() = listOf(
        SuperwallBridge::class.java,
        SuperwallDelegateProxyBridge::class.java,
        PurchaseControllerProxyBridge::class.java,
        CompletionBlockProxyBridge::class.java,
        SubscriptionStatusActiveBridge::class.java,
        SubscriptionStatusInactiveBridge::class.java,
        SubscriptionStatusUnknownBridge::class.java,
        PaywallPresentationHandlerProxyBridge::class.java,
        PaywallSkippedReasonHoldoutBridge::class.java,
        PaywallSkippedReasonNoRuleMatchBridge::class.java,
        PaywallSkippedReasonEventNotFoundBridge::class.java,
        PaywallSkippedReasonUserIsSubscribedBridge::class.java,
        ExperimentBridge::class.java,
        PaywallInfoBridge::class.java,
        PurchaseResultCancelledBridge::class.java,
        PurchaseResultPurchasedBridge::class.java,
        PurchaseResultRestoredBridge::class.java,
        PurchaseResultPendingBridge::class.java,
        PurchaseResultFailedBridge::class.java,
        RestorationResultRestoredBridge::class.java,
        RestorationResultFailedBridge::class.java
    )

val BridgingCreator.bridgeMap: Map<String, Class<out BridgeInstance>>
    get() = BridgingCreator.Constants.bridgeTypes.associate { it.simpleName to it }
