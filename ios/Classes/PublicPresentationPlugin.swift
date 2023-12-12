import Flutter
import UIKit
import SuperwallKit

public class PublicPresentationPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "SWK_PublicPresentationPlugin", binaryMessenger: registrar.messenger())
    let instance = PublicPresentationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "dismiss":
        Task {
          await Superwall.shared.dismiss()
          result(nil)
        }
        
      case "registerEventWithFeature":
        guard let args = call.arguments as? [String: Any],
              let event = args["event"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for registerEventWithFeature", details: nil))
          return
        }
        
        let params = args["params"] as? [String: Any]

        Superwall.shared.register(event: event, params: params) {
          // TODO: Handle state updates
        }
        result(nil)
        
      case "registerEvent":
        guard let args = call.arguments as? [String: Any],
              let event = args["event"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for registerEvent", details: nil))
          return
        }

        let params = args["params"] as? [String: Any]

        Superwall.shared.register(event: event, params: params, handler: nil)
        result(nil)
        
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
