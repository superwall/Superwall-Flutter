import Flutter
import SuperwallKit
import Foundation
import Combine

final class SuperwallHost : NSObject, PSuperwallHostApi {
  private let flutterBinaryMessenger: FlutterBinaryMessenger
  private var streamHandler: SubscriptionStatusStreamHandlerImpl?
  private var presentationHandlers: [String: PaywallPresentationHandlerHost] = [:]

  init(flutterBinaryMessenger: FlutterBinaryMessenger) {
    self.flutterBinaryMessenger = flutterBinaryMessenger
    super.init()
    PSuperwallHostApiSetup.setUp(binaryMessenger: flutterBinaryMessenger, api: self)
    self.streamHandler = SubscriptionStatusStreamHandlerImpl()
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

    if let streamHandler = self.streamHandler {
      StreamSubscriptionStatusStreamHandler.register(with: flutterBinaryMessenger, streamHandler: streamHandler)
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

  func getDeviceAttributes(completion: @escaping (Result<[String : Any], any Error>) -> Void) {
    Task {
      let deviceAttributes = await Superwall.shared.getDeviceAttributes()
      completion(.success(deviceAttributes))
    }
  }

  func setDelegate(hasDelegate: Bool) {
    if hasDelegate {
      let delegate = PSuperwallDelegateGenerated(binaryMessenger: self.flutterBinaryMessenger)
      let flutterDelegate = { [weak self] () -> PSuperwallDelegateGenerated in
        guard self != nil else {
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
      let result = await Superwall.shared.confirmAllAssignments()
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
    return Superwall.handleDeepLink(url)
  }

  func togglePaywallSpinner(isHidden: Bool) {
    Superwall.shared.togglePaywallSpinner(isHidden: isHidden)
  }

  func getLatestPaywallInfo() -> PPaywallInfo? {
    return Superwall.shared.latestPaywallInfo.map { $0.pigeonify() }
  }

  func registerPlacement(
    placement: String,
    params: [String : Any]?,
    handler: PPaywallPresentationHandlerHost?,
    feature: PFeatureHandlerHost?,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    let presentationHandler: PaywallPresentationHandler?

    if handler != nil {
      let flutterHandler = PPaywallPresentationHandlerGenerated(
        binaryMessenger: self.flutterBinaryMessenger,
        messageChannelSuffix: placement
      )
      let handlerHost = PaywallPresentationHandlerHost(
        flutterHandler: flutterHandler,
        placement: placement,
        cleanupCallback: { [weak self] placement in
          self?.presentationHandlers.removeValue(forKey: placement)
        }
      )
      presentationHandlers[placement] = handlerHost
      presentationHandler = handlerHost.handler
    } else {
      presentationHandler = nil
    }

    let featureHandler = feature != nil ? { [self] in
      let flutterHandler = PFeatureHandlerGenerated(
        binaryMessenger: self.flutterBinaryMessenger,
        messageChannelSuffix: placement
      )
      flutterHandler.onFeature(id: placement, completion: { _ in })
    } : nil

    if let featureHandler = featureHandler {
      Superwall.shared.register(
        placement: placement,
        params: params,
        handler: presentationHandler,
        feature: featureHandler
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

  func restorePurchases(completion: @escaping (Result<any PRestorationResult, any Error>) -> Void) {
    Superwall.shared.restorePurchases { result in
      switch result {
      case .restored:
        completion(.success(PRestorationRestored()))
      case .failed(let error):
        completion(.success(PRestorationFailed(error: error?.localizedDescription)))
      }
    }
  }

  func getPresentationResult(
    placement: String,
    params: [String : Any]?,
    completion: @escaping (Result<any PPresentationResult, any Error>) -> Void
  ) {
    Superwall.shared.getPresentationResult(
      forPlacement: placement,
      params: params
    ) { result in
      completion(.success(result.pigeonify()))
    }
  }
}

final class SubscriptionStatusStreamHandlerImpl: StreamSubscriptionStatusStreamHandler {
  private var eventSink: PigeonEventSink<PSubscriptionStatus>?
  private var cancellable: AnyCancellable?

  override func onListen(withArguments arguments: Any?, sink: PigeonEventSink<PSubscriptionStatus>) {
    eventSink = sink
    cancellable = Superwall.shared.$subscriptionStatus
      .sink { [weak self] status in
        guard let self = self else { return }
        switch status {
        case .active(let entitlements):
          self.eventSink?.success(PActive(entitlements: entitlements.map { PEntitlement(id: $0.id) }))
        case .inactive:
          self.eventSink?.success(PInactive(ignore: false))
        case .unknown:
          self.eventSink?.success(PUnknown(ignore: false))
        }
      }
  }

  override func onCancel(withArguments arguments: Any?) {
    cancellable?.cancel()
    cancellable = nil
    eventSink = nil
  }
}
