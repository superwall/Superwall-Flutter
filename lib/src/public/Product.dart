import '../../superwallkit_flutter.dart';

/// The product in the paywall.
class Product {
  /// The type of product.
  final String type;

  /// The entitlements associated with this product.
  final Entitlements entitlements;

  Product({
    required this.type,
    required this.entitlements,
  });

  // Factory constructor to create a Product instance from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      type: json['type'],
      entitlements: Entitlements.fromJson(json['entitlements']),
    );
  }

  // Convert Product instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'entitlements': entitlements.toJson(),
    };
  }
}
