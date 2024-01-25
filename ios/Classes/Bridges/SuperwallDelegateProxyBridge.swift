import Flutter
import SuperwallKit

public class SuperwallDelegateProxyBridge: BridgeInstance, SuperwallDelegate {
  override class var bridgeClass: BridgeClass { "SuperwallDelegateProxyBridge" }

  // MARK: - SuperwallDelegate

  public func willPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    communicator.invokeMethodOnMain("willPresentPaywall", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
  }

  public func didPresentPaywall(withInfo paywallInfo: PaywallInfo) {
    communicator.invokeMethodOnMain("didPresentPaywall", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
  }

  public func willDismissPaywall(withInfo paywallInfo: PaywallInfo) {
    communicator.invokeMethodOnMain("willDismissPaywall", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
  }

  public func didDismissPaywall(withInfo paywallInfo: PaywallInfo) {
    communicator.invokeMethodOnMain("didDismissPaywall", arguments: ["paywallInfoBridgeId": paywallInfo.createBridgeId()])
  }

  public func handleCustomPaywallAction(withName name: String) {
    communicator.invokeMethodOnMain("handleCustomPaywallAction", arguments: ["name": name])
  }

  public func subscriptionStatusDidChange(to newValue: SubscriptionStatus) {
    communicator.invokeMethodOnMain("subscriptionStatusDidChange", arguments: ["subscriptionStatusBridgeId": newValue.createBridgeId()])
  }

  public func handleSuperwallEvent(withInfo eventInfo: SuperwallEventInfo) {
    communicator.invokeMethodOnMain("handleSuperwallEvent", arguments: ["eventInfo": eventInfo.toJson()])
  }

  public func paywallWillOpenURL(url: URL) {
    communicator.invokeMethodOnMain("paywallWillOpenURL", arguments: ["url" : url.absoluteString])
  }

  public func paywallWillOpenDeepLink(url: URL) {
    communicator.invokeMethodOnMain("paywallWillOpenDeepLink", arguments: ["url" : url.absoluteString])
  }
}

