import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// The product in the paywall.
class Product {
  /// The type of product.
  final ProductType type;

  /// The product identifier.
  final String id;

  Product({
    required this.type,
    required this.id,
  });

  // Factory constructor to create a Product instance from a JSON map
  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      type: ProductTypeExtension.fromJson(json['type']),
      id: json['id'],
    );
  }
}

/// The type of product.
enum ProductType {
  primary,
  secondary,
  tertiary,
}

// Extension on ProductType for explicit serialization and deserialization
extension ProductTypeExtension on ProductType {
  // Converts the enum to a JSON-valid string
  String toJson() {
    switch (this) {
      case ProductType.primary:
        return 'primary';
      case ProductType.secondary:
        return 'secondary';
      case ProductType.tertiary:
        return 'tertiary';
      default:
        throw ArgumentError('Invalid ProductType value');
    }
  }

  // Parses a JSON string to get the corresponding ProductType enum value
  static ProductType fromJson(String json) {
    switch (json) {
      case 'primary':
        return ProductType.primary;
      case 'secondary':
        return ProductType.secondary;
      case 'tertiary':
        return ProductType.tertiary;
      default:
        throw ArgumentError('Invalid ProductType value: $json');
    }
  }
}
