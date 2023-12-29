import Flutter
import SuperwallKit

extension RestoreType {
  func toJson() -> [String: Any?] {
    switch self {
      case .viaPurchase(let transaction):
        return ["type": "viaPurchase", "transaction": transaction?.toJson()]
      case .viaRestore:
        return ["type": "viaRestore"]
    }
  }
}
