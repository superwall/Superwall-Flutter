import Flutter
import SuperwallKit

public class SuperwallBridge: BridgeInstance {
  override class var bridgeClass: BridgeClass { "SuperwallBridge" }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setDelegate":
      guard
        let delegateProxyBridge: SuperwallDelegate = call.bridgeInstance(
          for: "delegateProxyBridgeId")
      else {
        result(call.badArgs)
        return
      }

      Superwall.shared.delegate = delegateProxyBridge

      result(nil)

    case "getLogLevel":
      // Implement logic to get log level
      let json = Superwall.shared.logLevel.toJson()
      result(json)

    case "setLogLevel":
      guard
        let logLevelValue: String = call.argument(for: "logLevel"),
        let logLevel = LogLevel.fromJson(logLevelValue)
      else {
        result(call.badArgs)
        return
      }

      Superwall.shared.logLevel = logLevel

      result(nil)

    case "getUserAttributes":
      // Implement logic to get user attributes
      result(Superwall.shared.userAttributes)

    case "setUserAttributes":
      guard let userAttributes: [String: Any?] = call.argument(for: "userAttributes") else {
        result(call.badArgs)
        return
      }

      Superwall.shared.setUserAttributes(userAttributes)

      result(nil)

    case "getUserId":
      // Implement logic to get the current user's id
      result(Superwall.shared.userId)

    case "getIsLoggedIn":
      // Implement logic to check if the user is logged in to Superwall
      result(Superwall.shared.isLoggedIn)

    case "getIsInitialized":
      // Implement logic to check if Superwall is initialized
      result(Superwall.isInitialized)

    case "getPresentedViewController":
      // TODO: Implement logic to get the presented paywall view controller
      result(FlutterMethodNotImplemented)

    case "getLatestPaywallInfoBridgeId":
      // Implement logic to get the latest PaywallInfo object
      let paywallInfo = Superwall.shared.latestPaywallInfo
      result(paywallInfo?.createBridgeId())

    case "getSubscriptionStatusBridgeId":
      // Implement logic to get the subscription status of the user
      let subscriptionStatusBridgeId = Superwall.shared.subscriptionStatus.createBridgeId()
      result(subscriptionStatusBridgeId)

    case "setSubscriptionStatus":
      // Implement logic to set the subscription status of the user
      guard
        let subscriptionStatusBridge: SubscriptionStatusBridge = call.bridgeInstance(
          for: "subscriptionStatusBridgeId")
      else {
        result(call.badArgs)
        return
      }

      Superwall.shared.subscriptionStatus = subscriptionStatusBridge.status
      result(nil)

    case "getConfigurationStatusBridgeId":
      // Implement logic to check the configuration status of Superwall
      let configurationStatusBridgeId = Superwall.shared.configurationStatus.createBridgeId()
      result(configurationStatusBridgeId)

    case "getLocaleIdentifier":
      // Implement logic to check if Superwall has finished configuring
      result(Superwall.shared.localeIdentifier)

    case "setLocaleIdentifier":
      guard let identifier: String? = call.argument(for: "localeIdentifier") else {
        result(call.badArgs)
        return
      }

      Superwall.shared.localeIdentifier = identifier

      result(nil)

    case "getIsPaywallPresented":
      // Implement logic to check if a paywall is currently being presented
      result(Superwall.shared.isPaywallPresented)

    case "preloadAllPaywalls":
      // Implement logic to preload all paywalls
      Superwall.shared.preloadAllPaywalls()
      result(nil)

    case "preloadPaywallsForPlacements":
      // Implement logic to preload paywalls for specific placement names
      if let placementNames: [String] = call.argument(for: "placementNames") {
        Superwall.shared.preloadPaywalls(forPlacements: Set(placementNames))
      }
      result(nil)

    case "handleDeepLink":
      // Implement logic to handle deep links for paywall previews
      if let urlString: String = call.argument(for: "url"), let url = URL(string: urlString) {
        let handled = Superwall.shared.handleDeepLink(url)
        result(handled)
      } else {
        result(call.badArgs)
      }

    case "togglePaywallSpinner":
      // Implement logic to toggle the paywall loading spinner
      if let isHidden: Bool = call.argument(for: "isHidden") {
        Superwall.shared.togglePaywallSpinner(isHidden: isHidden)
      }
      result(nil)

    case "reset":
      // Implement logic to reset the user ID, on-device paywall assignments, and stored data
      Superwall.shared.reset()
      result(nil)

    case "configure":
      // Implement logic to configure the Superwall instance
      guard let apiKey: String = call.argument(for: "apiKey") else {
        result(call.badArgs)
        return
      }
      let purchaseControllerProxyBridge: PurchaseControllerProxyBridge? = call.bridgeInstance(
        for: "purchaseControllerProxyBridgeId")

      let options: SuperwallOptions? = {
        guard let optionsValue: [String: Any] = call.argument(for: "options") else {
          return nil
        }

        let options = SuperwallOptions.fromJson(optionsValue)
        return options
      }()

      Superwall.configure(
        apiKey: apiKey, purchaseController: purchaseControllerProxyBridge, options: options
      ) {
        let completionBlockProxyBridge: CompletionBlockProxyBridge? = call.bridgeInstance(
          for: "completionBlockProxyBridgeId")
        completionBlockProxyBridge?.callCompletionBlock()
      }

      // Set the platform wrapper
      let sdkVersion = call.argument(for: "sdkVersion") ?? ""
      Superwall.shared.setPlatformWrapper("Flutter", version: sdkVersion)

      // Returning nil instead of the result from configure because we want to use the Dart
      // instance of Superwall, not a native variant
      result(nil)

    case "dismiss":
      Task {
        await Superwall.shared.dismiss()
        result(nil)
      }

    case "registerPlacement":
      guard let placement: String = call.argument(for: "placement") else {
        result(call.badArgs)
        return
      }

      let params: [String: Any]? = call.argument(for: "params")

      let handler: PaywallPresentationHandler? = {
        guard
          let handlerProxyBridge: PaywallPresentationHandlerProxyBridge = call.bridgeInstance(
            for: "handlerProxyBridgeId")
        else {
          return nil
        }

        return handlerProxyBridge.handler
      }()

      Superwall.shared.register(placement: placement, params: params, handler: handler) {
        if let featureBlockProxyBridge: CompletionBlockProxyBridge = call.bridgeInstance(
          for: "featureBlockProxyBridgeId")
        {
          featureBlockProxyBridge.callCompletionBlock()
        }
      }

      result(nil)

    case "identify":
      guard let userId: String = call.argument(for: "userId") else {
        result(call.badArgs)
        return
      }

      let options: IdentityOptions? = {
        guard let identityOptionsJson: [String: Any] = call.argument(for: "identityOptions") else {
          return nil
        }

        return IdentityOptions.fromJson(identityOptionsJson)
      }()

      Superwall.shared.identify(userId: userId, options: options)

      result(nil)
    case "confirmAllAssignments":
      Superwall.shared.confirmAllAssignments { assignments in
        result(assignments.map { $0.toJson() })
      }
    case "getEntitlements":
      let entitlements = Superwall.shared.entitlements
      result(entitlements.toJson())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
