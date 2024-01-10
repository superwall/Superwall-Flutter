import Flutter
import SuperwallKit

public class CompletionBlockProxyBridge: BridgeInstance {
  override class var bridgeClass: BridgeClass { "CompletionBlockProxyBridge" }

  func callCompletionBlock(value: Any? = nil) {
    communicator.invokeMethod("callCompletionBlock", arguments: value)
  }
}
