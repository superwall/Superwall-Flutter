import Flutter
import SuperwallKit

extension TransactionProduct {
  func toJson() -> [String: Any] {
    return ["id": id]
  }
}
