import '../../superwallkit_flutter.dart';

/// The product in the paywall.
class Product {
  /// The product's identifier.
  final String? id;

  /// The name of the product in the editor.
  final String? name;

  /// The entitlements associated with this product.
  final Set<Entitlement> entitlements;

  Product({
    required this.id,
    required this.name,
    required this.entitlements,
  });

  // Factory constructor to create a Product instance from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      entitlements: (json['entitlements'] as List<dynamic>?)
              ?.map((e) => Entitlement.fromJson(Map<String, dynamic>.from(e)))
              .toSet() ??
          {},
    );
  }
}
