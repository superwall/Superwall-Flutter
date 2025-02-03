import SuperwallKit

extension EntitlementsInfo {
  func toJson() -> [String: Any] {
    return [
      "active": active.map { $0.toJson() },
      "inactive": inactive.map { $0.toJson() },
      "all": all.map { $0.toJson() },
    ]
  }
}
