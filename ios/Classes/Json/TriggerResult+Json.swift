import SuperwallKit

extension TriggerResult {
  func toJson() -> [String: Any] {
    switch self {
    case .placementNotFound:
      return ["result": "placementNotFound"]
    case .noAudienceMatch:
      return ["result": "noAudienceMatch"]
    case .paywall(let experiment):
      return ["result": "paywall", "experimentBridgeId": experiment.createBridgeId()]
    case .holdout(let experiment):
      return ["result": "holdout", "experimentBridgeId": experiment.createBridgeId()]
    case .error(let error):
      return ["result": "error", "error": error.localizedDescription]
    }
  }
}
