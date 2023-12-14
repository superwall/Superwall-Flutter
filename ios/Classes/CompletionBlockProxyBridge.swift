import Flutter
import UIKit
import SuperwallKit

extension CompletionBlockProxyBridge: FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {}
}

public class CompletionBlockProxyBridge: NSObject, Bridgeable {
  static let name: String = "CompletionBlockProxyBridge"

  let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  func callCompletionBlock(value: Any? = nil) {
    channel.invokeMethod("callCompletionBlock", arguments: value)
  }
}
