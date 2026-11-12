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
        paywallResult: PaywallPresentationHandlerHost.pigeonify(result),
        completion: { result in
          // NO-OP
        }
      )
    }

    handler.onDismiss { [weak self] paywallInfo, result in
      self?.flutterHandler.onDismiss(
        paywallInfo: paywallInfo.pigeonify(),
        paywallResult: PaywallPresentationHandlerHost.pigeonify(result),
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
      let pReason: PPaywallSkippedReason

      switch reason {
      case .holdout:
        pReason = .holdout
      case .noAudienceMatch:
        pReason = .noAudienceMatch
      case .placementNotFound:
        pReason = .placementNotFound
      }

      self?.flutterHandler.onSkip(
        reason: pReason,
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

      let pCallback = PCustomCallback(
        name: callback.name,
        variables: callback.variables
      )

      let result: CustomCallbackResult = await withCheckedContinuation { continuation in
        self.flutterHandler.onCustomCallback(callback: pCallback) { pResult in
          switch pResult {
          case .success(let pCallbackResult):
            continuation.resume(returning: CustomCallbackResult(
              status: pCallbackResult.status == .success ? .success : .failure,
              data: pCallbackResult.data
            ))
          case .failure:
            continuation.resume(returning: CustomCallbackResult(status: .failure, data: nil))
          }
        }
      }

      return result
    }
  }

  private static func pigeonify(_ result: PaywallResult) -> PPaywallResult {
    switch result {
    case .purchased(let product):
      return PPurchasedPaywallResult(productId: product.productIdentifier)
    case .restored:
      return PRestoredPaywallResult(ignore: false)
    case .declined:
      return PDeclinedPaywallResult(ignore: false)
    }
  }
}
