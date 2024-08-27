import Flutter
import SuperwallKit

public class PaywallInfoBridge: BridgeInstance {
  class override var bridgeClass: BridgeClass { "PaywallInfoBridge" }

  var paywallInfo: PaywallInfo

  required init(bridgeId: BridgeId, initializationArgs: [String : Any]? = nil) {
    guard let paywallInfo = initializationArgs?["paywallInfo"] as? PaywallInfo else {
      fatalError("Attempting to create `PaywallInfoBridge` without providing `paywallInfo`.")
    }

    self.paywallInfo = paywallInfo
    super.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getIdentifier":
        let identifier = paywallInfo.identifier
        result(identifier)
      case "getExperimentBridgeId":
        let experimentBridgeId = paywallInfo.experiment?.createBridgeId()
        result(experimentBridgeId)
      case "getTriggerSessionId":
        let triggerSessionId = paywallInfo.triggerSessionId
        result(triggerSessionId)
      case "getProducts":
        let products = paywallInfo.products.map({ $0.toJson() })
        result(products)
      case "getProductIds":
        let productIds = paywallInfo.productIds
        result(productIds)
      case "getName":
        let name = paywallInfo.name
        result(name)
      case "getUrl":
        let url = paywallInfo.url.absoluteString
        result(url)
      case "getPresentedByEventWithName":
        let presentedByEventWithName = paywallInfo.presentedByEventWithName
        result(presentedByEventWithName)
      case "getPresentedByEventWithId":
        let presentedByEventWithId = paywallInfo.presentedByEventWithId
        result(presentedByEventWithId)
      case "getPresentedByEventAt":
        let presentedByEventAt = paywallInfo.presentedByEventAt
        result(presentedByEventAt)
      case "getPresentedBy":
        let presentedBy = paywallInfo.presentedBy
        result(presentedBy)
      case "getPresentationSourceType":
        let presentationSourceType = paywallInfo.presentationSourceType
        result(presentationSourceType)
      case "getResponseLoadStartTime":
        let responseLoadStartTime = paywallInfo.responseLoadStartTime
        result(responseLoadStartTime)
      case "getResponseLoadCompleteTime":
        let responseLoadCompleteTime = paywallInfo.responseLoadCompleteTime
        result(responseLoadCompleteTime)
      case "getResponseLoadFailTime":
        let responseLoadFailTime = paywallInfo.responseLoadFailTime
        result(responseLoadFailTime)
      case "getResponseLoadDuration":
        let responseLoadDuration = paywallInfo.responseLoadDuration
        result(responseLoadDuration)
      case "getWebViewLoadStartTime":
        let webViewLoadStartTime = paywallInfo.webViewLoadStartTime
        result(webViewLoadStartTime)
      case "getWebViewLoadCompleteTime":
        let webViewLoadCompleteTime = paywallInfo.webViewLoadCompleteTime
        result(webViewLoadCompleteTime)
      case "getWebViewLoadFailTime":
        let webViewLoadFailTime = paywallInfo.webViewLoadFailTime
        result(webViewLoadFailTime)
      case "getWebViewLoadDuration":
        let webViewLoadDuration = paywallInfo.webViewLoadDuration
        result(webViewLoadDuration)
      case "getProductsLoadStartTime":
        let productsLoadStartTime = paywallInfo.productsLoadStartTime
        result(productsLoadStartTime)
      case "getProductsLoadCompleteTime":
        let productsLoadCompleteTime = paywallInfo.productsLoadCompleteTime
        result(productsLoadCompleteTime)
      case "getProductsLoadFailTime":
        let productsLoadFailTime = paywallInfo.productsLoadFailTime
        result(productsLoadFailTime)
      case "getProductsLoadDuration":
        let productsLoadDuration = paywallInfo.productsLoadDuration
        result(productsLoadDuration)
      case "getPaywalljsVersion":
        let paywalljsVersion = paywallInfo.paywalljsVersion
        result(paywalljsVersion)
      case "getIsFreeTrialAvailable":
        let isFreeTrialAvailable = paywallInfo.isFreeTrialAvailable
        result(isFreeTrialAvailable)
      case "getFeatureGatingBehavior":
        let featureGatingBehavior = paywallInfo.featureGatingBehavior.toJson()
        result(featureGatingBehavior)
      case "getCloseReason":
        let closeReason = paywallInfo.closeReason.toJson()
        result(closeReason)
      case "getLocalNotifications":
        let localNotifications = paywallInfo.localNotifications.map({ $0.toJson() })
        result(localNotifications)
      case "getComputedPropertyRequests":
        let computedPropertyRequests = paywallInfo.computedPropertyRequests.map({ $0.toJson() })
        result(computedPropertyRequests)
      case "getSurveys":
        let surveys = paywallInfo.surveys.map({ $0.toJson() })
        result(surveys)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

extension PaywallInfo {
  func createBridgeId() -> BridgeId {
    let instance = BridgingCreator.shared.createBridgeInstance(bridgeClass: PaywallInfoBridge.bridgeClass, initializationArgs: ["paywallInfo": self])
    let bridge = instance as! PaywallInfoBridge
    bridge.paywallInfo = self
    return bridge.bridgeId
  }
}
