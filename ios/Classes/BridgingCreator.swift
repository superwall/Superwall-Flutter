import Flutter
import UIKit
import SuperwallKit

protocol Bridgeable {
  static var name: String { get }
}

/// Creates a method channel for a particular unique instance of a class
public class BridgingCreator: NSObject, FlutterPlugin {
  // TODO: CHANGE
  static var shared: BridgingCreator!

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

    let plugin = BridgingCreator(registrar: registrar)
    BridgingCreator.shared = plugin

    registrar.addMethodCallDelegate(plugin, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "createSuperwallBridge":
        result(createSuperwallBridge())
      case "createSuperwallDelegateProxyBridge":
        result(createSuperwallDelegateProxyBridge())
      case "createPurchaseControllerProxyBridge":
        result(createPurchaseControllerProxyBridge())
      case "createCompletionBlockProxyBridge":
        result(createCompletionBlockProxyBridge())
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

extension BridgingCreator {
  func createSuperwallBridge() -> String {
    let name = "\(SuperwallBridge.name)-\(UUID().uuidString)"
    let channel = FlutterMethodChannel(name: name, binaryMessenger: registrar.messenger())

    let plugin = SuperwallBridge(channel: channel)
    instances.updateValue(plugin, forKey: name)

    registrar.addMethodCallDelegate(plugin, channel: channel)

    return name
  }
}

extension BridgingCreator {
  func createSuperwallDelegateProxyBridge() -> String {
    let name = "\(SuperwallDelegateProxyBridge.name)-\(UUID().uuidString)"
    let channel = FlutterMethodChannel(name: name, binaryMessenger: registrar.messenger())

    let plugin = SuperwallDelegateProxyBridge(channel: channel)
    instances.updateValue(plugin, forKey: name)

    registrar.addMethodCallDelegate(plugin, channel: channel)

    return name
  }
}

extension BridgingCreator {
  func createPurchaseControllerProxyBridge() -> String {
    let name = "\(PurchaseControllerProxyBridge.name)-\(UUID().uuidString)"
    let channel = FlutterMethodChannel(name: name, binaryMessenger: registrar.messenger())

    let plugin = PurchaseControllerProxyBridge(channel: channel)
    instances.updateValue(plugin, forKey: name)

    registrar.addMethodCallDelegate(plugin, channel: channel)

    return name
  }
}

extension BridgingCreator {
  func createCompletionBlockProxyBridge() -> String {
    let name = "\(CompletionBlockProxyBridge.name)-\(UUID().uuidString)"
    let channel = FlutterMethodChannel(name: name, binaryMessenger: registrar.messenger())

    let plugin = CompletionBlockProxyBridge(channel: channel)
    instances.updateValue(plugin, forKey: name)

    registrar.addMethodCallDelegate(plugin, channel: channel)

    return name
  }
}
