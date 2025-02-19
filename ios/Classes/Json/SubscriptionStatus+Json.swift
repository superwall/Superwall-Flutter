import SuperwallKit

extension SubscriptionStatus {
  func toJson() -> [String: Any] {
    switch self {
    case let .active(entitlements):
      return [
        "type": "active",
        "entitlements": entitlements.map { $0.toJson() },
      ]
    case .inactive:
      return ["type": "inactive"]
    case .unknown:
      return ["type": "unknown"]
    }
  }
}
