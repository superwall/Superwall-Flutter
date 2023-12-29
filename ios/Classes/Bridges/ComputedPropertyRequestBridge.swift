import Flutter
import SuperwallKit

extension ComputedPropertyRequest {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["type"] = type.toJson()
    dict["eventName"] = eventName
    return dict
  }
}

extension ComputedPropertyRequest.ComputedPropertyRequestType {
  func toJson() -> String {
    switch self {
      case .minutesSince:
        return "minutesSince"
      case .hoursSince:
        return "hoursSince"
      case .daysSince:
        return "daysSince"
      case .monthsSince:
        return "monthsSince"
      case .yearsSince:
        return "yearsSince"
    }
  }
}
