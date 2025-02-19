import SuperwallKit

extension SuperwallPlacementInfo {
  func toJson() -> [String: Any] {
    return [
      "placement": placement.toJson(),
      "params": params,
    ]
  }
}

extension SuperwallPlacement {
  func toJson() -> [String: Any] {
    switch self {
    case .firstSeen:
      return ["placement": "firstSeen"]
    case .appOpen:
      return ["placement": "appOpen"]
    case .appLaunch:
      return ["placement": "appLaunch"]
    case .identityAlias:
      return ["placement": "identityAlias"]
    case .appInstall:
      return ["placement": "appInstall"]
    case .sessionStart:
      return ["placement": "sessionStart"]
    case .deviceAttributes(let attributes):
      return ["placement": "deviceAttributes", "attributes": attributes]
    case .subscriptionStatusDidChange:
      return ["placement": "subscriptionStatusDidChange"]
    case .appClose:
      return ["placement": "appClose"]
    case .restoreStart:
      return ["placement": "restoreStart"]
    case .restoreComplete:
      return ["placement": "restoreComplete"]
    case .restoreFail(let message):
      return ["placement": "restoreFail", "message": message]
    case .deepLink(let url):
      return ["placement": "deepLink", "url": url.absoluteString]
    case .triggerFire(let placementName, let result):
      return [
        "placement": "triggerFire", "placementName": placementName, "result": result.toJson(),
      ]
    case .paywallOpen(let paywallInfo):
      return ["placement": "paywallOpen", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
    case .paywallClose(let paywallInfo):
      return ["placement": "paywallClose", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
    case .paywallDecline(let paywallInfo):
      return ["placement": "paywallDecline", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
    case .transactionStart(let product, let paywallInfo):
      return [
        "placement": "transactionStart", "product": product.toJson(),
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .transactionFail(let error, let paywallInfo):
      return [
        "placement": "transactionFail", "error": error.localizedDescription,
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .transactionAbandon(let product, let paywallInfo):
      return [
        "placement": "transactionAbandon", "product": product.toJson(),
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .transactionComplete(let transaction, let product, let type, let paywallInfo):
      var json: [String: Any] = [
        "placement": "transactionComplete", "product": product.toJson(),
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
      let transactionJson = transaction?.toJson()
      if let transactionJson {
        json["transaction"] = transactionJson
      }
      return json
    case .subscriptionStart(let product, let paywallInfo):
      return [
        "placement": "subscriptionStart", "product": product.toJson(),
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .freeTrialStart(let product, let paywallInfo):
      return [
        "placement": "freeTrialStart", "product": product.toJson(),
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .transactionRestore(let restoreType, let paywallInfo):
      return [
        "placement": "transactionRestore", "restoreType": restoreType.toJson(),
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .transactionTimeout(let paywallInfo):
      return [
        "placement": "transactionTimeout", "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .userAttributes(let attributes):
      return ["placement": "userAttributes", "attributes": attributes]
    case .nonRecurringProductPurchase(let product, let paywallInfo):
      return [
        "placement": "nonRecurringProductPurchase", "product": product.toJson(),
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallResponseLoadStart(let triggeredPlacementName):
      return [
        "placement": "paywallResponseLoadStart",
        "triggeredPlacementName": triggeredPlacementName ?? "",
      ]
    case .paywallResponseLoadNotFound(let triggeredPlacementName):
      return [
        "placement": "paywallResponseLoadNotFound",
        "triggeredPlacementName": triggeredPlacementName ?? "",
      ]
    case .paywallResponseLoadFail(let triggeredPlacementName):
      return [
        "placement": "paywallResponseLoadFail",
        "triggeredPlacementName": triggeredPlacementName ?? "",
      ]
    case .paywallResponseLoadComplete(let triggeredPlacementName, let paywallInfo):
      return [
        "placement": "paywallResponseLoadComplete",
        "triggeredPlacementName": triggeredPlacementName ?? "",
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallWebviewLoadStart(let paywallInfo):
      return [
        "placement": "paywallWebviewLoadStart", "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallWebviewLoadFail(let paywallInfo):
      return [
        "placement": "paywallWebviewLoadFail", "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallWebviewLoadComplete(let paywallInfo):
      return [
        "placement": "paywallWebviewLoadComplete",
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallWebviewLoadTimeout(let paywallInfo):
      return [
        "placement": "paywallWebviewLoadTimeout",
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallProductsLoadStart(let triggeredPlacementName, let paywallInfo):
      return [
        "placement": "paywallProductsLoadStart",
        "triggeredPlacementName": triggeredPlacementName ?? "",
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallProductsLoadFail(let triggeredPlacementName, let paywallInfo):
      return [
        "placement": "paywallProductsLoadFail",
        "triggeredPlacementName": triggeredPlacementName ?? "",
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallProductsLoadComplete(let triggeredPlacementName):
      return [
        "placement": "paywallProductsLoadComplete",
        "triggeredPlacementName": triggeredPlacementName ?? "",
      ]
    case .surveyResponse(let survey, let selectedOption, let customResponse, let paywallInfo):
      return [
        "placement": "surveyResponse", "survey": survey.toJson(),
        "selectedOption": selectedOption.toJson(), "customResponse": customResponse ?? "",
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallPresentationRequest(let status, let reason):
      var json: [String: Any] = [
        "placement": "paywallPresentationRequest", "status": status.toJson(),
      ]
      let reasonJson = reason?.toJson()
      if let reasonJson {
        json["reason"] = reasonJson
      }
      return json
    case .touchesBegan:
      return ["placement": "touchesBegan"]
    case .surveyClose:
      return ["placement": "surveyClose"]
    case .reset:
      return ["placement": "reset"]
    case .paywallWebviewLoadFallback(let paywallInfo):
      return [
        "placement": "paywallWebviewLoadFallback",
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .paywallProductsLoadRetry(let triggeredPlacementName, let paywallInfo, let attempt):
      return [
        "placement": "paywallProductsLoadRetry",
        "triggeredPlacementName": triggeredPlacementName ?? "",
        "attempt": attempt, "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .configRefresh:
      return ["placement": "configRefresh"]
    case .customPlacement(let name, let params, let paywallInfo):
      return [
        "placement": "customPlacement", "name": name, "params": params,
        "paywallInfoBridgeId": paywallInfo.createBridgeId(),
      ]
    case .configAttributes:
      return ["placement": "configAttributes"]
    case .confirmAllAssignments:
      return ["placement": "confirmAllAssignments"]
    case .configFail:
      return ["placement": "configFail"]
    case .adServicesTokenRequestStart:
      return ["placement": "adServicesTokenRequestStart"]
    case .adServicesTokenRequestFail(let error):
      return ["placement": "adServicesTokenRequestFail", "error": error.localizedDescription]
    case .adServicesTokenRequestComplete(let token):
      return ["placement": "adServicesTokenRequestComplete", "token": token]
    case .shimmerViewStart:
      return ["placement": "shimmerViewStart"]
    case .shimmerViewComplete:
      return ["placement": "shimmerViewComplete"]
    }
  }
}
