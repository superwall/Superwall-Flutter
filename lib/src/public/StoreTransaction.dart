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

  factory StoreTransaction.fromJson(Map<String, dynamic> json) {
    return StoreTransaction(
      configRequestId: json['configRequestId'],
      appSessionId: json['appSessionId'],
      transactionDate: json['transactionDate'] != null ? DateTime.parse(json['transactionDate']) : null,
      originalTransactionIdentifier: json['originalTransactionIdentifier'],
      storeTransactionId: json['storeTransactionId'],
      originalTransactionDate: json['originalTransactionDate'] != null ? DateTime.parse(json['originalTransactionDate']) : null,
      webOrderLineItemID: json['webOrderLineItemID'],
      appBundleId: json['appBundleId'],
      subscriptionGroupId: json['subscriptionGroupId'],
      isUpgraded: json['isUpgraded'],
      expirationDate: json['expirationDate'] != null ? DateTime.parse(json['expirationDate']) : null,
      offerId: json['offerId'],
      revocationDate: json['revocationDate'] != null ? DateTime.parse(json['revocationDate']) : null,
    );
  }
}
