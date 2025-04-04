import SuperwallKit
import Foundation

class SuperwallDelegateHost: SuperwallDelegate {
    private let flutterDelegate: () -> PSuperwallDelegateGenerated
    
    init(flutterDelegate: @escaping () -> PSuperwallDelegateGenerated) {
        self.flutterDelegate = flutterDelegate
    }
    
    func subscriptionStatusDidChange(from oldValue: SubscriptionStatus, to newValue: SubscriptionStatus) {
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
    
    func handleSuperwallEvent(_ event: SuperwallEvent) {
        let pEventType: PEventType
        
        switch event {
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
        
        if case let .paywallOpen(paywallInfo: info) = event {
            paywallInfo = PaywallInfoMapper.toPPaywallInfo(info)
        } else if case let .paywallClose(paywallInfo: info) = event {
            paywallInfo = PaywallInfoMapper.toPPaywallInfo(info)
        } else if case let .paywallDecline(paywallInfo: info) = event {
            paywallInfo = PaywallInfoMapper.toPPaywallInfo(info)
        }      

        if case let .customPlacement(name: name, params: parameters, paywallInfo: info) = event {
            paywallInfo = PaywallInfoMapper.toPPaywallInfo(info)
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
    
    func willDismissPaywall(_ paywallInfo: PaywallInfo) {
        flutterDelegate().willDismissPaywall(paywallInfo: PaywallInfoMapper.toPPaywallInfo(paywallInfo)) { result in
            // NO-OP
        }
    }
    
    func willPresentPaywall(_ paywallInfo: PaywallInfo) {
        flutterDelegate().willPresentPaywall(paywallInfo: PaywallInfoMapper.toPPaywallInfo(paywallInfo)) { result in
            // NO-OP
        }
    }
    
    func didDismissPaywall(_ paywallInfo: PaywallInfo) {
        flutterDelegate().didDismissPaywall(paywallInfo: PaywallInfoMapper.toPPaywallInfo(paywallInfo)) { result in
            // NO-OP
        }
    }
    
    func didPresentPaywall(_ paywallInfo: PaywallInfo) {
        flutterDelegate().didPresentPaywall(paywallInfo: PaywallInfoMapper.toPPaywallInfo(paywallInfo)) { result in
            // NO-OP
        }
    }
    
    func paywallWillOpenURL(_ url: URL) {
        flutterDelegate().paywallWillOpenURL(url: url.absoluteString) { result in
            // NO-OP
        }
    }
    
    func paywallWillOpenDeepLink(_ url: URL) {
        flutterDelegate().paywallWillOpenDeepLink(url: url.absoluteString) { result in
            // NO-OP
        }
    }
    
    func handleLog(level: LogLevel, scope: LogScope?, message: String?, info: [String: Any]?, error: Error?) {
        var levelString = ""
        switch level {
        case .debug: levelString = "debug"
        case .info: levelString = "info"
        case .warn: levelString = "warn"
        case .error: levelString = "error"
        case .none: levelString = "none"
        @unknown default: levelString = "none"
        }
        
        var scopeString = ""
        if let scope = scope {
            switch scope {
            case .localizationManager: scopeString = "localizationManager"
            case .bounceButton: scopeString = "bounceButton"
            case .coreData: scopeString = "coreData"
            case .configManager: scopeString = "configManager"
            case .identityManager: scopeString = "identityManager"
            case .debugManager: scopeString = "debugManager"
            case .debugViewController: scopeString = "debugViewController"
            case .localizationViewController: scopeString = "localizationViewController"
            case .gameControllerManager: scopeString = "gameControllerManager"
            case .device: scopeString = "device"
            case .network: scopeString = "network"
            case .paywallEvents: scopeString = "paywallEvents"
            case .productsManager: scopeString = "productsManager"
            case .storeKitManager: scopeString = "storeKitManager"
            case .placements: scopeString = "placements"
            case .receipts: scopeString = "receipts"
            case .superwallCore: scopeString = "superwallCore"
            case .paywallPresentation: scopeString = "paywallPresentation"
            case .transactions: scopeString = "transactions"
            case .paywallViewController: scopeString = "paywallViewController"
            case .cache: scopeString = "cache"
            case .all: scopeString = "all"
            @unknown default: scopeString = "all"
            }
        }
        
        flutterDelegate().handleLog(
            level: levelString,
            scope: scopeString,
            message: message,
            info: info,
            error: error?.localizedDescription
        ) { result in
            // NO-OP
        }
    }
} 