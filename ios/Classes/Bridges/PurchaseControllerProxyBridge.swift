import Flutter
import StoreKit
import UIKit
import SuperwallKit

extension PurchaseControllerProxyBridge: FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {}
}

public class PurchaseControllerProxyBridge: NSObject, Bridgeable, PurchaseController {
  static let name: String = "PurchaseControllerProxyBridge"

  let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  // MARK: - PurchaseController

  public func purchase(product: SKProduct) async -> PurchaseResult {
    guard let purchaseResultString = await channel.invokeMethod("purchaseProduct", arguments: ["productId": product.productIdentifier]) as? String else {
      print("WARNING: Unexpected result")
      return .failed(PurchaseControllerProxyPluginError())
    }

    // TODO: purchaseResultString

    return .purchased
  }

  public func restorePurchases() async -> RestorationResult {
    guard let restorationResultString = await channel.invokeMethod("restorationResult") as? String else {
      print("WARNING: Unexpected result")
      return .failed(PurchaseControllerProxyPluginError())
    }

    // TODO: restorationResultString

    return .restored
  }
}

struct PurchaseControllerProxyPluginError: Error {}
