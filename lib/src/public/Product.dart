import '../../superwallkit_flutter.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

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

  /// Creates a Product from a PProduct from the pigeon generated code
  static Product? fromPigeon(PProduct? pProduct) {
    if (pProduct == null) return null;

    Set<Entitlement> entitlements = {};
    if (pProduct.entitlements != null) {
      entitlements = pProduct.entitlements!
          .map((e) => Entitlement(id: e.id ?? ''))
          .toSet();
    }

    return Product(
      id: pProduct.id,
      name: pProduct.name,
      entitlements: entitlements,
    );
  }

  /// Converts this Product to a PProduct for the pigeon generated code
  PProduct toPigeon() {
    return PProduct(
      id: id,
      name: name,
      entitlements: entitlements.map((e) => e.toPigeon()).toList(),
    );
  }
}
