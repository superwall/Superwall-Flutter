import SuperwallKit
import Foundation

class PaywallPresentationHandlerHost {
    private let flutterHandler: () -> PPaywallPresentationHandlerGenerated
    let handler: PaywallPresentationHandler
    
    init(flutterHandler: @escaping () -> PPaywallPresentationHandlerGenerated) {
        self.flutterHandler = flutterHandler
        
        self.handler = PaywallPresentationHandler()
        
        self.handler.onPresent { [weak self] (paywallInfo: PaywallInfo) in
            guard let self = self else { return }
            let handler = self.flutterHandler()
            handler.onPresent(
                paywallInfo: PaywallInfoMapper.toPPaywallInfo(paywallInfo),
                completion: { result in
                    // NO-OP
                }
            )
        }
        
        self.handler.onDismiss { [weak self] (paywallInfo: PaywallInfo, result: PaywallResult) in
            guard let self = self else { return }
            let handler = self.flutterHandler()
            let pResult: PPaywallResult
            
            switch result {
            case .purchased(let product):
                pResult = PPurchasedPaywallResult(productId: product.productIdentifier)
            case .restored:
                pResult = PRestoredPaywallResult(ignore: false)
            case .declined:
                pResult = PDeclinedPaywallResult(ignore: false)
            }
            
            handler.onDismiss(
                paywallInfo: PaywallInfoMapper.toPPaywallInfo(paywallInfo),
                paywallResult: pResult,
                completion: { result in
                    // NO-OP
                }
            )
        }
        
        self.handler.onError { [weak self] (error: Error) in
            guard let self = self else { return }
            let handler = self.flutterHandler()
            handler.onError(
                error: error.localizedDescription,
                completion: { result in
                    // NO-OP
                }
            )
        }
        
        self.handler.onSkip { [weak self] (reason: PaywallSkippedReason) in
            guard let self = self else { return }
            let handler = self.flutterHandler()
            let pReason: PPaywallSkippedReason
            
            switch reason {
            case .holdout:
                pReason = .holdout
            case .noAudienceMatch:
                pReason = .noAudienceMatch
            case .placementNotFound:
                pReason = .placementNotFound
            }
            
            handler.onSkip(
                reason: pReason,
                completion: { result in
                    // NO-OP
                }
            )
        }
    }
} 