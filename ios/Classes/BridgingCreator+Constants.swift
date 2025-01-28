extension BridgingCreator {
  struct Constants {
    static let bridgeTypes: [BridgeInstance.Type] = [
      ConfigurationStatusPendingBridge.self,
      ConfigurationStatusConfiguredBridge.self,
      ConfigurationStatusFailedBridge.self,
      SuperwallBridge.self,
      SuperwallDelegateProxyBridge.self,
      PurchaseControllerProxyBridge.self,
      CompletionBlockProxyBridge.self,
      EntitlementStatusActiveBridge.self,
      EntitlementStatusInactiveBridge.self,
      EntitlementStatusUnknownBridge.self,
      PaywallPresentationHandlerProxyBridge.self,
      PaywallSkippedReasonHoldoutBridge.self,
      PaywallSkippedReasonNoAudienceMatchBridge.self,
      PaywallSkippedReasonPlacementNotFoundBridge.self,
      ExperimentBridge.self,
      PaywallInfoBridge.self,
      PurchaseResultCancelledBridge.self,
      PurchaseResultPurchasedBridge.self,
      PurchaseResultRestoredBridge.self,
      PurchaseResultPendingBridge.self,
      PurchaseResultFailedBridge.self,
      RestorationResultRestoredBridge.self,
      RestorationResultFailedBridge.self,
    ]
  }
}

extension BridgingCreator.Constants {
  static let bridgeMap: [String: BridgeInstance.Type] = {
    return bridgeTypes.reduce(into: [String: BridgeInstance.Type]()) { map, type in
      map[type.bridgeClass] = type
    }
  }()
}
