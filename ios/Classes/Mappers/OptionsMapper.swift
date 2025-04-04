import SuperwallKit
import Foundation

extension PSuperwallOptions {
    func toSdkOptions() -> SuperwallOptions {
        let options = SuperwallOptions()
        
        if let paywalls = self.paywalls {
            // Paywalls options
            if let isHapticFeedbackEnabled = paywalls.isHapticFeedbackEnabled {
                options.paywalls.isHapticFeedbackEnabled = isHapticFeedbackEnabled
            }
            
            if let restoreFailed = paywalls.restoreFailed {
                if let title = restoreFailed.title {
                    options.paywalls.restoreFailed.title = title
                }
                if let message = restoreFailed.message {
                    options.paywalls.restoreFailed.message = message
                }
                if let closeButtonTitle = restoreFailed.closeButtonTitle {
                    options.paywalls.restoreFailed.closeButtonTitle = closeButtonTitle
                }
            }
            
            if let shouldShowPurchaseFailureAlert = paywalls.shouldShowPurchaseFailureAlert {
                options.paywalls.shouldShowPurchaseFailureAlert = shouldShowPurchaseFailureAlert
            }
            
            if let shouldPreload = paywalls.shouldPreload {
                options.paywalls.shouldPreload = shouldPreload
            }
            
            if let automaticallyDismiss = paywalls.automaticallyDismiss {
                options.paywalls.automaticallyDismiss = automaticallyDismiss
            }
            
            if let transactionBackgroundView = paywalls.transactionBackgroundView {
                switch transactionBackgroundView {
                case .spinner:
                    options.paywalls.transactionBackgroundView = .spinner
                case .none:
                    options.paywalls.transactionBackgroundView = .none
                }
            }
        }
        
        if let env = self.networkEnvironment {
            switch env {
            case .release:
                options.networkEnvironment = .release
            case .releaseCandidate:
                options.networkEnvironment = .releaseCandidate
            case .developer:
                options.networkEnvironment = .developer
            }
        }
        
        if let isExternalDataCollectionEnabled = self.isExternalDataCollectionEnabled {
            options.isExternalDataCollectionEnabled = isExternalDataCollectionEnabled
        }
        
        options.localeIdentifier = self.localeIdentifier
        
        if let isGameControllerEnabled = self.isGameControllerEnabled {
            options.isGameControllerEnabled = isGameControllerEnabled
        }
        
        if let logging = self.logging {
            if let level = logging.level {
                switch level {
                case .debug:
                    options.logging.level = .debug
                case .info:
                    options.logging.level = .info
                case .warn:
                    options.logging.level = .warn
                case .error:
                    options.logging.level = .error
                case .none:
                    options.logging.level = .none
                }
            }
            
            if let scopes = logging.scopes {
                var sdkScopes = Set<LogScope>()
                for scope in scopes {
                    switch scope {
                    case .localizationManager:
                        sdkScopes.insert(.localizationManager)
                    case .bounceButton:
                        sdkScopes.insert(.bounceButton)
                    case .coreData:
                        sdkScopes.insert(.coreData)
                    case .configManager:
                        sdkScopes.insert(.configManager)
                    case .identityManager:
                        sdkScopes.insert(.identityManager)
                    case .debugManager:
                        sdkScopes.insert(.debugManager)
                    case .debugViewController:
                        sdkScopes.insert(.debugViewController)
                    case .localizationViewController:
                        sdkScopes.insert(.localizationViewController)
                    case .gameControllerManager:
                        sdkScopes.insert(.gameControllerManager)
                    case .device:
                        sdkScopes.insert(.device)
                    case .network:
                        sdkScopes.insert(.network)
                    case .paywallEvents:
                        sdkScopes.insert(.paywallEvents)
                    case .productsManager:
                        sdkScopes.insert(.productsManager)
                    case .storeKitManager:
                        sdkScopes.insert(.storeKitManager)
                    case .placements:
                        sdkScopes.insert(.placements)
                    case .receipts:
                        sdkScopes.insert(.receipts)
                    case .superwallCore:
                        sdkScopes.insert(.superwallCore)
                    case .paywallPresentation:
                        sdkScopes.insert(.paywallPresentation)
                    case .transactions:
                        sdkScopes.insert(.transactions)
                    case .paywallViewController:
                        sdkScopes.insert(.paywallViewController)
                    case .cache:
                        sdkScopes.insert(.cache)
                    case .all:
                        sdkScopes.insert(.all)
                    }
                }
                options.logging.scopes = sdkScopes
            }
        }
        
        return options
    }
} 