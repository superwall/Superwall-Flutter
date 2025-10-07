import Foundation
import SuperwallKit

final class SuperwallDelegateHost: SuperwallDelegate {
    private let flutterDelegate: () -> PSuperwallDelegateGenerated

    init(flutterDelegate: @escaping () -> PSuperwallDelegateGenerated) {
        self.flutterDelegate = flutterDelegate
    }

    /**
   * Maps eventInfo.params to a Dart-compatible format
   * Handles all basic types, maps, and arrays recursively
   */
    private func mapParamsForDart(_ params: [String: Any]?) -> [String: Any]? {
        guard let params = params else { return nil }

        return params.compactMapValues { value in
            mapValueForDart(value)
        }
    }

    /**
   * Recursively maps any value to Dart-compatible format
   */
    private func mapValueForDart(_ value: Any) -> Any? {
        switch value {
        case let stringValue as String:
            return stringValue
        case let intValue as Int:
            return intValue
        case let boolValue as Bool:
            return boolValue
        case let doubleValue as Double:
            return doubleValue
        case let floatValue as Float:
            return floatValue
        case let dictValue as [String: Any]:
            return mapParamsForDart(dictValue)
        case let arrayValue as [Any]:
            return arrayValue.compactMap { mapValueForDart($0) }
        case let setValue as Set<AnyHashable>:
            return Array(setValue).compactMap { mapValueForDart($0) }
        default:
            return String(describing: value)
        }
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
        let params = mapParamsForDart(eventInfo.params)
        let pEventInfo: PSuperwallEventInfo

        switch eventInfo.event {
        case .firstSeen:
            pEventInfo = PSuperwallEventInfo(eventType: .firstSeen, params: params)
        case .appOpen:
            pEventInfo = PSuperwallEventInfo(eventType: .appOpen, params: params)
        case .appLaunch:
            pEventInfo = PSuperwallEventInfo(eventType: .appLaunch, params: params)
        case .identityAlias:
            pEventInfo = PSuperwallEventInfo(eventType: .identityAlias, params: params)
        case .appInstall:
            pEventInfo = PSuperwallEventInfo(eventType: .appInstall, params: params)
        case .sessionStart:
            pEventInfo = PSuperwallEventInfo(eventType: .sessionStart, params: params)
        case .deviceAttributes(let attributes):
            pEventInfo = PSuperwallEventInfo(
                eventType: .deviceAttributes,
                params: params,
                deviceAttributes: attributes
            )
        case .subscriptionStatusDidChange:
            pEventInfo = PSuperwallEventInfo(
                eventType: .subscriptionStatusDidChange, params: params)
        case .appClose:
            pEventInfo = PSuperwallEventInfo(eventType: .appClose, params: params)
        case .deepLink(let url):
            pEventInfo = PSuperwallEventInfo(
                eventType: .deepLink,
                params: params,
                deepLinkUrl: url.absoluteString
            )
        case .triggerFire(let placementName, let result):
            pEventInfo = PSuperwallEventInfo(
                eventType: .triggerFire,
                params: params,
                placementName: placementName,
                result: result.pigeonify()
            )
        case .paywallOpen(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallOpen,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case .paywallClose(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallClose,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case .paywallDecline(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallDecline,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case .transactionStart(let product, let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .transactionStart,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                product: product.pigeonify()
            )
        case .transactionFail(let error, let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .transactionFail,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                error: error.localizedDescription
            )
        case .transactionAbandon(let product, let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .transactionAbandon,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                product: product.pigeonify()
            )
        case let .transactionComplete(transaction, product, type, paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .transactionComplete,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                transaction: transaction?.pigeonify(),
                product: product.pigeonify()
            )
        // TODO: Add type
        case .subscriptionStart(let product, let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .subscriptionStart,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                product: product.pigeonify()
            )
        case .freeTrialStart(let product, let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .freeTrialStart,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                product: product.pigeonify()
            )
        case .transactionRestore(let restoreType, let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .transactionComplete,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                restoreType: restoreType.pigeonify()
            )
        case .transactionTimeout(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .transactionTimeout,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case .userAttributes(let attributes):
            pEventInfo = PSuperwallEventInfo(
                eventType: .userAttributes,
                params: params,
                userAttributes: attributes
            )
        case .nonRecurringProductPurchase(let product, let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .nonRecurringProductPurchase,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        // TODO: Add product
        case .paywallResponseLoadStart(let triggeredPlacementName):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallResponseLoadStart,
                params: params,
                triggeredPlacementName: triggeredPlacementName
            )
        case .paywallResponseLoadNotFound(let triggeredPlacementName):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallResponseLoadNotFound,
                params: params,
                triggeredPlacementName: triggeredPlacementName
            )
        case .paywallResponseLoadFail(let triggeredPlacementName):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallResponseLoadFail,
                params: params,
                triggeredPlacementName: triggeredPlacementName
            )
        case .paywallResponseLoadComplete(let triggeredPlacementName, let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallResponseLoadComplete,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                triggeredPlacementName: triggeredPlacementName
            )
        case .paywallWebviewLoadStart(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallWebviewLoadStart,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case .paywallWebviewLoadFail(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallWebviewLoadFail,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case .paywallWebviewLoadComplete(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallWebviewLoadComplete,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case .paywallWebviewLoadTimeout(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallWebviewLoadTimeout,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case .paywallWebviewLoadFallback(let paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallWebviewLoadFallback,
                params: params,
                paywallInfo: paywallInfo.pigeonify()
            )
        case let .paywallProductsLoadStart(triggeredPlacementName, paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallProductsLoadStart,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                triggeredPlacementName: triggeredPlacementName
            )
        case let .paywallProductsLoadFail(triggeredPlacementName, paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallProductsLoadFail,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                triggeredPlacementName: triggeredPlacementName
            )
        case .paywallProductsLoadComplete(let triggeredPlacementName):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallProductsLoadComplete,
                params: params,
                triggeredPlacementName: triggeredPlacementName
            )
        case let .paywallProductsLoadRetry(triggeredPlacementName, paywallInfo, attempt):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallProductsLoadRetry,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                triggeredPlacementName: triggeredPlacementName,
                attempt: Int64(attempt)
            )
        case let .surveyResponse(survey, selectedOption, customResponse, paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .surveyResponse,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                survey: survey.pigeonify(),
                selectedOption: selectedOption.pigeonify(),
                customResponse: customResponse
            )
        case .paywallPresentationRequest(let status, let reason):
            pEventInfo = PSuperwallEventInfo(
                eventType: .paywallPresentationRequest,
                params: params,
                status: status.pigeonify(),
                reason: reason?.pigeonify()
            )
        case .touchesBegan:
            pEventInfo = PSuperwallEventInfo(eventType: .touchesBegan, params: params)
        case .surveyClose:
            pEventInfo = PSuperwallEventInfo(eventType: .surveyClose, params: params)
        case .reset:
            pEventInfo = PSuperwallEventInfo(eventType: .reset, params: params)
        case .restoreStart:
            pEventInfo = PSuperwallEventInfo(eventType: .restoreStart, params: params)
        case .restoreFail(let message):
            pEventInfo = PSuperwallEventInfo(
                eventType: .restoreFail,
                params: params,
                message: message
            )
        case .restoreComplete:
            pEventInfo = PSuperwallEventInfo(eventType: .restoreComplete, params: params)
        case .configRefresh:
            pEventInfo = PSuperwallEventInfo(eventType: .configRefresh, params: params)
        case let .customPlacement(name, params, paywallInfo):
            pEventInfo = PSuperwallEventInfo(
                eventType: .customPlacement,
                params: params,
                paywallInfo: paywallInfo.pigeonify(),
                name: name
            )
        case .configAttributes:
            pEventInfo = PSuperwallEventInfo(eventType: .configAttributes, params: params)
        case .confirmAllAssignments:
            pEventInfo = PSuperwallEventInfo(eventType: .confirmAllAssignments, params: params)
        case .configFail:
            pEventInfo = PSuperwallEventInfo(eventType: .configFail, params: params)
        case .adServicesTokenRequestStart:
            pEventInfo = PSuperwallEventInfo(
                eventType: .adServicesTokenRequestStart, params: params)
        case .adServicesTokenRequestFail(let error):
            pEventInfo = PSuperwallEventInfo(
                eventType: .adServicesTokenRequestFail,
                params: params,
                error: error.localizedDescription
            )
        case .adServicesTokenRequestComplete(let token):
            pEventInfo = PSuperwallEventInfo(
                eventType: .adServicesTokenRequestComplete,
                params: params,
                token: token
            )
        case .shimmerViewStart:
            pEventInfo = PSuperwallEventInfo(eventType: .shimmerViewStart, params: params)
        case .shimmerViewComplete:
            pEventInfo = PSuperwallEventInfo(eventType: .shimmerViewComplete, params: params)
        case .redemptionStart:
            pEventInfo = PSuperwallEventInfo(eventType: .redemptionStart, params: params)
        case .redemptionComplete:
            pEventInfo = PSuperwallEventInfo(eventType: .redemptionComplete, params: params)
        case .redemptionFail:
            pEventInfo = PSuperwallEventInfo(eventType: .redemptionFail, params: params)
        case .enrichmentStart:
            pEventInfo = PSuperwallEventInfo(eventType: .enrichmentStart, params: params)
        case let .enrichmentComplete(userEnrichment, deviceEnrichment):
            pEventInfo = PSuperwallEventInfo(
                eventType: .enrichmentComplete,
                params: params,
                userEnrichment: userEnrichment,
                deviceEnrichment: deviceEnrichment
            )
        case .enrichmentFail:
            pEventInfo = PSuperwallEventInfo(eventType: .enrichmentFail, params: params)
        case .networkDecodingFail:
            pEventInfo = PSuperwallEventInfo(eventType: .networkDecodingFail, params: params)
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
        flutterDelegate().willDismissPaywall(paywallInfo: paywallInfo.pigeonify()) { result in
            // NO-OP
        }
    }

    func willPresentPaywall(withInfo paywallInfo: PaywallInfo) {
        flutterDelegate().willPresentPaywall(paywallInfo: paywallInfo.pigeonify()) { result in
            // NO-OP
        }
    }

    func didDismissPaywall(withInfo paywallInfo: PaywallInfo) {
        flutterDelegate().didDismissPaywall(paywallInfo: paywallInfo.pigeonify()) { result in
            // NO-OP
        }
    }

    func didPresentPaywall(withInfo paywallInfo: PaywallInfo) {
        flutterDelegate().didPresentPaywall(paywallInfo: paywallInfo.pigeonify()) { result in
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

    func handleSuperwallDeepLink(
        _ fullURL: URL,
        pathComponents: [String],
        queryParameters: [String: String]
    ) {
        flutterDelegate().handleSuperwallDeepLink(
            fullURL: fullURL.absoluteString,
            pathComponents: pathComponents,
            queryParameters: queryParameters
        ) { _ in
            // NO-OP
        }
    }
}
