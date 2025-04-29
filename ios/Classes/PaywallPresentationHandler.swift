import SuperwallKit
import Foundation

class PaywallPresentationHandlerHost {
    private let flutterHandler: PPaywallPresentationHandlerGenerated
    let handler: PaywallPresentationHandler
    
    init(flutterHandler: PPaywallPresentationHandlerGenerated) {
        self.flutterHandler = flutterHandler
        
        self.handler = PaywallPresentationHandler()
        
        self.handler.onPresent { [self] (paywallInfo: PaywallInfo) in
            self.flutterHandler.onPresent(
                paywallInfo: PaywallInfoMapper.toPPaywallInfo(paywallInfo),
                completion: { result in
                    // NO-OP
                }
            )
        }
        
        self.handler.onDismiss { [self] (paywallInfo: PaywallInfo, result: PaywallResult) in
            let pResult: PPaywallResult
            
            switch result {
            case .purchased(let product):
                pResult = PPurchasedPaywallResult(productId: product.productIdentifier)
            case .restored:
                pResult = PRestoredPaywallResult(ignore: false)
            case .declined:
                pResult = PDeclinedPaywallResult(ignore: false)
            }
            
            self.flutterHandler.onDismiss(
                paywallInfo: PaywallInfoMapper.toPPaywallInfo(paywallInfo),
                paywallResult: pResult,
                completion: { result in
                    // NO-OP
                }
            )
        }
        
        self.handler.onError { [self] (error: Error) in
            self.flutterHandler.onError(
                error: error.localizedDescription,
                completion: { result in
                    // NO-OP
                }
            )
        }
        
        self.handler.onSkip { [self] (reason: PaywallSkippedReason) in
            let pReason: PPaywallSkippedReason
            
            switch reason {
            case .holdout:
                pReason = .holdout
            case .noAudienceMatch:
                pReason = .noAudienceMatch
            case .placementNotFound:
                pReason = .placementNotFound
            }
            
            self.flutterHandler.onSkip(
                reason: pReason,
                completion: { result in
                    // NO-OP
                }
            )
        }
    }
} 