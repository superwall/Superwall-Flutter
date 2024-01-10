import Flutter
import SuperwallKit

public class PaywallSkippedReasonBridge: BridgeInstance {
  var reason: PaywallSkippedReason {
    assertionFailure("Subclasses must implement")
    return .eventNotFound
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getDescription":
        let description = reason.description
        result(description)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

public class PaywallSkippedReasonHoldoutBridge: PaywallSkippedReasonBridge {
  class override var bridgeClass: BridgeClass { "PaywallSkippedReasonHoldoutBridge" }
  override var reason: PaywallSkippedReason { internalReason }

  let internalReason: PaywallSkippedReason

  required init(bridgeId: BridgeId, initializationArgs: [String : Any]? = nil) {
    guard let reason = initializationArgs?["reason"] as? PaywallSkippedReason else {
      fatalError("Attempting to create a `PaywallSkippedReasonHoldoutBridge` without providing a reason.")
    }

    self.internalReason = reason
    super.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
  }

  public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getExperimentBridgeId":
        guard case .holdout(let experiment) = reason else {
          result(FlutterMethodNotImplemented)
          return
        }

        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: ExperimentBridge.bridgeClass, initializationArgs: ["experiment": experiment])
        result(bridgeInstance.bridgeId)

      default:
        super.handle(call, result: result)
    }
  }
}

public class PaywallSkippedReasonNoRuleMatchBridge: PaywallSkippedReasonBridge {
  class override var bridgeClass: BridgeClass { "PaywallSkippedReasonNoRuleMatchBridge" }
  override var reason: PaywallSkippedReason { .noRuleMatch }
}

public class PaywallSkippedReasonEventNotFoundBridge: PaywallSkippedReasonBridge {
  class override var bridgeClass: BridgeClass { "PaywallSkippedReasonEventNotFoundBridge" }
  override var reason: PaywallSkippedReason { .eventNotFound }
}

public class PaywallSkippedReasonUserIsSubscribedBridge: PaywallSkippedReasonBridge {
  class override var bridgeClass: BridgeClass { "PaywallSkippedReasonUserIsSubscribedBridge" }
  override var reason: PaywallSkippedReason { .userIsSubscribed }
}

extension PaywallSkippedReason {
  func createBridgeId() -> BridgeId {
    switch self {
      case .holdout(_):
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: PaywallSkippedReasonHoldoutBridge.bridgeClass, initializationArgs: ["reason": self])
        return bridgeInstance.bridgeId

      case .noRuleMatch:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: PaywallSkippedReasonNoRuleMatchBridge.bridgeClass, initializationArgs: ["reason": self])
        return bridgeInstance.bridgeId

      case .eventNotFound:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: PaywallSkippedReasonEventNotFoundBridge.bridgeClass, initializationArgs: ["reason": self])
        return bridgeInstance.bridgeId

      case .userIsSubscribed:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: PaywallSkippedReasonUserIsSubscribedBridge.bridgeClass, initializationArgs: ["reason": self])
        return bridgeInstance.bridgeId

    }
  }
}
