import Flutter
import SuperwallKit

// Abstract base class for subscription status enum
public class EntitlementStatusBridge: BridgeInstance {
  var status: EntitlementStatus {
    assertionFailure("Subclasses must implement")
    return .unknown
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getDescription":
        let description = status.description
        result(description)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

public class EntitlementStatusActiveBridge: EntitlementStatusBridge {
  class override var bridgeClass: BridgeClass { "EntitlementStatusActiveBridge" }
  override var status: EntitlementStatus { .active(entitlements) }

  let entitlements: Set<Entitlement>

  required init(bridgeId: BridgeId, initializationArgs: [String : Any]? = nil) {
    guard let entitlements = initializationArgs?["entitlements"] as? Set<Entitlement> else {
      fatalError("Attempting to create `RestorationResultFailedBridge` without providing `error`.")
    }

    self.entitlements = entitlements
    super.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
  }
}

public class EntitlementStatusInactiveBridge: EntitlementStatusBridge {
  class override var bridgeClass: BridgeClass { "EntitlementStatusInactiveBridge" }
  override var status: EntitlementStatus { .inactive }
}

public class EntitlementStatusUnknownBridge: EntitlementStatusBridge {
  class override var bridgeClass: BridgeClass { "EntitlementStatusUnknownBridge" }
  override var status: EntitlementStatus { .unknown }
}

extension EntitlementStatus {
  func createBridgeId() -> BridgeId {
    switch self {
      case .active:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: EntitlementStatusActiveBridge.bridgeClass)
        return bridgeInstance.bridgeId
      case .inactive:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: EntitlementStatusInactiveBridge.bridgeClass)
        return bridgeInstance.bridgeId
      case .unknown:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: EntitlementStatusUnknownBridge.bridgeClass)
        return bridgeInstance.bridgeId
    }
  }
}
