import Flutter
import SuperwallKit

extension TransactionError {
  func toJson() -> [String: Any] {
    switch self {
      case .pending(let reason):
        return ["type": "pending", "reason": reason]
      case .failure(let message, let product):
        return [
          "type": "failure",
          "message": message,
          "product": product.toJson()
        ]
    }
  }
}
