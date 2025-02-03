import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/Entitlement.dart';

import '../../superwallkit_flutter.dart';

/// An enum representing the subscription status of the user.
class SubscriptionStatus extends BridgeIdInstantiable {
  SubscriptionStatus({required super.bridgeClass, super.bridgeId, super.initializationArgs = const {}});

  static final SubscriptionStatus inactive = SubscriptionStatusInactive();
  static final SubscriptionStatus unknown = SubscriptionStatusUnknown();

  static Future<SubscriptionStatus?> createSubscriptionStatusFromBridgeId(
      BridgeId bridgeId) async {
    switch (bridgeId.bridgeClass) {
      case SubscriptionStatusActive.bridgeClass:
        var entitlements = await bridgeId.communicator.invokeBridgeMethod('getEntitlements');
        return SubscriptionStatusActive(
            entitlements: (entitlements as List)
                .map((item) => Map<String, dynamic>.from(item as Map))
                .map((it) => Entitlement.fromJson(it))
                .toSet());
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
  static const BridgeClass bridgeClass = 'SubscriptionStatusActiveBridge';
  final Set<Entitlement> entitlements;

  SubscriptionStatusActive({
    super.bridgeId,
    required this.entitlements,
  }) : super(bridgeClass: bridgeClass, initializationArgs: {
    'entitlements': entitlements.map((e) => e?.toJson()).toList()
  });
}

class SubscriptionStatusInactive extends SubscriptionStatus {
  static const BridgeClass bridgeClass = 'SubscriptionStatusInactiveBridge';
  SubscriptionStatusInactive({super.bridgeId})
      : super(bridgeClass: bridgeClass);
}

class SubscriptionStatusUnknown extends SubscriptionStatus {
  static const BridgeClass bridgeClass = 'SubscriptionStatusUnknownBridge';
  SubscriptionStatusUnknown({super.bridgeId})
      : super(bridgeClass: bridgeClass);
}
