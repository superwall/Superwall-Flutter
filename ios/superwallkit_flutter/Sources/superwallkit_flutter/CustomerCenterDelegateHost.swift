import Foundation
import SuperwallKit

/// Forwards Customer Center delegate callbacks to the Flutter delegate registered for one
/// presentation. The SDK calls every method on the main actor, which Pigeon requires.
@MainActor
final class CustomerCenterDelegateHost: CustomerCenterDelegate {
  private let flutterDelegate: PCustomerCenterDelegateGenerated

  init(flutterDelegate: PCustomerCenterDelegateGenerated) {
    self.flutterDelegate = flutterDelegate
  }

  func customerCenterShouldRestorePurchases() async -> Bool {
    return await withCheckedContinuation { continuation in
      flutterDelegate.shouldRestorePurchases { result in
        // Restore by default if Flutter couldn't answer, matching the SDK's default.
        switch result {
        case .success(let shouldRestore):
          continuation.resume(returning: shouldRestore)
        case .failure:
          continuation.resume(returning: true)
        }
      }
    }
  }

  func customerCenterDidSelectAction(
    _ action: CustomerCenterAction,
    pathId: String,
    purchase: CustomerCenterPurchase?
  ) {
    flutterDelegate.didSelectAction(
      action: action.pigeonify(),
      pathId: pathId,
      purchase: purchase?.pigeonify()
    ) { _ in }
  }

  func customerCenterDidCompleteSurvey(
    surveyId: String,
    optionId: String,
    action: CustomerCenterAction,
    pathId: String
  ) {
    flutterDelegate.didCompleteSurvey(
      surveyId: surveyId,
      optionId: optionId,
      action: action.pigeonify(),
      pathId: pathId
    ) { _ in }
  }

  func customerCenterDidCompleteRefundRequest(
    productId: String,
    status: CustomerCenterRefundStatus
  ) {
    flutterDelegate.didCompleteRefundRequest(
      productId: productId,
      status: status.pigeonify()
    ) { _ in }
  }

  func customerCenterDidDismiss() {
    flutterDelegate.didDismiss { _ in }
  }

  func onDismiss() {
    flutterDelegate.onDismiss { _ in }
  }
}
