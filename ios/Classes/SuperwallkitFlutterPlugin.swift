import Flutter
import UIKit
import SuperwallKit

public class SuperwallkitFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    BridgingCreator.register(with: registrar)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterMethodNotImplemented)
  }
}

extension FlutterMethodCall {
  func argument<T>(for key: String) -> T? {
    return (arguments as? [String: Any])?[key] as? T
  }

  // Make sure to provide the key for the bridge (which provides the bridgeId)
  func bridgeInstance<T>(for key: String) -> T? {
    guard let bridgeId: String = argument(for: key) else {
      return nil
    }

    return BridgingCreator.shared.bridgeInstance(for: bridgeId)
  }
}

extension BridgeId {
  func bridgeInstance<T>() -> T? {
    return BridgingCreator.shared.bridgeInstance(for: self)
  }
}

extension FlutterMethodCall {
  var badArgs: FlutterError {
    return FlutterError.badArgs(for: method)
  }
}

extension FlutterMethodChannel {
  func invokeMethodOnMain(_ method: String, arguments: Any? = nil) {
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      invokeMethod(method, arguments: arguments)
    }
  }

  @discardableResult func asyncInvokeMethodOnMain(_ method: String, arguments: Any? = nil) async -> Any? {
    return await withCheckedContinuation { continuation in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        invokeMethod(method, arguments: arguments) { result in
          continuation.resume(returning: result)
        }
      }
    }
  }
}

extension Dictionary where Key == String {
  func argument<T>(for key: String) -> T? {
    return self[key] as? T
  }
}

extension FlutterMethodChannel {
  private static var bridgeIdKey: UInt8 = 0

  var bridgeId: String {
    get {
      guard let name = objc_getAssociatedObject(self, &FlutterMethodChannel.bridgeIdKey) as? String else {
        assertionFailure("bridgeId must be set at initialization of FlutterMethodChannel")
        return ""
      }

      return name
    }
    set(newValue) {
      objc_setAssociatedObject(self, &FlutterMethodChannel.bridgeIdKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}


// TODO: Remove
extension FlutterError {
  static func badArgs(for method: String) -> FlutterError {
    return FlutterError(code: "BAD_ARGS", message: "Missing or invalid arguments for '\(method)'", details: nil)
  }
}
