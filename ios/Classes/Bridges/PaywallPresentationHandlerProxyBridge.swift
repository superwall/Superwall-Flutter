import Flutter
import SuperwallKit

public class PaywallPresentationHandlerProxyBridge: BaseBridge {
  lazy var handler: PaywallPresentationHandler = {
    let handler = PaywallPresentationHandler()

    handler.onPresent { [weak self] paywallInfo in
      guard let self else { return }
      channel.invokeMethod("onPresent", arguments: ["paywallInfo": paywallInfo.toJson()])
    }

    handler.onDismiss { [weak self] paywallInfo in
      guard let self else { return }
      channel.invokeMethod("onDismiss", arguments: ["paywallInfo": paywallInfo.toJson()])
    }

    handler.onError { [weak self] error in
      guard let self else { return }
      channel.invokeMethod("onError", arguments: ["error": error.localizedDescription.toJson()])
    }

    handler.onSkip { [weak self] paywallSkippedReason in
      guard let self else { return }
      channel.invokeMethod("onSkip", arguments: ["paywallSkippedReason": paywallSkippedReason.toJson()])
    }

    return handler
  }()
}
