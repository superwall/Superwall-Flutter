package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.paywall.presentation.PaywallInfo
import toJson

fun PaywallInfo.toJson(): Map<String, Any?> {
    val json = mutableMapOf<String, Any?>()
    json["databaseId"] = databaseId
    json["identifier"] = identifier
    json["experiment"] = experiment?.toJson()
    json["triggerSessionId"] = triggerSessionId
    json["products"] = products.map { it.toJson() }
    json["productIds"] = productIds
    json["name"] = name
    json["url"] = url.toString()
    json["presentedByEventWithName"] = presentedByEventWithName
    json["presentedByEventWithId"] = presentedByEventWithId
    json["presentedByEventAt"] = presentedByEventAt
    json["presentedBy"] = presentedBy
    json["presentationSourceType"] = presentationSourceType
    json["responseLoadStartTime"] = responseLoadStartTime
    json["responseLoadCompleteTime"] = responseLoadCompleteTime
    json["responseLoadFailTime"] = responseLoadFailTime
    json["responseLoadDuration"] = responseLoadDuration
    json["webViewLoadStartTime"] = webViewLoadStartTime
    json["webViewLoadCompleteTime"] = webViewLoadCompleteTime
    json["webViewLoadFailTime"] = webViewLoadFailTime
    json["webViewLoadDuration"] = webViewLoadDuration
    json["productsLoadStartTime"] = productsLoadStartTime
    json["productsLoadCompleteTime"] = productsLoadCompleteTime
    json["productsLoadFailTime"] = productsLoadFailTime
    json["productsLoadDuration"] = productsLoadDuration
    json["paywalljsVersion"] = paywalljsVersion
    json["isFreeTrialAvailable"] = isFreeTrialAvailable
    json["featureGatingBehavior"] = featureGatingBehavior.toJson()
    json["closeReason"] = closeReason?.toJson()
//     json["localNotifications"] = localNotifications.map { it.toJson() }
//     json["computedPropertyRequests"] = computedPropertyRequests.map { it.toJson() }
    json["surveys"] = surveys.map { it.toJson() }
    return json
}