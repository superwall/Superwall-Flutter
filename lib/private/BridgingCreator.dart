import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

typedef Bridge = String;

class BridgingCreator {
  static const MethodChannel _channel = MethodChannel('SWK_BridgingCreator');

  static final _bridgesByChannelName = {};

  static Bridge _createBridge(String bridgeName) {
    final instanceIdentifier = Uuid().v4();
    final channelName = bridgeName + "-" + instanceIdentifier;
    _bridgesByChannelName[channelName] = { "bridgeName" : bridgeName, "instanceIdentifier" : instanceIdentifier };

    return channelName;
  }

  static _invokeCreation(String channelName) async {
    final metadata = BridgingCreator._bridgesByChannelName[channelName];
    final bridgeName = metadata["bridgeName"];

    await _channel.invokeMethod("createBridge", { "bridgeName" : bridgeName, "channelName" : channelName});

    metadata["bridgeCreated"] = "true";
    _bridgesByChannelName[channelName] = metadata;
  }

  //region Creators - NOTE: In order to create a bridge, it MUST exist in
  // the `bridgeMap` on the native sides

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

extension MethodChannelBridging on MethodChannel {
  // Will invoke the method as usual, but will wait for the bridge to be created if it doesn't already exist
  Future<T?> invokeBridgeMethod<T>(String method, [ dynamic arguments ]) async {
    final metadata = BridgingCreator._bridgesByChannelName[this.name];
    assert(metadata != null, "Attempting to invoke a method on a bridge that has not been created by the BridgeCreator.");

    final bridgeCreated = metadata["bridgeCreated"];
    if (bridgeCreated == null) {
      final channelName = this.name;
      await BridgingCreator._invokeCreation(channelName);
    }

    return invokeMethod(method, arguments);
  }
}

// Stores a reference to a dart instance that receives responses from the native side.
extension BridgeAssociation on Bridge {
  static final List<dynamic> associatedInstances = [];

  associate(dynamic dartInstance) {
    BridgeAssociation.associatedInstances.add(dartInstance);
  }
}