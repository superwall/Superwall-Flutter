/// A wrapper around a store transaction.
class StoreTransaction {
  // TODO
  // final String configRequestId;
  // final String appSessionId;
  // final DateTime? transactionDate;
  // final String originalTransactionIdentifier;
  // final StoreTransactionState state;
  // final String? storeTransactionId;
  // final StorePayment payment;
  // final DateTime? originalTransactionDate;
  // final String? webOrderLineItemID;
  // final String? appBundleId;
  // final String? subscriptionGroupId;
  // final bool? isUpgraded;
  // final DateTime? expirationDate;
  // final String? offerId;
  // final DateTime? revocationDate;
  // final String? appAccountToken;
}

enum StoreTransactionState {
  purchasing,
  purchased,
  failed,
  restored,
  deferred,
}

/// The payment for the transaction.
class StorePayment {
  // TODO
  // /// The ID of a product being bought.
  // final String productIdentifier;
  //
  // /// The number of items the user wants to purchase.
  // final int quantity;
  //
  // /// The ID for the discount offer to apply to the payment.
  // final String? discountIdentifier;
}
