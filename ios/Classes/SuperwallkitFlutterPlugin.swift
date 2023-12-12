import Flutter
import UIKit
import SuperwallKit

public class SuperwallkitFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Define the list of plugin types that conform to FlutterPlugin.
    // Make sure each plugin type conforms to `FlutterPlugin`.
    // Add additional classes using Xcode, not Android Studio.
    let pluginTypes: [FlutterPlugin.Type] = [
      SubscriptionStatusPlugin.self,
      LogLevelPlugin.self,
      PaywallInfoPlugin.self,
      PublicPresentationPlugin.self,
      PurchaseResultPlugin.self,
      RestorationResultPlugin.self,
      SuperwallPlugin.self,
    ]

    // Iterate over the plugin types and call the `register(with:)` method on each one.
    pluginTypes.forEach { pluginType in
      pluginType.register(with: registrar)
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterMethodNotImplemented)
  }
}

extension FlutterMethodCall {
  func argument<T>(for key: String) -> T? {
    return (arguments as? [String: Any])?[key] as? T
  }
}

extension FlutterError {
  static func badArgs(for method: String) -> FlutterError {
    return FlutterError(code: "BAD_ARGS", message: "Missing or invalid arguments for '\(method)'", details: nil)
  }
}
