package com.superwall.superwallkit_flutter

import android.content.Context
import com.superwall.superwallkit_flutter.bridges.BridgeId
import com.superwall.superwallkit_flutter.bridges.BridgeInstance
import com.superwall.superwallkit_flutter.bridges.CompletionBlockProxyBridge
import com.superwall.superwallkit_flutter.bridges.ConfigurationStatusConfiguredBridge
import com.superwall.superwallkit_flutter.bridges.ConfigurationStatusFailedBridge
import com.superwall.superwallkit_flutter.bridges.ConfigurationStatusPendingBridge
import com.superwall.superwallkit_flutter.bridges.ExperimentBridge
import com.superwall.superwallkit_flutter.bridges.PaywallInfoBridge
import com.superwall.superwallkit_flutter.bridges.PaywallPresentationHandlerProxyBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonPlacementNotFoundBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonHoldoutBridge
import com.superwall.superwallkit_flutter.bridges.PaywallSkippedReasonNoAudienceMatchBridge
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
val BridgingCreator.bridgeInitializers: Map<String, (Context, BridgeId, Map<String, Any>?) -> BridgeInstance>
    get() = mapOf(
        SuperwallBridge.bridgeClass() to { context, bridgeId, args -> SuperwallBridge(context, bridgeId, args) },
        SuperwallDelegateProxyBridge.bridgeClass() to { context, bridgeId, args -> SuperwallDelegateProxyBridge(context, bridgeId, args) },
        PurchaseControllerProxyBridge.bridgeClass() to { context, bridgeId, args -> PurchaseControllerProxyBridge(context, bridgeId, args) },
        CompletionBlockProxyBridge.bridgeClass() to { context, bridgeId, args -> CompletionBlockProxyBridge(context, bridgeId, args) },
        SubscriptionStatusActiveBridge.bridgeClass() to { context, bridgeId, args -> SubscriptionStatusActiveBridge(context, bridgeId, args) },
        SubscriptionStatusInactiveBridge.bridgeClass() to { context, bridgeId, args -> SubscriptionStatusInactiveBridge(context, bridgeId, args) },
        SubscriptionStatusUnknownBridge.bridgeClass() to { context, bridgeId, args -> SubscriptionStatusUnknownBridge(context, bridgeId, args) },
        PaywallPresentationHandlerProxyBridge.bridgeClass() to { context, bridgeId, args -> PaywallPresentationHandlerProxyBridge(context, bridgeId, args) },
        PaywallSkippedReasonHoldoutBridge.bridgeClass() to { context, bridgeId, args -> PaywallSkippedReasonHoldoutBridge(context, bridgeId, args) },
        PaywallSkippedReasonNoAudienceMatchBridge.bridgeClass() to { context, bridgeId, args -> PaywallSkippedReasonNoAudienceMatchBridge(context, bridgeId, args) },
        PaywallSkippedReasonPlacementNotFoundBridge.bridgeClass() to { context, bridgeId, args -> PaywallSkippedReasonPlacementNotFoundBridge(context, bridgeId, args) },
        ExperimentBridge.bridgeClass() to { context, bridgeId, args -> ExperimentBridge(context, bridgeId, args) },
        PaywallInfoBridge.bridgeClass() to { context, bridgeId, args -> PaywallInfoBridge(context, bridgeId, args) },
        PurchaseResultCancelledBridge.bridgeClass() to { context, bridgeId, args -> PurchaseResultCancelledBridge(context, bridgeId, args) },
        PurchaseResultPurchasedBridge.bridgeClass() to { context, bridgeId, args -> PurchaseResultPurchasedBridge(context, bridgeId, args) },
        PurchaseResultRestoredBridge.bridgeClass() to { context, bridgeId, args -> PurchaseResultRestoredBridge(context, bridgeId, args) },
        PurchaseResultPendingBridge.bridgeClass() to { context, bridgeId, args -> PurchaseResultPendingBridge(context, bridgeId, args) },
        PurchaseResultFailedBridge.bridgeClass() to { context, bridgeId, args -> PurchaseResultFailedBridge(context, bridgeId, args) },
        RestorationResultRestoredBridge.bridgeClass() to { context, bridgeId, args -> RestorationResultRestoredBridge(context, bridgeId, args) },
        RestorationResultFailedBridge.bridgeClass() to { context, bridgeId, args -> RestorationResultFailedBridge(context, bridgeId, args) },
        ConfigurationStatusFailedBridge.bridgeClass() to { context, bridgeId, _ -> ConfigurationStatusFailedBridge(context, bridgeId) },
        ConfigurationStatusPendingBridge.bridgeClass() to { context, bridgeId, _ -> ConfigurationStatusPendingBridge(context, bridgeId) },
        ConfigurationStatusConfiguredBridge.bridgeClass() to { context, bridgeId, _ -> ConfigurationStatusConfiguredBridge(context, bridgeId) }
    )
