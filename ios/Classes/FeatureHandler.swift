import SuperwallKit
import Foundation

class FeatureHandlerHost {
    private let featureId: String
    private let flutterHandler: () -> PFeatureHandlerGenerated
    let handler: () -> Void
    
    init(featureId: String, flutterHandler: @escaping () -> PFeatureHandlerGenerated) {
        self.featureId = featureId
        self.flutterHandler = flutterHandler
        
        self.handler = {
            flutterHandler().onFeature(id: featureId) { _ in }
        }
    }
} 