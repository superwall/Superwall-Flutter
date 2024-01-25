import Flutter
import SuperwallKit

public class PaywallPresentationHandlerProxyBridge: BridgeInstance {
  override class var bridgeClass: BridgeClass { "PaywallPresentationHandlerProxyBridge" }

  lazy var handler: PaywallPresentationHandler = {
    let handler = PaywallPresentationHandler()

    handler.onPresent { [weak self] paywallInfo in
      guard let self else { return }
      communicator.invokeMethodOnMain("onPresent", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
    }

    handler.onDismiss { [weak self] paywallInfo in
      guard let self else { return }
      communicator.invokeMethodOnMain("onDismiss", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
    }

    handler.onError { [weak self] error in
      guard let self else { return }
      communicator.invokeMethodOnMain("onError", arguments: ["errorString": error.localizedDescription])
    }

    handler.onSkip { [weak self] paywallSkippedReason in
      guard let self else { return }
      communicator.invokeMethodOnMain("onSkip", arguments: ["paywallSkippedReasonBridgeId": paywallSkippedReason.createBridgeId()])
    }

    return handler
  }()
}
