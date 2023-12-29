import Flutter
import SuperwallKit

public class BaseBridge: NSObject {
  let channel: FlutterMethodChannel

  required init(channel: FlutterMethodChannel) {
    self.channel = channel
  }
}

extension BaseBridge: FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {}
}
