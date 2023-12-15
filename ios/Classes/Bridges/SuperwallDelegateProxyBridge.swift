import Flutter
import UIKit
import SuperwallKit

// TODO
public class SuperwallDelegateProxyBridge: BaseBridge, SuperwallDelegate {

  // MARK: - SuperwallDelegate

  public func willPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    // TODO: args
    channel.invokeMethod("willPresentPaywall", arguments: paywallInfo.description)
  }

  public func handleCustomPaywallAction(withName name: String) {
    // TODO: args
    channel.invokeMethod("handleCustomPaywallAction", arguments: name)
  }
}
