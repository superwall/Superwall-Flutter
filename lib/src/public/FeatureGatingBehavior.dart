import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// An enum whose cases indicate whether the ``Superwall/register(placement:params:handler:feature:)``
/// `feature` block executes or not.
enum FeatureGatingBehavior {
  gated,
  nonGated,
}

// Extension on FeatureGatingBehavior for explicit serialization and deserialization
extension FeatureGatingBehaviorExtension on FeatureGatingBehavior {
  // Converts the enum to a JSON-valid string
  String toJson() {
    switch (this) {
      case FeatureGatingBehavior.gated:
        return 'gated';
      case FeatureGatingBehavior.nonGated:
        return 'nonGated';
      default:
        throw ArgumentError('Invalid FeatureGatingBehavior value');
    }
  }

  // Parses a JSON string to get the corresponding FeatureGatingBehavior enum value
  static FeatureGatingBehavior fromJson(String json) {
    switch (json) {
      case 'gated':
        return FeatureGatingBehavior.gated;
      case 'nonGated':
        return FeatureGatingBehavior.nonGated;
      default:
        throw ArgumentError('Invalid FeatureGatingBehavior value: $json');
    }
  }

  /// Convert this FeatureGatingBehavior to a PFeatureGatingBehavior
  PFeatureGatingBehavior toPigeon() {
    switch (this) {
      case FeatureGatingBehavior.gated:
        return PFeatureGatingBehavior.gated;
      case FeatureGatingBehavior.nonGated:
        return PFeatureGatingBehavior.nonGated;
      default:
        throw ArgumentError('Invalid FeatureGatingBehavior value');
    }
  }

  /// Convert a PFeatureGatingBehavior to a FeatureGatingBehavior
  static FeatureGatingBehavior fromPigeon(PFeatureGatingBehavior behavior) {
    switch (behavior) {
      case PFeatureGatingBehavior.gated:
        return FeatureGatingBehavior.gated;
      case PFeatureGatingBehavior.nonGated:
        return FeatureGatingBehavior.nonGated;
      default:
        throw ArgumentError('Invalid PFeatureGatingBehavior value');
    }
  }
}
