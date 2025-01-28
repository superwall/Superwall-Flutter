import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/Entitlement.dart';

/// An enum representing the entitlement status of the user.
class EntitlementStatus extends BridgeIdInstantiable {
  EntitlementStatus({required super.bridgeClass, super.bridgeId});

  static final EntitlementStatus active = EntitlementStatusActive();
  static final EntitlementStatus inactive = EntitlementStatusInactive();
  static final EntitlementStatus unknown = EntitlementStatusUnknown();

  static EntitlementStatus? createEntitlementStatusFromBridgeId(
      BridgeId bridgeId) {
    switch (bridgeId.bridgeClass) {
      case EntitlementStatusActive.bridgeClass:
        return EntitlementStatus.active;
      case EntitlementStatusInactive.bridgeClass:
        return EntitlementStatus.inactive;
      case EntitlementStatusUnknown.bridgeClass:
        return EntitlementStatus.unknown;
      default:
        return null;
    }
  }

  Future<String> get description async {
    return await bridgeId.communicator.invokeBridgeMethod('getDescription');
  }
}

class EntitlementStatusActive extends EntitlementStatus {
  static const BridgeClass bridgeClass = 'EntitlementStatusActiveBridge';
  final Set<Entitlement> entitlements;

  EntitlementStatusActive({
    super.bridgeId,
    required this.entitlements,
  }) : super(bridgeClass: bridgeClass);
}

class EntitlementStatusInactive extends EntitlementStatus {
  static const BridgeClass bridgeClass = 'EntitlementStatusInactiveBridge';
  EntitlementStatusInactive({super.bridgeId}) : super(bridgeClass: bridgeClass);
}

class EntitlementStatusUnknown extends EntitlementStatus {
  static const BridgeClass bridgeClass = 'EntitlementStatusUnknownBridge';
  EntitlementStatusUnknown({super.bridgeId}) : super(bridgeClass: bridgeClass);
}
