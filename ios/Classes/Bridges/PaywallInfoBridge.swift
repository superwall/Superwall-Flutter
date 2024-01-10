import Flutter
import SuperwallKit

public class PaywallInfoBridge: BridgeInstance {
  class override var bridgeClass: BridgeClass { "PaywallInfoBridge" }

  let paywallInfo: PaywallInfo

  required init(bridgeId: BridgeId, initializationArgs: [String : Any]? = nil) {
    guard let paywallInfo = initializationArgs?["paywallInfo"] as? PaywallInfo else {
      fatalError("Attempting to create `PaywallInfoBridge` without providing `paywallInfo`.")
    }

    self.paywallInfo = paywallInfo
    super.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // TODO
    switch call.method {
      case "getName":
        let name = paywallInfo.name
        result(name)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

extension PaywallInfo {
  func createBridgeId() -> BridgeId {
    return BridgingCreator.shared.createBridgeInstance(bridgeClass: PaywallInfoBridge.bridgeClass, initializationArgs: ["paywallInfo": self]).bridgeId
  }
}
