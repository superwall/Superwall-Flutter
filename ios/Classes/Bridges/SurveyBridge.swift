import Flutter
import SuperwallKit

extension Survey {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["id"] = id
    dict["assignmentKey"] = assignmentKey
    dict["title"] = title
    dict["message"] = message
    dict["options"] = options.map { $0.toJson() }
    dict["presentationCondition"] = presentationCondition.toJson()
    dict["presentationProbability"] = presentationProbability
    dict["includeOtherOption"] = includeOtherOption
    dict["includeCloseOption"] = includeCloseOption
    return dict
  }
}

extension SurveyOption {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["id"] = id
    dict["title"] = title
    return dict
  }
}

extension SurveyShowCondition {
  func toJson() -> String {
    switch self {
      case .onManualClose:
        return "onManualClose"
      case .onPurchase:
        return "onPurchase"
    }
  }
}


