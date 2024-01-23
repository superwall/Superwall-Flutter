import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// An enum representing the subscription status of the user.
class SubscriptionStatus extends BridgeIdInstantiable {
  SubscriptionStatus({ required BridgeClass bridgeClass, BridgeId? bridgeId }): super(bridgeClass: bridgeClass, bridgeId: bridgeId);

  static final SubscriptionStatus active = SubscriptionStatusActive();
  static final SubscriptionStatus inactive = SubscriptionStatusInactive();
  static final SubscriptionStatus unknown = SubscriptionStatusUnknown();

  static SubscriptionStatus? createSubscriptionStatusFromBridgeId(BridgeId bridgeId) {
    switch (bridgeId.bridgeClass) {
      case SubscriptionStatusActive.bridgeClass:
        return SubscriptionStatus.active;
      case SubscriptionStatusInactive.bridgeClass:
        return SubscriptionStatus.inactive;
      case SubscriptionStatusUnknown.bridgeClass:
        return SubscriptionStatus.unknown;
      default:
        return null;
    }
  }

  Future<String> get description async {
    return await bridgeId.communicator.invokeBridgeMethod('getDescription');
  }
}

class SubscriptionStatusActive extends SubscriptionStatus {
  static const BridgeClass bridgeClass = "SubscriptionStatusActiveBridge";
  SubscriptionStatusActive({ BridgeId? bridgeId }): super(bridgeClass: bridgeClass, bridgeId: bridgeId);
}

class SubscriptionStatusInactive extends SubscriptionStatus {
  static const BridgeClass bridgeClass = "SubscriptionStatusInactiveBridge";
  SubscriptionStatusInactive({ BridgeId? bridgeId }): super(bridgeClass: bridgeClass, bridgeId: bridgeId);
}

class SubscriptionStatusUnknown extends SubscriptionStatus {
  static const BridgeClass bridgeClass = "SubscriptionStatusUnknownBridge";
  SubscriptionStatusUnknown({ BridgeId? bridgeId }): super(bridgeClass: bridgeClass, bridgeId: bridgeId);
}