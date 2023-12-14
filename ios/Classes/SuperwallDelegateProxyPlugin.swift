import Flutter
import UIKit
import SuperwallKit

extension SuperwallDelegateProxyPlugin: FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {}
}

public class SuperwallDelegateProxyPlugin: NSObject, Bridgeable, SuperwallDelegate {
  static let name: String = "SuperwallDelegateProxyPlugin"

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
