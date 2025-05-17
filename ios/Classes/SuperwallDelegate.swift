import Foundation
import SuperwallKit

final class SuperwallDelegateHost: SuperwallDelegate {
  private let flutterDelegate: () -> PSuperwallDelegateGenerated

  init(flutterDelegate: @escaping () -> PSuperwallDelegateGenerated) {
    self.flutterDelegate = flutterDelegate
  }

  func subscriptionStatusDidChange(
    from oldValue: SubscriptionStatus, to newValue: SubscriptionStatus
  ) {
    let oldStatus: PSubscriptionStatus
    switch oldValue {
    case .active(let entitlements):
      oldStatus = PActive(entitlements: entitlements.map { PEntitlement(id: $0.id) })
    case .inactive:
      oldStatus = PInactive(ignore: false)
    case .unknown:
      oldStatus = PUnknown(ignore: false)
    }

    let newStatus: PSubscriptionStatus
    switch newValue {
    case .active(let entitlements):
      newStatus = PActive(entitlements: entitlements.map { PEntitlement(id: $0.id) })
    case .inactive:
      newStatus = PInactive(ignore: false)
    case .unknown:
      newStatus = PUnknown(ignore: false)
    }

    flutterDelegate().subscriptionStatusDidChange(from: oldStatus, to: newStatus) { result in
      // NO-OP
    }
  }

