import 'package:flutter/services.dart';

typedef Bridge = String;

class BridgingCreator {
  static const MethodChannel _channel = MethodChannel('SWK_BridgingCreatorPlugin');

  static Future<Bridge> createSuperwallPlugin() async {
    final channelName = await _channel.invokeMethod("createSuperwallPlugin");
    return channelName;
  }

  static Future<Bridge> createSuperwallDelegateProxyPlugin() async {
    final channelName = await _channel.invokeMethod("createSuperwallDelegateProxyPlugin");
    return channelName;
  }

  static Future<Bridge> createPurchaseControllerProxyPlugin() async {
    final channelName = await _channel.invokeMethod("createPurchaseControllerProxyPlugin");
    return channelName;
  }

  static Future<Bridge> createCompletionBlockProxyBridge() async {
    final channelName = await _channel.invokeMethod("createCompletionBlockProxyBridge");
    return channelName;
  }
}

// Stores a reference to a dart instance that receives responses from the native side.
extension BridgeAssociation on Bridge {
  static final List<dynamic> associatedInstances = [];

  associate(dynamic dartInstance) {
    BridgeAssociation.associatedInstances.add(dartInstance);
  }
}