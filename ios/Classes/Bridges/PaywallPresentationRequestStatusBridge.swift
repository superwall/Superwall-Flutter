import Flutter
import SuperwallKit

extension PaywallPresentationRequestStatus {
  func toJson() -> String {
    switch self {
      case .presentation:
        return "presentation"
      case .noPresentation:
        return "no_presentation"
      case .timeout:
        return "timeout"
    }
  }
}

extension PaywallPresentationRequestStatusReason {
  func toJson() -> [String: Any?] {
    switch self {
      case .debuggerPresented:
        return ["type": "debuggerPresented"]
      case .paywallAlreadyPresented:
        return ["type": "paywallAlreadyPresented"]
      case .userIsSubscribed:
        return ["type": "userIsSubscribed"]
      case .holdout(let experiment):
        return ["type": "holdout", "experiment": experiment.toJson()]
      case .noRuleMatch:
        return ["type": "noRuleMatch"]
      case .eventNotFound:
        return ["type": "eventNotFound"]
      case .noPaywallViewController:
        return ["type": "noPaywallViewController"]
      case .noPresenter:
        return ["type": "noPresenter"]
      case .noConfig:
        return ["type": "noConfig"]
      case .subscriptionStatusTimeout:
        return ["type": "subscriptionStatusTimeout"]
    }
  }
}
