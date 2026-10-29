import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// How the store should charge when a purchase replaces an existing
/// subscription.
///
/// Android only.
enum ProductReplacementMode {
  /// Let the store decide, using the replacement mode configured in Google
  /// Play Console.
  storeDefault,

  /// Replace it now and charge the prorated price difference immediately.
  /// Google Play only supports this for upgrades, where the price per time
  /// unit increases.
  chargeProrated,

  /// Replace it now and charge the full price of the new product immediately.
  chargeFullPrice;

  static ProductReplacementMode fromPigeon(PProductReplacementMode mode) {
    switch (mode) {
      case PProductReplacementMode.storeDefault:
        return ProductReplacementMode.storeDefault;
      case PProductReplacementMode.chargeProrated:
        return ProductReplacementMode.chargeProrated;
      case PProductReplacementMode.chargeFullPrice:
        return ProductReplacementMode.chargeFullPrice;
    }
  }
}

/// The existing subscription that a purchase replaces, instead of the
/// purchase being bought alongside it.
///
/// Passed to `PurchaseController.purchaseFromGooglePlayWithReplacement`.
///
/// Android only.
class ProductReplacement {
  /// How the store should charge for the switch.
  final ProductReplacementMode mode;

  /// The identifier of the product being replaced, if known. For Google Play
  /// products this is the subscription ID of the purchase being replaced.
  final String? oldProductId;

  /// The Google Play purchase token of the subscription being replaced, used
  /// as the old purchase token of the billing flow's subscription update
  /// parameters.
  final String? oldPurchaseToken;

  const ProductReplacement({
    required this.mode,
    this.oldProductId,
    this.oldPurchaseToken,
  });

  factory ProductReplacement.fromPigeon(PProductReplacement replacement) =>
      ProductReplacement(
        mode: ProductReplacementMode.fromPigeon(replacement.mode),
        oldProductId: replacement.oldProductId,
        oldPurchaseToken: replacement.oldPurchaseToken,
      );

  @override
  bool operator ==(Object other) =>
      other is ProductReplacement &&
      other.mode == mode &&
      other.oldProductId == oldProductId &&
      other.oldPurchaseToken == oldPurchaseToken;

  @override
  int get hashCode => Object.hash(mode, oldProductId, oldPurchaseToken);

  @override
  String toString() =>
      'ProductReplacement(mode: ${mode.name}, oldProductId: $oldProductId, oldPurchaseToken: $oldPurchaseToken)';
}
