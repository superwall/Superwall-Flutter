import Flutter
import SuperwallKit

public class RestorationResultBridge: BridgeInstance {
  var restorationResult: RestorationResult {
    assertionFailure("Subclasses must implement")
    return .failed(RestorationResultError(message: "Subclasses must implement restorationResult"))
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterMethodNotImplemented)
  }
}

public class RestorationResultRestoredBridge: RestorationResultBridge {
  override class func bridgeClass() -> BridgeClass { return "RestorationResultRestoredBridge" }
  override var restorationResult: RestorationResult { return .restored }
}

public class RestorationResultFailedBridge: RestorationResultBridge {
  override class func bridgeClass() -> BridgeClass { return "RestorationResultFailedBridge" }
  override var restorationResult: RestorationResult { .failed(error) }

  let error: Error

  required init(bridgeId: BridgeId, initializationArgs: [String : Any]? = nil) {
    guard let error = initializationArgs?["error"] as? String else {
      fatalError("Attempting to create `RestorationResultFailedBridge` without providing `error`.")
    }

    self.error = RestorationResultError(message: error)
    super.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
  }
}

struct RestorationResultError: Error {
  let message: String
}
