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

  public func handleLog(
    level: String,
    scope: String,
    message: String?,
    info: [String: Any]?,
    error: Swift.Error?
  ) {
    let transformedInfo = info?.compactMapValues { value -> Any? in
      switch value {
        case let stringValue as String:
          return stringValue
        case let intValue as Int:
          return intValue
        case let dictValue as [String: Any]:
          return dictValue
        case let arrayValue as [Any]:
          return arrayValue
        case let boolValue as Bool:
          return boolValue
        case let setValue as Set<AnyHashable>:
          return Array(setValue)
        default:
          return nil
      }
    }

    let arguments: [String: Any?] = [
      "level": level,
      "scope": scope,
      "message": message,
      "info": transformedInfo,
      "error": error?.localizedDescription
    ]
    communicator.invokeMethodOnMain("handleLog", arguments: arguments)
  }
}

