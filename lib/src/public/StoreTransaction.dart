/// A wrapper around a store transaction.
class StoreTransaction {
  final String configRequestId;
  final String appSessionId;
  final String? triggerSessionId;
  final DateTime? transactionDate;
  final String originalTransactionIdentifier;
  final StoreTransactionState state;
  final String? storeTransactionId;
  final StorePayment payment;
  final DateTime? originalTransactionDate;
  final String? webOrderLineItemID;
  final String? appBundleId;
  final String? subscriptionGroupId;
  final bool? isUpgraded;
  final DateTime? expirationDate;
  final String? offerId;
  final DateTime? revocationDate;
  final String? appAccountToken;

  StoreTransaction({
    required this.configRequestId,
    required this.appSessionId,
    this.triggerSessionId,
    this.transactionDate,
    required this.originalTransactionIdentifier,
    required this.state,
    this.storeTransactionId,
    required this.payment,
    this.originalTransactionDate,
    this.webOrderLineItemID,
    this.appBundleId,
    this.subscriptionGroupId,
    this.isUpgraded,
    this.expirationDate,
    this.offerId,
    this.revocationDate,
    this.appAccountToken,
  });

  factory StoreTransaction.fromJson(Map<dynamic, dynamic> json) {
    // Conversion logic
    return StoreTransaction(
      configRequestId: json['configRequestId'],
      appSessionId: json['appSessionId'],
      triggerSessionId: json['triggerSessionId'],
      transactionDate: json['transactionDate'] != null ? DateTime.parse(json['transactionDate']) : null,
      originalTransactionIdentifier: json['originalTransactionIdentifier'],
      state: StoreTransactionStateExtension.fromJson(json['state']),
      storeTransactionId: json['storeTransactionId'],
      payment: StorePayment.fromJson(json['payment']),
      originalTransactionDate: json['originalTransactionDate'] != null ? DateTime.parse(json['originalTransactionDate']) : null,
      webOrderLineItemID: json['webOrderLineItemID'],
      appBundleId: json['appBundleId'],
      subscriptionGroupId: json['subscriptionGroupId'],
      isUpgraded: json['isUpgraded'],
      expirationDate: json['expirationDate'] != null ? DateTime.parse(json['expirationDate']) : null,
      offerId: json['offerId'],
      revocationDate: json['revocationDate'] != null ? DateTime.parse(json['revocationDate']) : null,
      appAccountToken: json['appAccountToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'configRequestId': configRequestId,
      'appSessionId': appSessionId,
      'triggerSessionId': triggerSessionId,
      'transactionDate': transactionDate?.toIso8601String(),
      'originalTransactionIdentifier': originalTransactionIdentifier,
      'state': state.toJson(),
      'storeTransactionId': storeTransactionId,
      'payment': payment.toJson(),
      'originalTransactionDate': originalTransactionDate?.toIso8601String(),
      'webOrderLineItemID': webOrderLineItemID,
      'appBundleId': appBundleId,
      'subscriptionGroupId': subscriptionGroupId,
      'isUpgraded': isUpgraded,
      'expirationDate': expirationDate?.toIso8601String(),
      'offerId': offerId,
      'revocationDate': revocationDate?.toIso8601String(),
      'appAccountToken': appAccountToken,
    };
  }
}

enum StoreTransactionState {
  purchasing,
  purchased,
  failed,
  restored,
  deferred,
}

extension StoreTransactionStateExtension on StoreTransactionState {
  String toJson() {
    switch (this) {
      case StoreTransactionState.purchasing:
        return 'purchasing';
      case StoreTransactionState.purchased:
        return 'purchased';
      case StoreTransactionState.failed:
        return 'failed';
      case StoreTransactionState.restored:
        return 'restored';
      case StoreTransactionState.deferred:
        return 'deferred';
      default:
        throw ArgumentError('Invalid StoreTransactionState value');
    }
  }

  static StoreTransactionState fromJson(String json) {
    switch (json) {
      case 'purchasing':
        return StoreTransactionState.purchasing;
      case 'purchased':
        return StoreTransactionState.purchased;
      case 'failed':
        return StoreTransactionState.failed;
      case 'restored':
        return StoreTransactionState.restored;
      case 'deferred':
        return StoreTransactionState.deferred;
      default:
        throw ArgumentError('Invalid StoreTransactionState value: $json');
    }
  }
}

/// The payment for the transaction.
class StorePayment {
  /// The ID of a product being bought.
  final String productIdentifier;

  /// The number of items the user wants to purchase.
  final int quantity;

  /// The ID for the discount offer to apply to the payment.
  final String? discountIdentifier;

  StorePayment({
    required this.productIdentifier,
    required this.quantity,
    this.discountIdentifier,
  });

  factory StorePayment.fromJson(Map<dynamic, dynamic> json) {
    return StorePayment(
      productIdentifier: json['productIdentifier'],
      quantity: json['quantity'],
      discountIdentifier: json['discountIdentifier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productIdentifier': productIdentifier,
      'quantity': quantity,
      'discountIdentifier': discountIdentifier,
    };
  }
}
