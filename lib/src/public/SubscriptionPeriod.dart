import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The unit of a [SubscriptionPeriod].
enum SubscriptionPeriodUnit {
  day,
  week,
  month,
  year;

  static SubscriptionPeriodUnit fromPigeon(PSubscriptionPeriodUnit pigeon) {
    switch (pigeon) {
      case PSubscriptionPeriodUnit.day:
        return SubscriptionPeriodUnit.day;
      case PSubscriptionPeriodUnit.week:
        return SubscriptionPeriodUnit.week;
      case PSubscriptionPeriodUnit.month:
        return SubscriptionPeriodUnit.month;
      case PSubscriptionPeriodUnit.year:
        return SubscriptionPeriodUnit.year;
    }
  }
}

/// The length of a subscription period, such as 1 month or 3 days.
class SubscriptionPeriod {
  /// The number of [unit]s in the period.
  final int value;

  /// The unit the period is measured in.
  final SubscriptionPeriodUnit unit;

  const SubscriptionPeriod({required this.value, required this.unit});

  factory SubscriptionPeriod.fromPigeon(PSubscriptionPeriod pigeon) {
    return SubscriptionPeriod(
      value: pigeon.value,
      unit: SubscriptionPeriodUnit.fromPigeon(pigeon.unit),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SubscriptionPeriod &&
      other.value == value &&
      other.unit == unit;

  @override
  int get hashCode => Object.hash(value, unit);

  @override
  String toString() => 'SubscriptionPeriod(value: $value, unit: ${unit.name})';
}
