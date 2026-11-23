import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The state of a [StoreTransaction].
enum StoreTransactionState {
  /// The transaction is being processed by the store.
  purchasing,

  /// The purchase succeeded.
  purchased,

  /// The transaction failed.
  failed,

  /// The transaction restores a previous purchase.
  restored,

  /// The transaction is waiting on an external action, such as Ask to Buy.
  deferred;

  static StoreTransactionState fromPigeon(PStoreTransactionState pigeon) {
    switch (pigeon) {
      case PStoreTransactionState.purchasing:
        return StoreTransactionState.purchasing;
      case PStoreTransactionState.purchased:
        return StoreTransactionState.purchased;
      case PStoreTransactionState.failed:
        return StoreTransactionState.failed;
      case PStoreTransactionState.restored:
        return StoreTransactionState.restored;
      case PStoreTransactionState.deferred:
        return StoreTransactionState.deferred;
    }
  }
}

/// The payment of a [StoreTransaction].
class StorePayment {
  /// The identifier of the product that was paid for.
  final String productIdentifier;

  /// The number of items the user bought.
  final int quantity;

  /// The identifier of the discount applied to the payment, if there was one.
  final String? discountIdentifier;

  StorePayment({
    required this.productIdentifier,
    required this.quantity,
    this.discountIdentifier,
  });

  factory StorePayment.fromPigeon(PStorePayment payment) {
    return StorePayment(
      productIdentifier: payment.productIdentifier,
      quantity: payment.quantity,
      discountIdentifier: payment.discountIdentifier,
    );
  }
}

/// A wrapper around a store transaction.
class StoreTransaction {
  final String configRequestId;
  final String appSessionId;
  final DateTime? transactionDate;
  final String originalTransactionIdentifier;
  final String? storeTransactionId;
  final DateTime? originalTransactionDate;
  final String? webOrderLineItemID;
  final String? appBundleId;
  final String? subscriptionGroupId;
  final bool? isUpgraded;
  final DateTime? expirationDate;
  final String? offerId;
  final DateTime? revocationDate;

  /// The state of the transaction.
  final StoreTransactionState? state;

  /// The payment of the transaction.
  final StorePayment? payment;

  /// The app account token, a UUID that associates the transaction with a
  /// user in your own service.
  final String? appAccountToken;

  /// The Google Play purchase token. Android only.
  final String? purchaseToken;

  /// The Google Play purchase signature. Android only.
  final String? signature;

  StoreTransaction({
    required this.configRequestId,
    required this.appSessionId,
    this.transactionDate,
    required this.originalTransactionIdentifier,
    this.storeTransactionId,
    this.originalTransactionDate,
    this.webOrderLineItemID,
    this.appBundleId,
    this.subscriptionGroupId,
    this.isUpgraded,
    this.expirationDate,
    this.offerId,
    this.revocationDate,
    this.state,
    this.payment,
    this.appAccountToken,
    this.purchaseToken,
    this.signature,
  });

  factory StoreTransaction.fromPigeon(PStoreTransaction transaction) {
    final txnDate = transaction.transactionDate;
    final originalTxnDate = transaction.originalTransactionDate;
    final expirationDate = transaction.expirationDate;
    final revocationDate = transaction.revocationDate;

    return StoreTransaction(
      configRequestId: transaction.configRequestId,
      appSessionId: transaction.appSessionId,
      transactionDate: txnDate != null ? DateTime.parse(txnDate) : null,
      originalTransactionIdentifier: transaction.originalTransactionIdentifier,
      storeTransactionId: transaction.storeTransactionId,
      originalTransactionDate:
          originalTxnDate != null ? DateTime.parse(originalTxnDate) : null,
      webOrderLineItemID: transaction.webOrderLineItemID,
      appBundleId: transaction.appBundleId,
      subscriptionGroupId: transaction.subscriptionGroupId,
      isUpgraded: transaction.isUpgraded,
      expirationDate:
          expirationDate != null ? DateTime.parse(expirationDate) : null,
      offerId: transaction.offerId,
      revocationDate:
          revocationDate != null ? DateTime.parse(revocationDate) : null,
      state: transaction.state != null
          ? StoreTransactionState.fromPigeon(transaction.state!)
          : null,
      payment: transaction.payment != null
          ? StorePayment.fromPigeon(transaction.payment!)
          : null,
      appAccountToken: transaction.appAccountToken,
      purchaseToken: transaction.purchaseToken,
      signature: transaction.signature,
    );
  }
}
