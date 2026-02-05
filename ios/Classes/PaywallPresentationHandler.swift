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

    handler.onDismiss { [weak self] paywallInfo, result in
      let pResult: PPaywallResult

      switch result {
      case .purchased(let product):
        pResult = PPurchasedPaywallResult(productId: product.productIdentifier)
      case .restored:
        pResult = PRestoredPaywallResult(ignore: false)
      case .declined:
        pResult = PDeclinedPaywallResult(ignore: false)
      }

      self?.flutterHandler.onDismiss(
        paywallInfo: paywallInfo.pigeonify(),
        paywallResult: pResult,
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

    handler.onCustomCallback { [weak self] callback in
      guard let self = self else {
        return CustomCallbackResult.failure()
      }

      // Convert SDK's CustomCallback to Pigeon's PCustomCallback
      let pCallback = PCustomCallback(
        name: callback.name,
        variables: callback.variables
      )

      // Use a semaphore to wait for the async Flutter call
      let semaphore = DispatchSemaphore(value: 0)
      var result: CustomCallbackResult = .failure()

      self.flutterHandler.onCustomCallback(callback: pCallback) { pResult in
        switch pResult {
        case .success(let pCallbackResult):
          result = CustomCallbackResult(
            status: pCallbackResult.status == .success ? .success : .failure,
            data: pCallbackResult.data
          )
        case .failure:
          result = .failure()
        }
        semaphore.signal()
      }

      // Wait for the result with a timeout
      _ = semaphore.wait(timeout: .now() + 30)

      return result
    }
  }
}
