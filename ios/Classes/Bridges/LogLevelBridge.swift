import Flutter
import UIKit
import SuperwallKit

public class LogLevelBridge: BaseBridge {
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
