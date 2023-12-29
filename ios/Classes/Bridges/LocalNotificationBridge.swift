import Flutter
import SuperwallKit

extension LocalNotification {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["type"] = type.toJson()
    dict["title"] = title
    dict["subtitle"] = subtitle
    dict["body"] = body
    dict["delay"] = delay
    return dict
  }
}

extension LocalNotificationType {
  func toJson() -> String {
    switch self {
      case .trialStarted:
        return "trialStarted"
    }
  }
}
