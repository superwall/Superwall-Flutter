import Flutter
import SuperwallKit
import Foundation

class SuperwallProxy: NSObject, PSuperwallHostApi {
    private let flutterBinaryMessenger: FlutterBinaryMessenger
    
    init(flutterBinaryMessenger: FlutterBinaryMessenger) {
        self.flutterBinaryMessenger = flutterBinaryMessenger
        super.init()
        PSuperwallHostApiSetup.setUp(binaryMessenger: flutterBinaryMessenger, api: self)
    }
    
    func configure(apiKey: String, purchaseController: PPurchaseControllerHost?, options: PSuperwallOptions?, completion: PConfigureCompletionHost?, completion completion_: @escaping (Result<Void, Error>) -> Void) {
        let sdkOptions = options?.toSdkOptions() ?? SuperwallOptions()
        let controller: PurchaseController? = purchaseController != nil ? 
            PurchaseControllerHost(flutterController: { PPurchaseControllerGenerated(binaryMessenger: self.flutterBinaryMessenger) }) : nil
            
        var configCompletion: (() -> Void)? = nil
        if completion != nil {
            configCompletion = { [weak self] in
                guard let self = self else { return }
                PConfigureCompletionGenerated(binaryMessenger: self.flutterBinaryMessenger)
                    .onConfigureCompleted(success: true, completion: { _ in })
            }
        }
        
        Superwall.configure(
            apiKey: apiKey,
            purchaseController: controller,
            options: sdkOptions,
            completion: configCompletion
        )
        
        completion_(.success(()))
    }
    
    func reset() {
        Superwall.shared.reset()
    }
    
    func setDelegate(hasDelegate: Bool) {
        if hasDelegate {
            let delegate = PSuperwallDelegateGenerated(binaryMessenger: self.flutterBinaryMessenger)
            let flutterDelegate = { [weak self] () -> PSuperwallDelegateGenerated in
                guard let self = self else {
                    fatalError("Binary messenger is nil")
                }
                return delegate
            }
            Superwall.shared.delegate = SuperwallDelegateHost(flutterDelegate: flutterDelegate)
        } else {
            Superwall.shared.delegate = nil
        }
    }
    
