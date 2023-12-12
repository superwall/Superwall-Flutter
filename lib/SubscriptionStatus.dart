import 'package:flutter/services.dart';

class SubscriptionStatus {
  final _SubscriptionStatusType _type;
  static const MethodChannel _channel = MethodChannel('SWK_SubscriptionStatusPlugin');

  const SubscriptionStatus._(this._type);

  static const SubscriptionStatus active = SubscriptionStatus._(_SubscriptionStatusType.active);
  static const SubscriptionStatus inactive = SubscriptionStatus._(_SubscriptionStatusType.inactive);
  static const SubscriptionStatus unknown = SubscriptionStatus._(_SubscriptionStatusType.unknown);

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
    final String description = await _channel.invokeMethod('getDescription', {'status': _type.toString()});
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
