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
}
