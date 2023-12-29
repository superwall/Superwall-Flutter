import Flutter
import SuperwallKit

public class CompletionBlockProxyBridge: BaseBridge {
  func callCompletionBlock(value: Any? = nil) {
    channel.invokeMethod("callCompletionBlock", arguments: value)
  }
}
