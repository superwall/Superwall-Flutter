import Flutter
import UIKit
import SuperwallKit

/// Creates a method channel for a particular unique instance of a class
public class BridgingCreator: NSObject, FlutterPlugin {
  // TODO: CHANGE
  static var shared: BridgingCreator!

  struct Constants {
    // TODO: Allow bridges to register themselves
    static let bridgeMap: [String: BridgeInstance.Type] = [
      "SuperwallBridge": SuperwallBridge.self,
      "SuperwallDelegateProxyBridge": SuperwallDelegateProxyBridge.self,
      "PurchaseControllerProxyBridge": PurchaseControllerProxyBridge.self,
      "CompletionBlockProxyBridge": CompletionBlockProxyBridge.self,
      "SubscriptionStatusActiveBridge": SubscriptionStatusActiveBridge.self,
      "SubscriptionStatusInactiveBridge": SubscriptionStatusInactiveBridge.self,
      "SubscriptionStatusUnknownBridge": SubscriptionStatusUnknownBridge.self,
      "PaywallPresentationHandlerProxyBridge": PaywallPresentationHandlerProxyBridge.self,
      "PaywallSkippedReasonHoldoutBridge": PaywallSkippedReasonHoldoutBridge.self,
      "PaywallSkippedReasonNoRuleMatchBridge": PaywallSkippedReasonNoRuleMatchBridge.self,
      "PaywallSkippedReasonEventNotFoundBridge": PaywallSkippedReasonEventNotFoundBridge.self,
      "PaywallSkippedReasonUserIsSubscribedBridge": PaywallSkippedReasonUserIsSubscribedBridge.self,
      ExperimentBridge.bridgeClass(): ExperimentBridge.self,
      PaywallInfoBridge.bridgeClass(): PaywallInfoBridge.self,
      PurchaseResultCancelledBridge.bridgeClass(): PurchaseResultCancelledBridge.self,
      PurchaseResultPurchasedBridge.bridgeClass(): PurchaseResultPurchasedBridge.self,
      PurchaseResultRestoredBridge.bridgeClass(): PurchaseResultRestoredBridge.self,
      PurchaseResultPendingBridge.bridgeClass(): PurchaseResultPendingBridge.self,
      PurchaseResultFailedBridge.bridgeClass(): PurchaseResultFailedBridge.self,
      RestorationResultRestoredBridge.bridgeClass(): RestorationResultRestoredBridge.self,
      RestorationResultFailedBridge.bridgeClass(): RestorationResultFailedBridge.self,
    ]
  }

  let registrar: FlutterPluginRegistrar

  private let communicator: Communicator
  private var instances: [String: BridgeInstance] = [:]

  init(registrar: FlutterPluginRegistrar, communicator: Communicator) {
    self.registrar = registrar
    self.communicator = communicator
  }

  func bridgeInstance<T>(for bridgeInstance: BridgeId) -> T? {
    guard let instance = instances[bridgeInstance] as? T else {
      // No instance was found. When calling `invokeBridgeMethod` from Dart, make sure to provide any potentially uninitialized instances
      assertionFailure("Unable to find a bridge instance for \(bridgeInstance).")
      return nil
    }

    return instance
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let communicator = Communicator(name: "SWK_BridgingCreator", binaryMessenger: registrar.messenger())

    let bridge = BridgingCreator(registrar: registrar, communicator: communicator)
    BridgingCreator.shared = bridge

    registrar.addMethodCallDelegate(bridge, channel: communicator)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "createBridgeInstance":
        guard
          let bridgeId: String = call.argument(for: "bridgeId") else {
          print("WARNING: Unable to create bridge instance")
          return
        }

        let initializationArgs: [String: Any]? = call.argument(for: "args")

        createBridgeInstance(bridgeId: bridgeId, initializationArgs: initializationArgs)

        result(nil)

      default:
        result(FlutterMethodNotImplemented)
    }
  }

  // Create the bridge instance as instructed from Dart
  @discardableResult private func createBridgeInstance(bridgeId: BridgeId, initializationArgs: [String: Any]? = nil) -> BridgeInstance {
    // An existing bridge instance might exist if it were created natively, instead of from Dart
    if let existingBridgeInstance = instances[bridgeId] {
      return existingBridgeInstance
    }

    guard let bridgeClass = BridgingCreator.Constants.bridgeMap[bridgeId.bridgeClass] else {
      assertionFailure("Unable to find a bridgeClass for \(bridgeId.bridgeClass). Make sure to add to BridgingCreator.swift")
      return BridgeInstance(bridgeId: bridgeId, initializationArgs: initializationArgs)
    }

    let bridgeInstance = bridgeClass.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
    instances.updateValue(bridgeInstance, forKey: bridgeId)

    registrar.addMethodCallDelegate(bridgeInstance, channel: bridgeInstance.communicator)

    return bridgeInstance
  }

  // Create the bridge instance as instructed from native
  func createBridgeInstance(bridgeClass: BridgeClass, initializationArgs: [String: Any]? = nil) -> BridgeInstance {
    return createBridgeInstance(bridgeId: bridgeClass.generateBridgeId(), initializationArgs: initializationArgs)
  }
}
