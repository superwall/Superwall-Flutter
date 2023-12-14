import 'package:flutter/services.dart';

typedef Bridge = String;

class BridgingCreator {
  static const MethodChannel _channel = MethodChannel('SWK_BridgingCreator');

  static Future<Bridge> createSuperwallBridge() async {
    final channelName = await _channel.invokeMethod("createSuperwallBridge");
    return channelName;
  }

  static Future<Bridge> createSuperwallDelegateProxyBridge() async {
    final channelName = await _channel.invokeMethod("createSuperwallDelegateProxyBridge");
    return channelName;
  }

  static Future<Bridge> createPurchaseControllerProxyBridge() async {
    final channelName = await _channel.invokeMethod("createPurchaseControllerProxyBridge");
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