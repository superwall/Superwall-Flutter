import Flutter
import SuperwallKit

public class PaywallPresentationHandlerProxyBridge: BridgeInstance {
  override class var bridgeClass: BridgeClass { "PaywallPresentationHandlerProxyBridge" }

  lazy var handler: PaywallPresentationHandler = {
    let handler = PaywallPresentationHandler()

    handler.onPresent { [weak self] paywallInfo in
      guard let self else { return }
      communicator.invokeMethod("onPresent", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
    }

    handler.onDismiss { [weak self] paywallInfo in
      guard let self else { return }
      communicator.invokeMethod("onDismiss", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
    }

    handler.onError { [weak self] error in
      guard let self else { return }
      communicator.invokeMethod("onError", arguments: ["errorString": error.localizedDescription])
    }

    handler.onSkip { [weak self] paywallSkippedReason in
      guard let self else { return }
      communicator.invokeMethod("onSkip", arguments: ["paywallSkippedReasonBridgeId": paywallSkippedReason.createBridgeId()])
    }

    return handler
  }()
}
