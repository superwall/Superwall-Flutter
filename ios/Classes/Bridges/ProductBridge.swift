import Flutter
import SuperwallKit

extension Product {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["type"] = type.toJson()
    dict["id"] = id
    return dict
  }
}

extension ProductType {
  func toJson() -> String {
    switch self {
      case .primary:
        return "primary"
      case .secondary:
        return "secondary"
      case .tertiary:
        return "tertiary"
    }
  }
}
