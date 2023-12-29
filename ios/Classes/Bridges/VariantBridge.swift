import Flutter
import SuperwallKit

extension Experiment.Variant {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["id"] = id
    dict["type"] = type.toJson()
    dict["paywallId"] = paywallId
    return dict
  }
}

extension Experiment.Variant.VariantType {
  func toJson() -> String {
    switch self {
      case .treatment:
        return "treatment"
      case .holdout:
        return "holdout"
    }
  }
}

