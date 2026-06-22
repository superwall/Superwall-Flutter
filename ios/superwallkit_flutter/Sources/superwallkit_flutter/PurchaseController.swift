import SuperwallKit
import Foundation

final class PurchaseControllerHost: NSObject, PurchaseController {
  private let flutterController: () -> PPurchaseControllerGenerated
  
  init(flutterController: @escaping () -> PPurchaseControllerGenerated) {
    self.flutterController = flutterController
    super.init()
  }
  
  @MainActor
  func purchase(product: StoreProduct) async -> PurchaseResult {
    return await withCheckedContinuation { continuation in
      flutterController().purchaseFromAppStore(productId: product.productIdentifier) { result in
        switch result {
        case .success(let purchaseResult):
          if purchaseResult is PPurchasePurchased {
            continuation.resume(returning: .purchased)
          } else if purchaseResult is PPurchasePending {
            continuation.resume(returning: .pending)
          } else if purchaseResult is PPurchaseCancelled {
            continuation.resume(returning: .cancelled)
          } else if let failed = purchaseResult as? PPurchaseFailed {
            let error = NSError(domain: "com.superwall.flutter", code: 0, userInfo: [NSLocalizedDescriptionKey: failed.error ?? "Unknown error"])
            continuation.resume(returning: .failed(error))
          } else {
            let error = NSError(domain: "com.superwall.flutter", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown purchase result"])
            continuation.resume(returning: .failed(error))
          }
        case .failure(let error):
          continuation.resume(returning: .failed(error))
        }
      }
    }
  }
  
  @MainActor
  func restorePurchases() async -> RestorationResult {
    return await withCheckedContinuation { continuation in
      flutterController().restorePurchases { result in
        switch result {
        case .success(let restorationResult):
          if restorationResult is PRestorationRestored {
            continuation.resume(returning: .restored)
          } else if let failed = restorationResult as? PRestorationFailed {
            let error = NSError(domain: "com.superwall.flutter", code: 0, userInfo: [NSLocalizedDescriptionKey: failed.error ?? "Unknown error"])
            continuation.resume(returning: .failed(error))
          } else {
            let error = NSError(domain: "com.superwall.flutter", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown restoration result"])
            continuation.resume(returning: .failed(error))
          }
        case .failure(let error):
          continuation.resume(returning: .failed(error))
        }
      }
    }
  }
}
