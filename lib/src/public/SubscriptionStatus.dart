import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// An enum representing the subscription status of the user.
class SubscriptionStatus {
  final _SubscriptionStatusType _type;
  final Bridge bridge;
  final MethodChannel channel;

  SubscriptionStatus._privateConstructor(this._type, this.bridge): channel = MethodChannel(bridge) {
    bridge.associate(this);
  }

  static final SubscriptionStatus active = SubscriptionStatus._privateConstructor(_SubscriptionStatusType.active, BridgingCreator.createSubscriptionStatusActiveBridge());
  static final SubscriptionStatus inactive = SubscriptionStatus._privateConstructor(_SubscriptionStatusType.inactive, BridgingCreator.createSubscriptionStatusInactiveBridge());
  static final SubscriptionStatus unknown = SubscriptionStatus._privateConstructor(_SubscriptionStatusType.unknown, BridgingCreator.createSubscriptionStatusUnknownBridge());

  Future<String> get description async {
    final String description = await channel.invokeBridgeMethod('getDescription');
    return description;
  }

  // String toJson() {
  //   return _type.toJson();
  // }

  static SubscriptionStatus fromJson(String json) {
    return _SubscriptionStatusTypeExtension.fromJson(json);
  }
}

enum _SubscriptionStatusType {
  active,
  inactive,
  unknown,
}

extension _SubscriptionStatusTypeExtension on _SubscriptionStatusType {
  // String toJson() {
  //   switch (this) {
  //     case _SubscriptionStatusType.active:
  //       return 'active';
  //     case _SubscriptionStatusType.inactive:
  //       return 'inactive';
  //     case _SubscriptionStatusType.unknown:
  //       return 'unknown';
  //     default:
  //       throw ArgumentError('Invalid SubscriptionStatus value');
  //   }
  // }

  static SubscriptionStatus fromJson(String json) {
    switch (json) {
      case 'active':
        return SubscriptionStatus.active;
      case 'inactive':
        return SubscriptionStatus.inactive;
      case 'unknown':
        return SubscriptionStatus.unknown;
      default:
        throw ArgumentError('Invalid SubscriptionStatus value: $json');
    }
  }
}