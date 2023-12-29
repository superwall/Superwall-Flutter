import Flutter
import SuperwallKit

extension PaywallSkippedReason {
  func toJson() -> [String: Any] {
    switch self {
      case .holdout(let experiment):
        return ["type": "holdout", "experiment": experiment.toJson()]
      case .noRuleMatch:
        return ["type": "noRuleMatch"]
      case .eventNotFound:
        return ["type": "eventNotFound"]
      case .userIsSubscribed:
        return ["type": "userIsSubscribed"]
    }
  }
}

