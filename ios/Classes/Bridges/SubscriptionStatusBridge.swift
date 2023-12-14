import Flutter
import SuperwallKit

public class SubscriptionStatusBridge: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "SWK_SubscriptionStatusBridge", binaryMessenger: registrar.messenger())
    let instance = SubscriptionStatusBridge()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getDescription" {
      guard let args = call.arguments as? [String: Any],
            let statusRawValue = args["status"] as? Int,
            let status = SubscriptionStatus(rawValue: statusRawValue) else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for getDescription", details: nil))
        return
      }
      
      let description = status.description
      result(description)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
