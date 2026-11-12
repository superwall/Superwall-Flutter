import SuperwallKit
import Foundation

final class PaywallPresentationHandlerHost {
  private let flutterHandler: PPaywallPresentationHandlerGenerated
  let handler: PaywallPresentationHandler
  private let placement: String
  private let cleanupCallback: (String) -> Void

  init(flutterHandler: PPaywallPresentationHandlerGenerated, placement: String, cleanupCallback: @escaping (String) -> Void) {
    self.flutterHandler = flutterHandler
    self.placement = placement
    self.cleanupCallback = cleanupCallback
    handler = PaywallPresentationHandler()

    handler.onPresent { [weak self] paywallInfo in
      self?.flutterHandler.onPresent(
        paywallInfo: paywallInfo.pigeonify(),
        completion: { result in
          // NO-OP
        }
      )
    }

    // The host is only removed once `onDismiss` has been delivered, so it's
    // still alive here.
    handler.onWillDismiss { [weak self] paywallInfo, result in
      self?.flutterHandler.onWillDismiss(
        paywallInfo: paywallInfo.pigeonify(),
        paywallResult: result.pigeonify(),
        completion: { result in
          // NO-OP
        }
      )
    }

    handler.onDismiss { [weak self] paywallInfo, result in
      self?.flutterHandler.onDismiss(
        paywallInfo: paywallInfo.pigeonify(),
        paywallResult: result.pigeonify(),
        completion: { [weak self] result in
          if paywallInfo.closeReason != .none {
            if let self = self {
              self.cleanupCallback(self.placement)
            }
          }
        }
      )
    }

    handler.onError { [weak self] error in
      self?.flutterHandler.onError(
        error: error.localizedDescription,
        completion: { result in
          // NO-OP
        }
      )
    }

    handler.onSkip { [weak self] reason in
      self?.flutterHandler.onSkip(
        reason: reason.pigeonify(),
        experiment: reason.pigeonExperiment,
        completion: { result in
          // NO-OP
          if let self = self {
            self.cleanupCallback(self.placement)
          }
        }
      )
    }

    handler.onCustomCallback { [weak self] callback async in
      guard let self = self else {
        return CustomCallbackResult(status: .failure, data: nil)
      }

      return await callback.forwardToFlutter { pCallback, completion in
        self.flutterHandler.onCustomCallback(callback: pCallback, completion: completion)
      }
    }
  }
}
