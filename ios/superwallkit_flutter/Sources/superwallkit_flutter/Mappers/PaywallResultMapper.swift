import Foundation
import SuperwallKit

extension PaywallResult {
  func pigeonify() -> PPaywallResult {
    switch self {
    case .purchased(let product):
      return PPurchasedPaywallResult(productId: product.productIdentifier)
    case .restored:
      return PRestoredPaywallResult(ignore: false)
    case .declined:
      return PDeclinedPaywallResult(ignore: false)
    }
  }
}

extension PaywallSkippedReason {
  func pigeonify() -> PPaywallSkippedReason {
    switch self {
    case .holdout:
      return .holdout
    case .noAudienceMatch:
      return .noAudienceMatch
    case .placementNotFound:
      return .placementNotFound
    }
  }

  /// The experiment of a `holdout`, `nil` for the other reasons.
  var pigeonExperiment: PExperiment? {
    if case .holdout(let experiment) = self {
      return experiment.pigeonify()
    }
    return nil
  }
}

extension CustomCallback {
  /// Sends the callback to Flutter with `send` and waits for its answer.
  /// A failed call counts as a failed callback.
  ///
  /// On the main actor because Flutter's channels must be used on the main
  /// thread, and an async function with no actor runs off it.
  @MainActor
  func forwardToFlutter(
    _ send: (PCustomCallback, @escaping (Result<PCustomCallbackResult, PigeonError>) -> Void) -> Void
  ) async -> CustomCallbackResult {
    let pCallback = PCustomCallback(
      name: name,
      variables: variables
    )

    return await withCheckedContinuation { continuation in
      send(pCallback) { pResult in
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
  }
}
