import Flutter
import SuperwallKit

// Abstract base class for subscription status enum
public class SubscriptionStatusBridge: BridgeInstance {
  var status: SubscriptionStatus {
    assertionFailure("Subclasses must implement")
    return .unknown
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDescription":
      let description = status.description
      result(description)
    case "getEntitlements":
      let entitlements = Superwall.shared.entitlements.active.map { $0.toJson() }
      result(entitlements)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

public class SubscriptionStatusActiveBridge: SubscriptionStatusBridge {
  class override var bridgeClass: BridgeClass { "SubscriptionStatusActiveBridge" }
  override var status: SubscriptionStatus { .active(entitlements) }

  let entitlements: Set<Entitlement>

  required init(
    bridgeId: BridgeId,
    initializationArgs: [String: Any]? = nil
  ) {
    if let entitlementsJson = initializationArgs?["entitlements"] as? [[String: Any]] {
      self.entitlements = Set(entitlementsJson.compactMap { Entitlement.fromJson($0) })
    } else {
      self.entitlements = []
    }

    super.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
  }
}

public class SubscriptionStatusInactiveBridge: SubscriptionStatusBridge {
  class override var bridgeClass: BridgeClass { "SubscriptionStatusInactiveBridge" }
  override var status: SubscriptionStatus { .inactive }
}

public class SubscriptionStatusUnknownBridge: SubscriptionStatusBridge {
  class override var bridgeClass: BridgeClass { "SubscriptionStatusUnknownBridge" }
  override var status: SubscriptionStatus { .unknown }
}

extension SubscriptionStatus {
  func createBridgeId() -> BridgeId {
    switch self {
    case .active:
      let bridgeInstance = BridgingCreator.shared.createBridgeInstance(
        bridgeClass: SubscriptionStatusActiveBridge.bridgeClass)
      return bridgeInstance.bridgeId
    case .inactive:
      let bridgeInstance = BridgingCreator.shared.createBridgeInstance(
        bridgeClass: SubscriptionStatusInactiveBridge.bridgeClass)
      return bridgeInstance.bridgeId
    case .unknown:
      let bridgeInstance = BridgingCreator.shared.createBridgeInstance(
        bridgeClass: SubscriptionStatusUnknownBridge.bridgeClass)
      return bridgeInstance.bridgeId
    }
  }
}
