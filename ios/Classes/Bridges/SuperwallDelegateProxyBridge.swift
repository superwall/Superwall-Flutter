import Flutter
import SuperwallKit

public class SuperwallDelegateProxyBridge: BridgeInstance, SuperwallDelegate {
  override class var bridgeClass: BridgeClass { "SuperwallDelegateProxyBridge" }

  // MARK: - SuperwallDelegate

  public func willPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    communicator.invokeMethod("willPresentPaywall", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
  }

  public func didPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    communicator.invokeMethod("didPresentPaywall", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
  }

  public func willDismissPaywall(withInfo paywallInfo: PaywallInfo) {
    communicator.invokeMethod("willDismissPaywall", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
  }

  public func didDismissPaywall(withInfo paywallInfo: PaywallInfo) {
    communicator.invokeMethod("didDismissPaywall", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
  }

  public func handleCustomPaywallAction(withName name: String) {
    communicator.invokeMethod("handleCustomPaywallAction", arguments: ["name": name])
  }

  public func subscriptionStatusDidChange(to newValue: SubscriptionStatus) {
    communicator.invokeMethod("subscriptionStatusDidChange", arguments: ["subscriptionStatusBridgeId": newValue.createBridgeId()])
  }

  // TODO
  //    public func handleSuperwallEvent(withInfo eventInfo: SuperwallEventInfo) {
  //        channel.invokeMethod("handleSuperwallEvent", arguments: eventInfo.toJson())
  //    }

  public func paywallWillOpenURL(url: URL) {
    communicator.invokeMethod("paywallWillOpenURL", arguments: ["url" : url.absoluteString])
  }

  public func paywallWillOpenDeepLink(url: URL) {
    communicator.invokeMethod("paywallWillOpenDeepLink", arguments: ["url" : url.absoluteString])
  }
}

