import Flutter
import UIKit
import SuperwallKit

/// Creates a method channel for a particular unique instance of a class
public class BridgingCreator: NSObject, FlutterPlugin {
  // TODO: CHANGE
  static var shared: BridgingCreator!

  struct Constants {
    static let bridgeMap: [String: BaseBridge.Type] = [
      "LogLevelBridge": LogLevelBridge.self,
      "PaywallInfoBridge": PaywallInfoBridge.self,
      "PurchaseControllerProxyBridge": PurchaseControllerProxyBridge.self,
      "PurchaseResultBridge": PurchaseResultBridge.self,
      "RestorationResultBridge": RestorationResultBridge.self,
      "SubscriptionStatusBridge": SubscriptionStatusBridge.self,
      "SuperwallDelegateProxyBridge": SuperwallDelegateProxyBridge.self,
      "CompletionBlockProxyBridge": CompletionBlockProxyBridge.self,
      "SuperwallBridge": SuperwallBridge.self,
    ]
  }

  private let registrar: FlutterPluginRegistrar
  private var instances: [String: Any] = [:]

  init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
  }

  func bridge<T>(for channelName: String) -> T? {
    return instances[channelName] as? T
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "SWK_BridgingCreator", binaryMessenger: registrar.messenger())

    let bridge = BridgingCreator(registrar: registrar)
    BridgingCreator.shared = bridge

    registrar.addMethodCallDelegate(bridge, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "createBridge":
        guard
          let bridgeName: String = call.argument(for: "bridgeName"),
          let channelName: String = call.argument(for: "channelName") else {
          print("WARNING: Unable to create bridge")
          return
        }

        createBridge(bridgeName: bridgeName, channelName: channelName)
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func createBridge(bridgeName: String, channelName: String) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())

    guard let classType = BridgingCreator.Constants.bridgeMap[bridgeName] else {
      assertionFailure("Unable to find a bridge type for \(bridgeName). Make sure to add to BridgingCreator.swift")
      return
    }

    let bridge = classType.init(channel: channel)
    instances.updateValue(bridge, forKey: channelName)

    registrar.addMethodCallDelegate(bridge, channel: channel)
  }
}
