import SuperwallKit

extension EntitlementType {
  func toJson() -> String {
    switch self {
    case .serviceLevel:
      return "SERVICE_LEVEL"
    }
  }

  static func fromString(_ value: String) -> EntitlementType? {
    switch value {
    case "SERVICE_LEVEL":
      return .serviceLevel
    default:
      return nil
    }
  }
}
