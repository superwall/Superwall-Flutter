import Flutter
import SuperwallKit

extension PaywallInfo {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["identifier"] = identifier
    dict["experiment"] = experiment?.toJson()
    dict["triggerSessionId"] = triggerSessionId
    dict["products"] = products.map { $0.toJson() }
    dict["productIds"] = productIds
    dict["name"] = name
    dict["url"] = url.absoluteString
    dict["presentedByEventWithName"] = presentedByEventWithName
    dict["presentedByEventWithId"] = presentedByEventWithId
    dict["presentedByEventAt"] = presentedByEventAt
    dict["presentedBy"] = presentedBy
    dict["presentationSourceType"] = presentationSourceType
    dict["responseLoadStartTime"] = responseLoadStartTime
    dict["responseLoadCompleteTime"] = responseLoadCompleteTime
    dict["responseLoadFailTime"] = responseLoadFailTime
    dict["responseLoadDuration"] = responseLoadDuration
    dict["webViewLoadStartTime"] = webViewLoadStartTime
    dict["webViewLoadCompleteTime"] = webViewLoadCompleteTime
    dict["webViewLoadFailTime"] = webViewLoadFailTime
    dict["webViewLoadDuration"] = webViewLoadDuration
    dict["productsLoadStartTime"] = productsLoadStartTime
    dict["productsLoadCompleteTime"] = productsLoadCompleteTime
    dict["productsLoadFailTime"] = productsLoadFailTime
    dict["productsLoadDuration"] = productsLoadDuration
    dict["paywalljsVersion"] = paywalljsVersion
    dict["isFreeTrialAvailable"] = isFreeTrialAvailable
    dict["featureGatingBehavior"] = featureGatingBehavior.toJson()
    dict["closeReason"] = closeReason.toJson()
    dict["localNotifications"] = localNotifications.map { $0.toJson() }
    dict["computedPropertyRequests"] = computedPropertyRequests.map { $0.toJson() }
    dict["surveys"] = surveys.map { $0.toJson() }
    return dict
  }
}