    func confirmAllAssignments(completion: @escaping (Result<[PConfirmedAssignment], Error>) -> Void) {
        Task {
            do {
                let result = try await Superwall.shared.confirmAllAssignments()
                let mappedResult = result.map { assignment in
                    PConfirmedAssignment(
                        experimentId: assignment.experimentId,
                        variant: PVariant(
                            id: assignment.variant.id,
                            type: assignment.variant.type == .treatment ? .treatment : .holdout,
                            paywallId: assignment.variant.paywallId
                        )
                    )
                }
                completion(.success(mappedResult))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getLogLevel() -> String {
        let logLevel = Superwall.shared.logLevel
        switch logLevel {
        case .debug: return "debug"
        case .info: return "info"
        case .warn: return "warn"
        case .error: return "error"
        case .none: return "none"
        @unknown default: return "none"
        }
    }
    
    func setLogLevel(logLevel: String) {
        switch logLevel {
        case "debug":
            Superwall.shared.logLevel = .debug
        case "info":
            Superwall.shared.logLevel = .info
        case "warn":
            Superwall.shared.logLevel = .warn
        case "error":
            Superwall.shared.logLevel = .error
        case "none":
            Superwall.shared.logLevel = .none
        default:
            break
        }
    }
    
    func getUserAttributes() -> [String : Any] {
        return Superwall.shared.userAttributes
    }
    
    func setUserAttributes(userAttributes: [String : Any]) {
        Superwall.shared.setUserAttributes(userAttributes)
    }
    
    func getLocaleIdentifier() -> String? {
        return Superwall.shared.localeIdentifier
    }
    
    func setLocaleIdentifier(localeIdentifier: String?) {
        Superwall.shared.localeIdentifier = localeIdentifier
    }
    
    func getUserId() -> String {
        return Superwall.shared.userId
    }
    
    func getIsLoggedIn() -> Bool {
        return Superwall.shared.isLoggedIn
    }
    
    func getIsInitialized() -> Bool {
        return Superwall.isInitialized
    }
    
    func identify(userId: String, identityOptions: PIdentityOptions?, completion: @escaping (Result<Void, Error>) -> Void) {
        let options = identityOptions != nil ? 
            IdentityOptions(
                restorePaywallAssignments: identityOptions?.restorePaywallAssignments ?? false
            ) : nil
        
        Superwall.shared.identify(userId: userId, options: options)
        completion(.success(()))
    }
    
    func identify(userId: String, identityOptions: PIdentityOptions?) throws {
        let options = identityOptions != nil ? 
            IdentityOptions(
                restorePaywallAssignments: identityOptions?.restorePaywallAssignments ?? false
            ) : nil
        
        Superwall.shared.identify(userId: userId, options: options)
    }
    
    func getEntitlements() -> PEntitlements {
        let swEntitlements = Superwall.shared.entitlements
        return PEntitlements(
            active: swEntitlements.active.map { PEntitlement(id: $0.id) },
            inactive: swEntitlements.inactive.map { PEntitlement(id: $0.id) },
            all: swEntitlements.all.map { PEntitlement(id: $0.id) }
        )
    }
    
    func getSubscriptionStatus() -> PSubscriptionStatus {
        let swStatus = Superwall.shared.subscriptionStatus
        
        switch swStatus {
        case .active(let entitlements):
            return PActive(entitlements: entitlements.map { PEntitlement(id: $0.id) })
        case .inactive:
            return PInactive(ignore: false)
        case .unknown:
            return PUnknown(ignore: false)
        }
    }
    
    func setSubscriptionStatus(subscriptionStatus: PSubscriptionStatus) {
        let swStatus: SubscriptionStatus
        
        switch subscriptionStatus {
        case let active as PActive:
            let entitlements = Set<Entitlement>(active.entitlements.compactMap { 
                guard let id = $0.id else { return nil }
                return Entitlement(id: id) 
            })
            swStatus = .active(entitlements)
        case is PInactive:
            swStatus = .inactive
        case is PUnknown:
            swStatus = .unknown
        default:
            swStatus = .unknown
        }
        
        Superwall.shared.subscriptionStatus = swStatus
    }
    
    func getConfigurationStatus() -> PConfigurationStatus {
        switch Superwall.shared.configurationStatus {
        case .configured:
            return .configured
        case .failed:
            return .failed
        case .pending:
            return .pending
        @unknown default:
            return .pending
        }
    }
    
    func getIsConfigured() -> Bool {
        return Superwall.shared.configurationStatus == .configured
    }
    
    func getIsPaywallPresented() -> Bool {
        return Superwall.shared.isPaywallPresented
    }
    
    func preloadAllPaywalls() {
        Superwall.shared.preloadAllPaywalls()
    }
    
    func preloadPaywallsForPlacements(placementNames: [String]) {
        let placementSet = Set<String>(placementNames)
        Superwall.shared.preloadPaywalls(forPlacements: placementSet)
    }
    
    func handleDeepLink(url: String) -> Bool {
        guard let url = URL(string: url) else { return false }
        return (try? Superwall.shared.handleDeepLink(url)) ?? false
    }
    
    func togglePaywallSpinner(isHidden: Bool) {
        Superwall.shared.togglePaywallSpinner(isHidden: isHidden)
    }
    
    func getLatestPaywallInfo() -> PPaywallInfo? {
        return Superwall.shared.latestPaywallInfo.map { PaywallInfoMapper.toPPaywallInfo($0) }
    }
    
    func registerPlacement(placement: String, params: [String : Any]?, handler: PPaywallPresentationHandlerHost?, feature: PFeatureHandlerHost?, completion: @escaping (Result<Void, Error>) -> Void) {
        let presentationHandler: PaywallPresentationHandler?
        
        if handler != nil {
            let flutterHandler = PPaywallPresentationHandlerGenerated(binaryMessenger: self.flutterBinaryMessenger, messageChannelSuffix: placement)
            presentationHandler = PaywallPresentationHandlerHost(flutterHandler: flutterHandler).handler
        } else {
            presentationHandler = nil
        }
        
        let featureHandler: (() -> Void)? = feature != nil ? { [self] in
            let flutterHandler = PFeatureHandlerGenerated(binaryMessenger: self.flutterBinaryMessenger, messageChannelSuffix: placement)
            flutterHandler.onFeature(id: placement, completion: { _ in })
        } : nil
        
        if let castedFeatureHandler = featureHandler {
            Superwall.shared.register(
                placement: placement,
                params: params,
                handler: presentationHandler,
                feature: castedFeatureHandler
            )
        } else {
            Superwall.shared.register(
                placement: placement,
                params: params,
                handler: presentationHandler
            )
        }
        
        completion(.success(()))
    }
    
    func dismiss() {
        Task {
            await Superwall.shared.dismiss()
        }
    }
}
