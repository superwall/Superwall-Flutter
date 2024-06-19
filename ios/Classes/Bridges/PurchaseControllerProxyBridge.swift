import Flutter
import StoreKit
import SuperwallKit

public class PurchaseControllerProxyBridge: BridgeInstance, PurchaseController {
  override class var bridgeClass: BridgeClass { "PurchaseControllerProxyBridge" }

  // MARK: - PurchaseController

  public func purchase(product: SKProduct) async -> PurchaseResult {
    print("Attempting to invoke purchaseFromAppStore method internally")

    guard let purchaseResultBridgeId = await communicator.asyncInvokeMethodOnMain("purchaseFromAppStore", arguments: ["productId": product.productIdentifier]) as? BridgeId else {
      print("WARNING: Failed to invoke purchaseFromAppStore")
      return .failed(PurchaseControllerProxyPluginError())
    }
    guard let purchaseResultBridge: PurchaseResultBridge = purchaseResultBridgeId.bridgeInstance() else {
      print("WARNING: Failed to get bridge instance")
      return .failed(PurchaseControllerProxyPluginError())
    }

    return purchaseResultBridge.purchaseResult
  }

  public func restorePurchases() async -> RestorationResult {
    print("Attempting to invoke restorePurchases method internally")
    guard let restorationResultBridgeId = await communicator.asyncInvokeMethodOnMain("restorePurchases") as? BridgeId else {
      print("WARNING: Failed to invoke restorePurchases")
      return .failed(PurchaseControllerProxyPluginError());
    }
    guard let restorationResultBridge: RestorationResultBridge = restorationResultBridgeId.bridgeInstance() else {
      print("WARNING: Failed to get bridge instance")
      return .failed(PurchaseControllerProxyPluginError())
    }

    return restorationResultBridge.restorationResult
  }
}

struct PurchaseControllerProxyPluginError: Error {}