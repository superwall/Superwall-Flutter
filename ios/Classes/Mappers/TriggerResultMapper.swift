import Foundation
import SuperwallKit

extension TriggerResult {
  func pigeonify() -> PTriggerResult {
    switch self {
    case .placementNotFound:
      return PPlacementNotFoundTriggerResult()
    case .noAudienceMatch:
      return PNoAudienceMatchTriggerResult()
    case .paywall(let experiment):
      return PPaywallTriggerResult(experiment: experiment.pigeonify())
    case .holdout(let experiment):
      return PHoldoutTriggerResult(experiment: experiment.pigeonify())
    case .error(let nSError):
      return PErrorTriggerResult(error: nSError.localizedDescription)
    }
  }
}

extension Experiment {
  func pigeonify() -> PExperiment {
    return PExperiment(
      id: id,
      groupId: groupId,
      variant: variant.pigeonify()
    )
  }
}

extension Experiment.Variant {
  func pigeonify() -> PVariant {
    return PVariant(id: id, type: type.pigeonify())
  }
}

extension Experiment.Variant.VariantType {
  func pigeonify() -> PVariantType {
    switch self {
    case .holdout:
      return .holdout
    case .treatment:
      return .treatment
    }
  }
}
