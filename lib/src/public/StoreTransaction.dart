import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

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
    );
  }
}
