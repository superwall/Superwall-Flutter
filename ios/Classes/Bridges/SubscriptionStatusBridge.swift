import Flutter
import SuperwallKit

// Abstract base class for subscription status enum
public class SubscriptionStatusBridge: BridgeInstance {
  var status: SubscriptionStatus {
    fatalError("Subclasses must implement")
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

public class SubscriptionStatusActiveBridge: SubscriptionStatusBridge {
  override class func bridgeClass() -> BridgeClass {
    return "SubscriptionStatusActiveBridge"
  }

  override var status: SubscriptionStatus { .active }
}

public class SubscriptionStatusInactiveBridge: SubscriptionStatusBridge {
  override class func bridgeClass() -> BridgeClass {
    return "SubscriptionStatusInactiveBridge"
  }

  override var status: SubscriptionStatus { .inactive }
}

public class SubscriptionStatusUnknownBridge: SubscriptionStatusBridge {
  override class func bridgeClass() -> BridgeClass {
    return "SubscriptionStatusUnknownBridge"
  }

  override var status: SubscriptionStatus { .unknown }
}

extension SubscriptionStatus {
  func createBridgeId() -> BridgeId {
    switch self {
      case .active:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: SubscriptionStatusActiveBridge.bridgeClass())
        return bridgeInstance.bridgeId
      case .inactive:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: SubscriptionStatusInactiveBridge.bridgeClass())
        return bridgeInstance.bridgeId
      case .unknown:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: SubscriptionStatusUnknownBridge.bridgeClass())
        return bridgeInstance.bridgeId
    }
  }
}
