import Flutter
import SuperwallKit

public class SubscriptionStatusBridge: BaseBridge {
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getDescription":
        guard let statusRawValue: Int = call.argument(for: "status"),
              let status = SubscriptionStatus(rawValue: statusRawValue) else {
          result(call.badArgs)
          return
        }

        let description = status.description
        result(description)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
