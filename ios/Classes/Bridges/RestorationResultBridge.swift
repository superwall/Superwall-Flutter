import Flutter
import SuperwallKit

public class RestorationResultBridge: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "SWK_RestorationResultBridge", binaryMessenger: registrar.messenger())
    let instance = RestorationResultBridge()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  // TODO
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "isEqualTo" {
      guard let args = call.arguments as? [String: Any],
            let result1 = args["result1"] as? String,
            let result2 = args["result2"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for isEqualTo", details: nil))
        return
      }
      
      // Implement equality logic here based on the result1 and result2 strings
      // and the optional data associated with them if necessary.
      let isEqual = (result1 == result2) // Simplified example; adjust as needed
      result(isEqual)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
