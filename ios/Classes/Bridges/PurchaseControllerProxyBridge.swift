import Flutter
import StoreKit
import SuperwallKit

public class PurchaseControllerProxyBridge: BridgeInstance, PurchaseController {
  override class var bridgeClass: BridgeClass { "PurchaseControllerProxyBridge" }

  // MARK: - PurchaseController

  public func purchase(product: SKProduct) async -> PurchaseResult {
    guard 
      let purchaseResultBridgeId = await communicator.invokeMethod("purchaseFromAppStore", arguments: ["productId": product.productIdentifier]) as? BridgeId,
      let purchaseResultBridge: PurchaseResultBridge = purchaseResultBridgeId.bridgeInstance()
    else {
      print("WARNING: Unexpected result")
      return .failed(PurchaseControllerProxyPluginError())
    }

    return purchaseResultBridge.purchaseResult
  }

  public func restorePurchases() async -> RestorationResult {
    guard 
      let restorationResultBridgeId = await communicator.invokeMethod("restorePurchases") as? BridgeId,
      let restorationResultBridge: RestorationResultBridge = restorationResultBridgeId.bridgeInstance()
    else {
      print("WARNING: Unexpected result")
      return .failed(PurchaseControllerProxyPluginError())
    }

    return restorationResultBridge.restorationResult
  }
}

struct PurchaseControllerProxyPluginError: Error {}
