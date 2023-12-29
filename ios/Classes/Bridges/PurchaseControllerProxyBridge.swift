import Flutter
import StoreKit
import SuperwallKit

public class PurchaseControllerProxyBridge: BaseBridge, PurchaseController {

  // MARK: - PurchaseController

  public func purchase(product: SKProduct) async -> PurchaseResult {
    guard let purchaseResult = await channel.invokeMethod("purchaseProduct", arguments: ["productId": product.productIdentifier]) as? [String: Any] else {
      print("WARNING: Unexpected result")
      return .failed(PurchaseControllerProxyPluginError())
    }

    return PurchaseResult.fromJson(dictionary: purchaseResult)
  }

  public func restorePurchases() async -> RestorationResult {
    guard let restorationResult = await channel.invokeMethod("restorePurchases") as? [String: Any] else {
      print("WARNING: Unexpected result")
      return .failed(PurchaseControllerProxyPluginError())
    }

    return RestorationResult.fromJson(dictionary: restorationResult)
  }
}

struct PurchaseControllerProxyPluginError: Error {}
struct PurchaseControllerProxyJsonError: Error {}

extension PurchaseResult {
  static func fromJson(dictionary: [String: Any]) -> PurchaseResult {
    guard let type = dictionary["type"] as? String else {
      return .failed(PurchaseControllerProxyJsonError())
    }

    switch type {
      case "cancelled":
        return .cancelled
      case "purchased":
        return .purchased
      case "restored":
        return .restored
      case "pending":
        return .pending
      case "failed":
        if let errorDescription = dictionary["error"] as? String {
          let error = NSError(domain: "PurchaseResultError", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
          return .failed(error)
        }

        return .failed(PurchaseControllerProxyJsonError())
      default:
        return .failed(PurchaseControllerProxyJsonError())
    }
  }
}

extension RestorationResult {
  static func fromJson(dictionary: [String: Any]) -> RestorationResult {
    guard let type = dictionary["type"] as? String else {
      return .failed(PurchaseControllerProxyJsonError())
    }

    switch type {
      case "restored":
        return .restored
      case "failed":
        if let errorDescription = dictionary["error"] as? String {
          // Create an Error object from the description.
          let error = NSError(domain: "RestorationResultError", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
          return .failed(error)
        }
      default:
        return .failed(PurchaseControllerProxyJsonError())
    }

    return .failed(PurchaseControllerProxyJsonError())
  }
}

