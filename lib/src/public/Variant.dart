/// Corresponds to the variables in the paywall editor.
/// Consists of a dictionary of product, user, and device data.
class Variant {
  /// The id of the experiment variant.
  final String id;

  /// The type of variant: holdout or treatment.
  final VariantType type;

  /// The identifier of the paywall variant. Only valid when the variant `type` is `treatment`.
  final String? paywallId;

  Variant({
    required this.id,
    required this.type,
    this.paywallId,
  });

  factory Variant.fromJson(Map<dynamic, dynamic> json) {
    return Variant(
      id: json['id'],
      type: VariantTypeExtension.fromJson(json['type']),
      paywallId: json['paywallId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'paywallId': paywallId,
    };
  }
}

enum VariantType {
  treatment,
  holdout,
}

// Extension on VariantType to add toJson and fromJson functionality
extension VariantTypeExtension on VariantType {
  // Converts the enum to a JSON-valid string
  String toJson() {
    switch (this) {
      case VariantType.treatment:
        return 'treatment';
      case VariantType.holdout:
        return 'holdout';
      default:
        throw ArgumentError('Invalid VariantType value');
    }
  }

  // Parses a JSON string to get the corresponding VariantType enum value
  static VariantType fromJson(String json) {
    switch (json) {
      case 'treatment':
        return VariantType.treatment;
      case 'holdout':
        return VariantType.holdout;
      default:
        throw ArgumentError('Invalid VariantType value');
    }
  }
}
