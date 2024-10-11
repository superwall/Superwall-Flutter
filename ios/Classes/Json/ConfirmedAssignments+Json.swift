import SuperwallKit

extension ConfirmedAssignment {
  func toJson() -> [String: Any] {
    return [
      "experimentId": self.experimentId,
      "variant": self.variant.toJson()
    ]
  }
}

extension Experiment.Variant {
  func toJson() -> [String: Any] {
    return [
      "id": self.id,
      "type": self.type.toJson(),
      "paywallId": self.paywallId
    ]
  }
}

extension Experiment.Variant.VariantType {
  func toJson() -> String {
    switch self {
    case .treatment:
      return "TREATMENT"
    case .holdout:
      return "HOLDOUT"
    }
  }
}
