import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// A one-time (in-app) Google Play purchase that the user currently owns.
///
/// Returned by [Superwall.queryInAppPurchases] on Android. Only purchases in the
/// `PURCHASED` state are included. Grant the benefit for [productIds], then pass
/// [purchaseToken] to [Superwall.consume] to allow the product to be bought again.
class OwnedInAppPurchase {
  /// The product identifiers included in this purchase.
  final List<String> productIds;

  /// The Google Play purchase token. Pass this to [Superwall.consume].
  final String purchaseToken;

  /// The Google Play order ID, if available.
  final String? orderId;

  /// When the purchase was made.
  final DateTime purchaseTime;

  /// The quantity purchased.
  final int quantity;

  /// Whether the purchase has been acknowledged.
  final bool isAcknowledged;

  OwnedInAppPurchase({
    required this.productIds,
    required this.purchaseToken,
    required this.orderId,
    required this.purchaseTime,
    required this.quantity,
    required this.isAcknowledged,
  });

  factory OwnedInAppPurchase.fromPigeon(POwnedInAppPurchase purchase) {
    return OwnedInAppPurchase(
      productIds: purchase.productIds,
      purchaseToken: purchase.purchaseToken,
      orderId: purchase.orderId,
      purchaseTime: DateTime.fromMillisecondsSinceEpoch(purchase.purchaseTime),
      quantity: purchase.quantity,
      isAcknowledged: purchase.isAcknowledged,
    );
  }

  @override
  String toString() =>
      'OwnedInAppPurchase(productIds: $productIds, orderId: $orderId, '
      'quantity: $quantity, isAcknowledged: $isAcknowledged)';
}
