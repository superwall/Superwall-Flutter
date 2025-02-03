import SuperwallKit

extension Entitlement {
  func toJson() -> [String: Any] {
    return [
      "id": id,
      "type": type.toJson(),
    ]
  }

  static func fromJson(_ json: [String: Any]) -> Entitlement? {
    guard let id = json["id"] as? String else {
      return nil
    }

    // TODO: Need to expose init with type for the future.
    return Entitlement(id: id)
  }
}
