import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/private/BridgingCreator.dart';

class SubscriptionStatus {
  final _SubscriptionStatusType _type;
  final Bridge bridge;
  final MethodChannel channel;

  SubscriptionStatus._privateConstructor(this._type, this.bridge): channel = MethodChannel(bridge) {
    bridge.associate(this);
  }

  static final SubscriptionStatus active = SubscriptionStatus._privateConstructor(_SubscriptionStatusType.active, BridgingCreator.createSubscriptionStatusBridge());
  static final SubscriptionStatus inactive = SubscriptionStatus._privateConstructor(_SubscriptionStatusType.inactive, BridgingCreator.createSubscriptionStatusBridge());
  static final SubscriptionStatus unknown = SubscriptionStatus._privateConstructor(_SubscriptionStatusType.unknown, BridgingCreator.createSubscriptionStatusBridge());

  int get rawValue => _type.value;

  static SubscriptionStatus fromRawValue(int value) {
    switch (value) {
      case 0:
        return SubscriptionStatus.active;
      case 1:
        return SubscriptionStatus.inactive;
      case 2:
        return SubscriptionStatus.unknown;
      default:
        throw ArgumentError('Invalid integer value for SubscriptionStatus');
    }
  }

  Future<String> get description async {
    final String description = await channel.invokeMethod('getDescription', {'status': _type.value});
    return description;
  }
}

enum _SubscriptionStatusType {
  active(0),
  inactive(1),
  unknown(2);

  final int value;
  const _SubscriptionStatusType(this.value);
}
