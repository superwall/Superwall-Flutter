import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

typedef Bridge = String;

class BridgingCreator {
  static const MethodChannel _channel = MethodChannel('SWK_BridgingCreator');

  static String _createBridge(String bridgeName) {
    final instanceIdentifier = Uuid().v4();
    final channelName = bridgeName + "-" + instanceIdentifier;
    _invokeCreation(bridgeName, channelName);
    return channelName;
  }

  static _invokeCreation(String bridgeName, String channelName) async {
    await _channel.invokeMethod("createBridge", { "bridgeName" : bridgeName, "channelName" : channelName});
  }

  //region Creators

  static Bridge createSuperwallBridge() {
    return _createBridge("SuperwallBridge");
  }

  static Bridge createSuperwallDelegateProxyBridge() {
    return _createBridge("SuperwallDelegateProxyBridge");
  }

  static Bridge createPurchaseControllerProxyBridge() {
    return _createBridge("PurchaseControllerProxyBridge");
  }

  static Bridge createCompletionBlockProxyBridge() {
    return _createBridge("CompletionBlockProxyBridge");
  }

  static Bridge createSubscriptionStatusBridge() {
    return _createBridge("SubscriptionStatusBridge");
  }

  //endregion
}

// Stores a reference to a dart instance that receives responses from the native side.
extension BridgeAssociation on Bridge {
  static final List<dynamic> associatedInstances = [];

  associate(dynamic dartInstance) {
    BridgeAssociation.associatedInstances.add(dartInstance);
  }
}