import SuperwallKit

extension ComputedPropertyRequest {
  func toJson() -> [String: Any] {
    return [
      "type": type.description,
      "placementName": placementName
    ]
  }
}
