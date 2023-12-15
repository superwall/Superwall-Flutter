import Flutter
import SuperwallKit

public class PaywallInfoBridge: BaseBridge {
  // TODO
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getPaywallInfo" {
//      let paywallInfo: 
//      let data: [String: Any?] = [
//        "identifier": paywallInfo.identifier,
//        "experiment": paywallInfo.experiment, // Make sure to convert to a suitable format
//        "triggerSessionId": paywallInfo.triggerSessionId,
//        "products": paywallInfo.products.map { $0.identifier }, // Assuming Product has an identifier
//        "productIds": paywallInfo.productIds,
//        "name": paywallInfo.name,
//        "url": paywallInfo.url.absoluteString,
//        // ... map other fields
//      ]
      result(FlutterMethodNotImplemented)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
