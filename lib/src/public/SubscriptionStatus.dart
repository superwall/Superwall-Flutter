import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// An enum representing the subscription status of the user.
class SubscriptionStatus {
  final BridgeId bridgeId;

  SubscriptionStatus._privateConstructor(this.bridgeId) {
    bridgeId.associate(this);
  }

  static final SubscriptionStatus active = SubscriptionStatus._privateConstructor(BridgingCreator.createSubscriptionStatusActiveBridgeId());
  static final SubscriptionStatus inactive = SubscriptionStatus._privateConstructor(BridgingCreator.createSubscriptionStatusInactiveBridgeId());
  static final SubscriptionStatus unknown = SubscriptionStatus._privateConstructor(BridgingCreator.createSubscriptionStatusUnknownBridgeId());

  static SubscriptionStatus? subscriptionStatusFrom(BridgeId bridgeId) {
    // TODO: Improve this. Identifier should be implementation detail of BridgingCreator
    switch (bridgeId.bridgeClass) {
      case "SubscriptionStatusActiveBridge":
        return SubscriptionStatus.active;
      case "SubscriptionStatusInactiveBridge":
        return SubscriptionStatus.inactive;
      case "SubscriptionStatusUnknownBridge":
        return SubscriptionStatus.unknown;
      default:
        return null;
    }
  }

  Future<String> get description async {
    return await bridgeId.communicator.invokeBridgeMethod('getDescription');
  }
}