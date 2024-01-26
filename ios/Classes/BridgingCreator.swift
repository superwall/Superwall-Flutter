import Flutter
import UIKit
import SuperwallKit

/// Creates a method channel for a particular unique instance of a class
public class BridgingCreator: NSObject, FlutterPlugin {
  static private var _shared: BridgingCreator? = nil
  static var shared: BridgingCreator {
    guard let shared = _shared else {
      fatalError("Attempting to access the shared BridgingCreator before `register(with registrar: FlutterPluginRegistrar)` has been called.")
    }

    return shared
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
    BridgingCreator._shared = bridge

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
      assertionFailure("Unable to find a bridgeClass for \(bridgeId.bridgeClass). Make sure to add to BridgingCreator+Constants.swift")
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
