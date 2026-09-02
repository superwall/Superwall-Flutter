
import Foundation
import SuperwallKit

extension PaywallPresentationRequestStatusReason {
  func pigeonify() -> PPaywallPresentationRequestStatusReason {
    switch self {
    case .debuggerPresented:
      return PStatusReasonDebuggerPresented()
    case .paywallAlreadyPresented:
      return PStatusReasonPaywallAlreadyPresented()
    case .holdout(let experiment):
      return PStatusReasonHoldout(experiment: experiment.pigeonify())
    case .noAudienceMatch:
      return PStatusReasonNoAudienceMatch()
    case .placementNotFound:
      return PStatusReasonPlacementNotFound()
    case .noPaywallViewController:
      return PStatusReasonNoPaywallVc()
    case .noPresenter:
      return PStatusReasonNoPresenter()
    case .noConfig:
      return PStatusReasonNoConfig()
    case .subscriptionStatusTimeout:
      return PStatusReasonSubsStatusTimeout()
    }
  }
}
