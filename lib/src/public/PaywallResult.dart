import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

sealed class PaywallResult {
  const PaywallResult();

  static PaywallResult? fromPigeon(PPaywallResult? pigeonResult) {
    if (pigeonResult == null) return null;

    if (pigeonResult is PPurchasedPaywallResult) {
      return PurchasedPaywallResult(productId: pigeonResult.productId);
    } else if (pigeonResult is PDeclinedPaywallResult) {
      return const DeclinedPaywallResult();
    } else if (pigeonResult is PRestoredPaywallResult) {
      return const RestoredPaywallResult();
    } else {
      throw ArgumentError(
          'Unknown PaywallResult type: ${pigeonResult.runtimeType}');
    }
  }
}

final class PurchasedPaywallResult extends PaywallResult {
  final String productId;
  const PurchasedPaywallResult({required this.productId});
}

final class DeclinedPaywallResult extends PaywallResult {
  const DeclinedPaywallResult();
}

final class RestoredPaywallResult extends PaywallResult {
  const RestoredPaywallResult();
}
