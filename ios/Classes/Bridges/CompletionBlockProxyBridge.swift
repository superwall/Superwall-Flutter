import Flutter
import SuperwallKit

public class CompletionBlockProxyBridge: BridgeInstance {
  func callCompletionBlock(value: Any? = nil) {
    communicator.invokeMethod("callCompletionBlock", arguments: value)
  }
}
