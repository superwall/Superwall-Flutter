import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The kind of transaction that completed, carried by the
/// `transactionComplete` event.
///
/// iOS only.
enum TransactionType {
  /// A consumable, non-consumable or non-renewing subscription was purchased.
  nonRecurringProductPurchase,

  /// A free trial started.
  freeTrialStart,

  /// A subscription started without a free trial.
  subscriptionStart;

  static TransactionType fromPigeon(PTransactionType pigeon) {
    switch (pigeon) {
      case PTransactionType.nonRecurringProductPurchase:
        return TransactionType.nonRecurringProductPurchase;
      case PTransactionType.freeTrialStart:
        return TransactionType.freeTrialStart;
      case PTransactionType.subscriptionStart:
        return TransactionType.subscriptionStart;
    }
  }
}
