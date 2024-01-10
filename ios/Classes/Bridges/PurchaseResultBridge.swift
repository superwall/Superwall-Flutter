import Flutter
import SuperwallKit

public class PurchaseResultBridge: BridgeInstance {
  var purchaseResult: PurchaseResult {
    assertionFailure("Subclasses must implement")
    return .failed(PurchaseResultError(message: "Subclasses must implement purchaseResult"))
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterMethodNotImplemented)
  }
}

public class PurchaseResultCancelledBridge: PurchaseResultBridge {
  class override var bridgeClass: BridgeClass { "PurchaseResultCancelledBridge" }
  override var purchaseResult: PurchaseResult { return .cancelled }
}

public class PurchaseResultPurchasedBridge: PurchaseResultBridge {
  class override var bridgeClass: BridgeClass { "PurchaseResultPurchasedBridge" }
  override var purchaseResult: PurchaseResult { return .purchased }
}

public class PurchaseResultRestoredBridge: PurchaseResultBridge {
  class override var bridgeClass: BridgeClass { "PurchaseResultRestoredBridge" }
  override var purchaseResult: PurchaseResult { return .restored }
}

public class PurchaseResultPendingBridge: PurchaseResultBridge {
  class override var bridgeClass: BridgeClass { "PurchaseResultPendingBridge" }
  override var purchaseResult: PurchaseResult { return .pending }
}

public class PurchaseResultFailedBridge: PurchaseResultBridge {
  class override var bridgeClass: BridgeClass { "PurchaseResultFailedBridge" }
  override var purchaseResult: PurchaseResult { .failed(error) }

  let error: Error

  required init(bridgeId: BridgeId, initializationArgs: [String : Any]? = nil) {
    guard let error = initializationArgs?["error"] as? String else {
      fatalError("Attempting to create `PurchaseResultFailedBridge` without providing `error`.")
    }

    self.error = PurchaseResultError(message: error)
    super.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
  }
}

struct PurchaseResultError: Error {
  let message: String
}
