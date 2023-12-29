import Flutter
import SuperwallKit

public class SuperwallDelegateProxyBridge: BaseBridge, SuperwallDelegate {

  // MARK: - SuperwallDelegate

  public func willPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    channel.invokeMethod("willPresentPaywall", arguments: ["paywallInfo": paywallInfo.toJson()])
  }

  public func didPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    channel.invokeMethod("didPresentPaywall", arguments: ["paywallInfo": paywallInfo.toJson()])
  }

  public func willDismissPaywall(withInfo paywallInfo: PaywallInfo) {
    channel.invokeMethod("willDismissPaywall", arguments: ["paywallInfo": paywallInfo.toJson()])
  }

  public func didDismissPaywall(withInfo paywallInfo: PaywallInfo) {
    channel.invokeMethod("didDismissPaywall", arguments: ["paywallInfo": paywallInfo.toJson()])
  }

  public func handleCustomPaywallAction(withName name: String) {
    channel.invokeMethod("handleCustomPaywallAction", arguments: ["name": name])
  }

  public func subscriptionStatusDidChange(to newValue: SubscriptionStatus) {
    channel.invokeMethod("subscriptionStatusDidChange", arguments: ["newValue": newValue.toJson()])
  }

  //    public func handleSuperwallEvent(withInfo eventInfo: SuperwallEventInfo) {
  //        channel.invokeMethod("handleSuperwallEvent", arguments: eventInfo.toJson())
  //    }

  public func paywallWillOpenURL(url: URL) {
    channel.invokeMethod("paywallWillOpenURL", arguments: ["url" : url.absoluteString])
  }

  public func paywallWillOpenDeepLink(url: URL) {
    channel.invokeMethod("paywallWillOpenDeepLink", arguments: ["url" : url.absoluteString])
  }
}

