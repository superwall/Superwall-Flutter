import Flutter
import SuperwallKit

extension StoreTransaction {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["configRequestId"] = configRequestId
    dict["appSessionId"] = appSessionId
    dict["triggerSessionId"] = triggerSessionId
    dict["transactionDate"] = transactionDate?.timeIntervalSince1970
    dict["originalTransactionIdentifier"] = originalTransactionIdentifier
    dict["state"] = state.rawValue
    dict["storeTransactionId"] = storeTransactionId
    dict["payment"] = payment.toJson()
    dict["originalTransactionDate"] = originalTransactionDate?.timeIntervalSince1970
    dict["webOrderLineItemID"] = webOrderLineItemID
    dict["appBundleId"] = appBundleId
    dict["subscriptionGroupId"] = subscriptionGroupId
    dict["isUpgraded"] = isUpgraded
    dict["expirationDate"] = expirationDate?.timeIntervalSince1970
    dict["offerId"] = offerId
    dict["revocationDate"] = revocationDate?.timeIntervalSince1970
    dict["appAccountToken"] = appAccountToken?.uuidString
    return dict
  }
}

extension StoreTransactionState {
  func toJson() -> String {
    switch self {
      case .purchasing:
        return "purchasing"
      case .purchased:
        return "purchased"
      case .failed:
        return "failed"
      case .restored:
        return "restored"
      case .deferred:
        return "deferred"
    }
  }
}

extension StorePayment {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["productIdentifier"] = productIdentifier
    dict["quantity"] = quantity
    if let discountIdentifier = discountIdentifier {
      dict["discountIdentifier"] = discountIdentifier
    }
    return dict
  }
}
