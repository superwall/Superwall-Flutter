import SuperwallKit

extension SuperwallEventInfo {
  func toJson() -> [String: Any] {
      return [
          "event": event.toJson(),
          "params": params
      ]
  }
}

extension SuperwallEvent {
  func toJson() -> [String: Any] {
    switch self {
      case .firstSeen:
        return ["event": "firstSeen"]
      case .appOpen:
        return ["event": "appOpen"]
      case .appLaunch:
        return ["event": "appLaunch"]
        case .identityAlias:
        return ["event": "identityAlias"]
      case .appInstall:
        return ["event": "appInstall"]
      case .sessionStart:
        return ["event": "sessionStart"]
      case .deviceAttributes(let attributes):
        return ["event": "deviceAttributes", "attributes": attributes]
      case .subscriptionStatusDidChange:
        return ["event": "subscriptionStatusDidChange"]
      case .appClose:
        return ["event": "appClose"]
      case .deepLink(let url):
        return ["event": "deepLink", "url": url.absoluteString]
      case .triggerFire(let eventName, let result):
        return ["event": "triggerFire", "eventName": eventName, "result": result.toJson()]
      case .paywallOpen(let paywallInfo):
        return ["event": "paywallOpen", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallClose(let paywallInfo):
        return ["event": "paywallClose", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallDecline(let paywallInfo):
        return ["event": "paywallDecline", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .transactionStart(let product, let paywallInfo):
        return ["event": "transactionStart", "product": product.toJson(), "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .transactionFail(let error, let paywallInfo):
        return ["event": "transactionFail", "error": error.localizedDescription, "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .transactionAbandon(let product, let paywallInfo):
        return ["event": "transactionAbandon", "product": product.toJson(), "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .transactionComplete(let transaction, let product, let paywallInfo):
        var json: [String: Any] = ["event": "transactionComplete", "product": product.toJson(), "paywallInfoBridgeId": paywallInfo.createBridgeId()]
        let transactionJson = transaction?.toJson()
        if let transactionJson {
          json["transaction"] = transactionJson
        }
        return json
      case .subscriptionStart(let product, let paywallInfo):
        return ["event": "subscriptionStart", "product": product.toJson(), "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .freeTrialStart(let product, let paywallInfo):
        return ["event": "freeTrialStart", "product": product.toJson(), "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .transactionRestore(let restoreType, let paywallInfo):
        return ["event": "transactionRestore", "restoreType": restoreType.toJson(), "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .transactionTimeout(let paywallInfo):
        return ["event": "transactionTimeout", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .userAttributes(let attributes):
        return ["event": "userAttributes", "attributes": attributes]
      case .nonRecurringProductPurchase(let product, let paywallInfo):
        return ["event": "nonRecurringProductPurchase", "product": product.toJson(), "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallResponseLoadStart(let triggeredEventName):
        return ["event": "paywallResponseLoadStart", "triggeredEventName": triggeredEventName ?? ""]
      case .paywallResponseLoadNotFound(let triggeredEventName):
        return ["event": "paywallResponseLoadNotFound", "triggeredEventName": triggeredEventName ?? ""]
      case .paywallResponseLoadFail(let triggeredEventName):
        return ["event": "paywallResponseLoadFail", "triggeredEventName": triggeredEventName ?? ""]
      case .paywallResponseLoadComplete(let triggeredEventName, let paywallInfo):
        return ["event": "paywallResponseLoadComplete", "triggeredEventName": triggeredEventName ?? "", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallWebviewLoadStart(let paywallInfo):
        return ["event": "paywallWebviewLoadStart", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallWebviewLoadFail(let paywallInfo):
        return ["event": "paywallWebviewLoadFail", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallWebviewLoadComplete(let paywallInfo):
        return ["event": "paywallWebviewLoadComplete", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallWebviewLoadTimeout(let paywallInfo):
        return ["event": "paywallWebviewLoadTimeout", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallProductsLoadStart(let triggeredEventName, let paywallInfo):
        return ["event": "paywallProductsLoadStart", "triggeredEventName": triggeredEventName ?? "", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallProductsLoadFail(let triggeredEventName, let paywallInfo):
        return ["event": "paywallProductsLoadFail", "triggeredEventName": triggeredEventName ?? "", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallProductsLoadComplete(let triggeredEventName):
        return ["event": "paywallProductsLoadComplete", "triggeredEventName": triggeredEventName ?? ""]
      case .surveyResponse(let survey, let selectedOption, let customResponse, let paywallInfo):
        return ["event": "surveyResponse", "survey": survey.toJson(), "selectedOption": selectedOption.toJson(), "customResponse": customResponse ?? "", "paywallInfoBridgeId": paywallInfo.createBridgeId()]
      case .paywallPresentationRequest(let status, let reason):
        var json: [String: Any] = ["event": "paywallPresentationRequest", "status": status.toJson()]
        let reasonJson = reason?.toJson()
        if let reasonJson {
          json["reason"] = reasonJson
        }
        return json
      case .touchesBegan:
        return ["event": "touchesBegan"]
      case .surveyClose:
        return ["event": "surveyClose"]
      case .reset:
        return ["event": "reset"]
    }
  }
}
