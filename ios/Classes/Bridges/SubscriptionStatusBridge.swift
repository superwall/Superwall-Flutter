import Flutter
import SuperwallKit

// Abstract base class for subscription status enum
public class SubscriptionStatusBridge: BaseBridge {
  var status: SubscriptionStatus {
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

public class SubscriptionStatusActiveBridge: SubscriptionStatusBridge {
  override var status: SubscriptionStatus { .active }
}

public class SubscriptionStatusInactiveBridge: SubscriptionStatusBridge {
  override var status: SubscriptionStatus { .inactive }
}

public class SubscriptionStatusUnknownBridge: SubscriptionStatusBridge {
  override var status: SubscriptionStatus { .unknown }
}

extension SubscriptionStatus {
  func toJson() -> String {
    switch self {
      case .active:
        return "active"
      case .inactive:
        return "inactive"
      case .unknown:
        return "unknown"
    }
  }
}
