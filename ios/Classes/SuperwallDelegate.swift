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
    let pEventType: PEventType

    switch eventInfo.event {
    case .firstSeen: pEventType = .firstSeen
    case .appOpen: pEventType = .appOpen
    case .appLaunch: pEventType = .appLaunch
    case .identityAlias: pEventType = .identityAlias
    case .appInstall: pEventType = .appInstall
    case .restoreStart: pEventType = .restoreStart
    case .restoreComplete: pEventType = .restoreComplete
    case .restoreFail: pEventType = .restoreFail
    case .sessionStart: pEventType = .sessionStart
    case .deviceAttributes: pEventType = .deviceAttributes
    case .subscriptionStatusDidChange: pEventType = .subscriptionStatusDidChange
    case .appClose: pEventType = .appClose
    case .deepLink: pEventType = .deepLink
    case .triggerFire: pEventType = .triggerFire
    case .paywallOpen: pEventType = .paywallOpen
    case .paywallClose: pEventType = .paywallClose
    case .paywallDecline: pEventType = .paywallDecline
    case .transactionStart: pEventType = .transactionStart
    case .transactionFail: pEventType = .transactionFail
    case .transactionAbandon: pEventType = .transactionAbandon
    case .transactionComplete: pEventType = .transactionComplete
    case .subscriptionStart: pEventType = .subscriptionStart
    case .freeTrialStart: pEventType = .freeTrialStart
    case .transactionRestore: pEventType = .transactionRestore
    case .transactionTimeout: pEventType = .transactionTimeout
    case .userAttributes: pEventType = .userAttributes
    case .nonRecurringProductPurchase: pEventType = .nonRecurringProductPurchase
    case .paywallResponseLoadStart: pEventType = .paywallResponseLoadStart
    case .paywallResponseLoadNotFound: pEventType = .paywallResponseLoadNotFound
    case .paywallResponseLoadFail: pEventType = .paywallResponseLoadFail
    case .paywallResponseLoadComplete: pEventType = .paywallResponseLoadComplete
    case .paywallWebviewLoadStart: pEventType = .paywallWebviewLoadStart
    case .paywallWebviewLoadFail: pEventType = .paywallWebviewLoadFail
    case .paywallWebviewLoadComplete: pEventType = .paywallWebviewLoadComplete
    case .paywallWebviewLoadTimeout: pEventType = .paywallWebviewLoadTimeout
    case .paywallWebviewLoadFallback: pEventType = .paywallWebviewLoadFallback
    case .paywallProductsLoadRetry: pEventType = .paywallProductsLoadRetry
    case .paywallProductsLoadStart: pEventType = .paywallProductsLoadStart
    case .paywallProductsLoadFail: pEventType = .paywallProductsLoadFail
    case .surveyResponse: pEventType = .surveyResponse
    case .paywallPresentationRequest: pEventType = .paywallPresentationRequest
    case .touchesBegan: pEventType = .touchesBegan
    case .surveyClose: pEventType = .surveyClose
    case .reset: pEventType = .reset
    case .configRefresh: pEventType = .configRefresh
    case .customPlacement: pEventType = .customPlacement
    case .configAttributes: pEventType = .configAttributes
    case .confirmAllAssignments: pEventType = .confirmAllAssignments
    case .configFail: pEventType = .configFail
    case .adServicesTokenRequestStart: pEventType = .adServicesTokenRequestStart
    case .adServicesTokenRequestFail: pEventType = .adServicesTokenRequestFail
    case .adServicesTokenRequestComplete: pEventType = .adServicesTokenRequestComplete
    case .shimmerViewStart: pEventType = .shimmerViewStart
    case .shimmerViewComplete: pEventType = .shimmerViewComplete
    default: pEventType = .appOpen
    }

    var params: [String: Any]? = nil
    var paywallInfo: PPaywallInfo? = nil

    if case let .paywallOpen(info) = eventInfo.event {
      paywallInfo = info.pigeonify()
    } else if case let .paywallClose(info) = eventInfo.event {
      paywallInfo = info.pigeonify()
    } else if case let .paywallDecline(info) = eventInfo.event {
      paywallInfo = info.pigeonify()
    }

    if case let .customPlacement(_, parameters, info) = eventInfo.event {
      paywallInfo = info.pigeonify()
      params = parameters
    }

    let pEventInfo = PSuperwallEventInfo(
      eventType: pEventType,
      params: params,
      paywallInfo: paywallInfo
    )

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
