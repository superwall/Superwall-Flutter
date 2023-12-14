import 'package:flutter/services.dart';

class BridgingCreator {
  static const MethodChannel _channel = MethodChannel('SWK_BridgingCreatorPlugin');

  static Future<String> createSuperwallPlugin() async {
    final channelName = await _channel.invokeMethod("createSuperwallPlugin");
    return channelName;
  }

  static Future<String> createSuperwallDelegateProxyPlugin() async {
    final channelName = await _channel.invokeMethod("createSuperwallDelegateProxyPlugin");
    return channelName;
  }

  static Future<String> createPurchaseControllerProxyPlugin() async {
    final channelName = await _channel.invokeMethod("createPurchaseControllerProxyPlugin");
    return channelName;
  }
}