  func handleSuperwallEvent(withInfo eventInfo: SuperwallEventInfo) {
    let pEventInfo: PSuperwallEventInfo

    switch eventInfo.event {
    case .firstSeen:
      pEventInfo = PSuperwallEventInfo(eventType: .firstSeen)
    case .appOpen:
      pEventInfo = PSuperwallEventInfo(eventType: .appOpen)
    case .appLaunch:
      pEventInfo = PSuperwallEventInfo(eventType: .appLaunch)
    case .identityAlias:
      pEventInfo = PSuperwallEventInfo(eventType: .identityAlias)
    case .appInstall:
      pEventInfo = PSuperwallEventInfo(eventType: .appInstall)
    case .sessionStart:
      pEventInfo = PSuperwallEventInfo(eventType: .sessionStart)
    case .deviceAttributes(let attributes):
      pEventInfo = PSuperwallEventInfo(
        eventType: .deviceAttributes,
        deviceAttributes: attributes
      )
    case .subscriptionStatusDidChange:
      pEventInfo = PSuperwallEventInfo(eventType: .subscriptionStatusDidChange)
    case .appClose:
      pEventInfo = PSuperwallEventInfo(eventType: .appClose)
    case .deepLink(let url):
      pEventInfo = PSuperwallEventInfo(
        eventType: .deepLink,
        deepLinkUrl: url.absoluteString
      )
    case .triggerFire(let placementName, let result):
      pEventInfo = PSuperwallEventInfo(
        eventType: .triggerFire,
        placementName: placementName,
        result: result.pigeonify()
      )
    case .paywallOpen(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallOpen,
        paywallInfo: paywallInfo.pigeonify()
      )
    case .paywallClose(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallClose,
        paywallInfo: paywallInfo.pigeonify()
      )
    case .paywallDecline(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallDecline,
        paywallInfo: paywallInfo.pigeonify()
      )
    case .transactionStart(let product, let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .transactionStart,
        paywallInfo: paywallInfo.pigeonify(),
        product: product.pigeonify()
      )
    case .transactionFail(let error, let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .transactionFail,
        paywallInfo: paywallInfo.pigeonify(),
        error: error.localizedDescription
      )
    case .transactionAbandon(let product, let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .transactionAbandon,
        paywallInfo: paywallInfo.pigeonify(),
        product: product.pigeonify()
      )
    case let .transactionComplete(transaction, product, type, paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .transactionComplete,
        paywallInfo: paywallInfo.pigeonify(),
        transaction: transaction?.pigeonify(),
        product: product.pigeonify()
      )
      // TODO: Add type
    case .subscriptionStart(let product, let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .subscriptionStart,
        paywallInfo: paywallInfo.pigeonify(),
        product: product.pigeonify()
      )
    case .freeTrialStart(let product, let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .freeTrialStart,
        paywallInfo: paywallInfo.pigeonify(),
        product: product.pigeonify()
      )
    case .transactionRestore(let restoreType, let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .transactionComplete,
        paywallInfo: paywallInfo.pigeonify(),
        restoreType: restoreType.pigeonify()
      )
    case .transactionTimeout(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .transactionTimeout,
        paywallInfo: paywallInfo.pigeonify()
      )
    case .userAttributes(let attributes):
      pEventInfo = PSuperwallEventInfo(
        eventType: .userAttributes,
        userAttributes: attributes
      )
    case .nonRecurringProductPurchase(let product, let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .nonRecurringProductPurchase,
        paywallInfo: paywallInfo.pigeonify()
      )
      // TODO: Add product
    case .paywallResponseLoadStart(let triggeredPlacementName):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallResponseLoadStart,
        triggeredPlacementName: triggeredPlacementName
      )
    case .paywallResponseLoadNotFound(let triggeredPlacementName):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallResponseLoadNotFound,
        triggeredPlacementName: triggeredPlacementName
      )
    case .paywallResponseLoadFail(let triggeredPlacementName):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallResponseLoadFail,
        triggeredPlacementName: triggeredPlacementName
      )
    case .paywallResponseLoadComplete(let triggeredPlacementName, let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallResponseLoadComplete,
        paywallInfo: paywallInfo.pigeonify(),
        triggeredPlacementName: triggeredPlacementName
      )
    case .paywallWebviewLoadStart(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallWebviewLoadStart,
        paywallInfo: paywallInfo.pigeonify()
      )
    case .paywallWebviewLoadFail(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallWebviewLoadFail,
        paywallInfo: paywallInfo.pigeonify()
      )
    case .paywallWebviewLoadComplete(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallWebviewLoadComplete,
        paywallInfo: paywallInfo.pigeonify()
      )
    case .paywallWebviewLoadTimeout(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallWebviewLoadTimeout,
        paywallInfo: paywallInfo.pigeonify()
      )
    case .paywallWebviewLoadFallback(let paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallWebviewLoadFallback,
        paywallInfo: paywallInfo.pigeonify()
      )
    case let .paywallProductsLoadStart(triggeredPlacementName, paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallProductsLoadStart,
        paywallInfo: paywallInfo.pigeonify(),
        triggeredPlacementName: triggeredPlacementName
      )
    case let .paywallProductsLoadFail(triggeredPlacementName, paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallProductsLoadFail,
        paywallInfo: paywallInfo.pigeonify(),
        triggeredPlacementName: triggeredPlacementName
      )
    case .paywallProductsLoadComplete(let triggeredPlacementName):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallProductsLoadComplete,
        triggeredPlacementName: triggeredPlacementName
      )
    case let .paywallProductsLoadRetry(triggeredPlacementName, paywallInfo, attempt):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallProductsLoadRetry,
        paywallInfo: paywallInfo.pigeonify(),
        triggeredPlacementName: triggeredPlacementName,
        attempt: Int64(attempt)
      )
    case let .surveyResponse(survey, selectedOption, customResponse, paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .surveyResponse,
        paywallInfo: paywallInfo.pigeonify(),
        survey: survey.pigeonify(),
        selectedOption: selectedOption.pigeonify(),
        customResponse: customResponse
      )
    case .paywallPresentationRequest(let status, let reason):
      pEventInfo = PSuperwallEventInfo(
        eventType: .paywallPresentationRequest,
        status: status.pigeonify(),
        reason: reason?.pigeonify()
      )
    case .touchesBegan:
      pEventInfo = PSuperwallEventInfo(eventType: .touchesBegan)
    case .surveyClose:
      pEventInfo = PSuperwallEventInfo(eventType: .surveyClose)
    case .reset:
      pEventInfo = PSuperwallEventInfo(eventType: .reset)
    case .restoreStart:
      pEventInfo = PSuperwallEventInfo(eventType: .restoreStart)
    case .restoreFail(let message):
      pEventInfo = PSuperwallEventInfo(
        eventType: .restoreFail,
        message: message
      )
    case .restoreComplete:
      pEventInfo = PSuperwallEventInfo(eventType: .restoreComplete)
    case .configRefresh:
      pEventInfo = PSuperwallEventInfo(eventType: .configRefresh)
    case let .customPlacement(name, params, paywallInfo):
      pEventInfo = PSuperwallEventInfo(
        eventType: .customPlacement,
        params: params,
        paywallInfo: paywallInfo.pigeonify(),
        name: name
      )
    case .configAttributes:
      pEventInfo = PSuperwallEventInfo(eventType: .configAttributes)
    case .confirmAllAssignments:
      pEventInfo = PSuperwallEventInfo(eventType: .confirmAllAssignments)
    case .configFail:
      pEventInfo = PSuperwallEventInfo(eventType: .configFail)
    case .adServicesTokenRequestStart:
      pEventInfo = PSuperwallEventInfo(eventType: .adServicesTokenRequestStart)
    case .adServicesTokenRequestFail(let error):
      pEventInfo = PSuperwallEventInfo(
        eventType: .adServicesTokenRequestFail,
        error: error.localizedDescription
      )
    case .adServicesTokenRequestComplete(let token):
      pEventInfo = PSuperwallEventInfo(
        eventType: .adServicesTokenRequestComplete,
        token: token
      )
    case .shimmerViewStart:
      pEventInfo = PSuperwallEventInfo(eventType: .shimmerViewStart)
    case .shimmerViewComplete:
      pEventInfo = PSuperwallEventInfo(eventType: .shimmerViewComplete)
    case .redemptionStart:
      pEventInfo = PSuperwallEventInfo(eventType: .redemptionStart)
    case .redemptionComplete:
      pEventInfo = PSuperwallEventInfo(eventType: .redemptionComplete)
    case .redemptionFail:
      pEventInfo = PSuperwallEventInfo(eventType: .redemptionFail)
    case .enrichmentStart:
      pEventInfo = PSuperwallEventInfo(eventType: .enrichmentStart)
    case let .enrichmentComplete(userEnrichment, deviceEnrichment):
      pEventInfo = PSuperwallEventInfo(
        eventType: .enrichmentComplete,
        userEnrichment: userEnrichment,
        deviceEnrichment: deviceEnrichment
      )
    case .enrichmentFail:
      pEventInfo = PSuperwallEventInfo(eventType: .enrichmentFail)
    case .networkDecodingFail:
      pEventInfo = PSuperwallEventInfo(eventType: .networkDecodingFail)
    }

    flutterDelegate().handleSuperwallEvent(eventInfo: pEventInfo) { result in
      // NO-OP
    }
  }

  func handleCustomPaywallAction(withName name: String) {
    flutterDelegate().handleCustomPaywallAction(name: name) { result in
      // NO-OP
    }
  }

  func willDismissPaywall(withInfo paywallInfo: PaywallInfo) {
    flutterDelegate().willDismissPaywall(paywallInfo: paywallInfo.pigeonify())
    { result in
      // NO-OP
    }
  }

  func willPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    flutterDelegate().willPresentPaywall(paywallInfo: paywallInfo.pigeonify())
    { result in
      // NO-OP
    }
  }

  func didDismissPaywall(withInfo paywallInfo: PaywallInfo) {
    flutterDelegate().didDismissPaywall(paywallInfo: paywallInfo.pigeonify())
    { result in
      // NO-OP
    }
  }

  func didPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    flutterDelegate().didPresentPaywall(paywallInfo: paywallInfo.pigeonify())
    { result in
      // NO-OP
    }
  }

  func paywallWillOpenURL(url: URL) {
    flutterDelegate().paywallWillOpenURL(url: url.absoluteString) { result in
      // NO-OP
    }
  }

  func paywallWillOpenDeepLink(url: URL) {
    flutterDelegate().paywallWillOpenDeepLink(url: url.absoluteString) { result in
      // NO-OP
    }
  }

  private func transformValue(_ value: Any) -> Any? {
    switch value {
    case let stringValue as String:
      return stringValue
    case let intValue as Int:
      return intValue
    case let boolValue as Bool:
      return boolValue
    case let dictValue as [String: Any]:
      return dictValue.compactMapValues { transformValue($0) }
    case let arrayValue as [Any]:
      return arrayValue.compactMap { transformValue($0) }
    case let setValue as Set<AnyHashable>:
      return Array(setValue).compactMap { transformValue($0) }
    default:
      return nil
    }
  }

  func handleLog(
    level: String, scope: String, message: String?, info: [String: Any]?, error: (any Error)?
  ) {
    let transformedInfo = info?.compactMapValues { transformValue($0) }

    flutterDelegate().handleLog(
      level: level,
      scope: scope,
      message: message,
      info: transformedInfo,
      error: error?.localizedDescription
    ) { result in
      // NO-OP
    }
  }

  func willRedeemLink() {
    flutterDelegate().willRedeemLink { result in
      // NO-OP
    }
  }

  func didRedeemLink(result: RedemptionResult) {
    flutterDelegate().didRedeemLink(result: result.pigeonify()) { result in
      // NO-OP
    }
  }
}
