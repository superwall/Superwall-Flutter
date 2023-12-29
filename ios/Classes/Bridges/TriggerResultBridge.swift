import Flutter
import SuperwallKit

extension TriggerResult {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    switch self {
      case .eventNotFound:
        dict["type"] = "eventNotFound"
      case .noRuleMatch:
        dict["type"] = "noRuleMatch"
      case .paywall(let experiment):
        dict["type"] = "paywall"
        dict["experiment"] = experiment.toJson()
      case .holdout(let experiment):
        dict["type"] = "holdout"
        dict["experiment"] = experiment.toJson()
      case .error(let errorString):
        dict["type"] = "error"
        dict["errorDetail"] = errorString
    }
    return dict
  }
}
