import Flutter
import UIKit
import SuperwallKit

extension SuperwallDelegateProxyBridge: FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {}
}

public class SuperwallDelegateProxyBridge: NSObject, Bridgeable, SuperwallDelegate {
  static let name: String = "SuperwallDelegateProxyBridge"

  let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  // MARK: - SuperwallDelegate

  public func willPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    // TODO: args
    channel.invokeMethod("willPresentPaywall", arguments: paywallInfo.description)
  }

  public func handleCustomPaywallAction(withName name: String) {
    // TODO: args
    channel.invokeMethod("handleCustomPaywallAction", arguments: ["name": name])
  }
}
