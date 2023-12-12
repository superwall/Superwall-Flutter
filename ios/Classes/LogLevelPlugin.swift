import Flutter
import UIKit
import SuperwallKit

public class LogLevelPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "SWK_LogLevelPlugin", binaryMessenger: registrar.messenger())
    let instance = LogLevelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let levelValue = args["level"] as? Int,
          let logLevel = LogLevel(rawValue: levelValue) else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid log level", details: nil))
      return
    }

    switch call.method {
      case "getLogLevelDescription":
        result(logLevel.description)
      case "getLogLevelDescriptionEmoji":
        result(logLevel.descriptionEmoji)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
