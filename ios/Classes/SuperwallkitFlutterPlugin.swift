import Flutter
import UIKit
import SuperwallKit

public class SuperwallkitFlutterPlugin: NSObject, FlutterPlugin {
  private static var alreadyRegistered = false
  private static var superwallProxy: SuperwallProxy?

  public static func register(with registrar: FlutterPluginRegistrar) {
    // This should get called on the main thread by default
    if alreadyRegistered {
      return
    }
    alreadyRegistered = true

    // Initialize the SuperwallProxy
    superwallProxy = SuperwallProxy(flutterBinaryMessenger: registrar.messenger())
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterMethodNotImplemented)
  }
}


extension Dictionary where Key == String {
  func argument<T>(for key: String) -> T? {
    return self[key] as? T
  }
}

