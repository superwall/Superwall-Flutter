sealed class PaywallResult {
  const PaywallResult();

  static PaywallResult fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'purchased':
        final product = Map<String, dynamic>.from(json['product']);
        final productId = product['productId'] as String;
        return PurchasedPaywallResult(productId: productId);
      case 'declined':
        return const DeclinedPaywallResult();
      case 'restored':
        return const RestoredPaywallResult();
      default:
        throw ArgumentError('Unknown PaywallResult type: $type');
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
