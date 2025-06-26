import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// An enum that defines the possible outcomes of attempting to restore a product.
///
/// When implementing the ``PurchaseController/restorePurchases()`` delegate
/// method, all cases should be considered.
sealed class PurchaseResult {
  PurchaseResult();

  /// The purchase was cancelled.
  ///
  /// This is equivalent to various cancellation cases in StoreKit 1 and `.userCancelled` in StoreKit 2.
  /// In the context of RevenueCat, this is when the `userCancelled` boolean returns `true` from the purchase method.
  static PurchaseResult cancelled = PurchaseResultCancelled();

  /// The product was purchased.
  static PurchaseResult purchased = PurchaseResultPurchased();

  /// The purchase is pending and requires action from the developer.
  ///
  /// This corresponds to the `.deferred` transaction state in StoreKit 1 and `.paymentPendingError` in RevenueCat.
  static PurchaseResult pending = PurchaseResultPending();

  /// The purchase failed for a reason other than the user cancelling or the payment pending.
  ///
  /// The associated `Error` should be sent back for further handling.
  static PurchaseResult failed(String error) =>
      PurchaseResultFailed(error: error);

  static PPurchaseResult toPPurchaseResult(PurchaseResult result) {
    if (result is PurchaseResultCancelled) {
      return PPurchaseCancelled();
    } else if (result is PurchaseResultPurchased) {
      return PPurchasePurchased();
    } else if (result is PurchaseResultPending) {
      return PPurchasePending();
    } else if (result is PurchaseResultFailed) {
      return PPurchaseFailed(error: (result).error);
    } else {
      throw ArgumentError('Unknown PurchaseResult type');
    }
  }

  static PurchaseResult fromPPurchaseResult(PPurchaseResult pResult) {
    if (pResult is PPurchaseCancelled) {
      return PurchaseResultCancelled();
    } else if (pResult is PPurchasePurchased) {
      return PurchaseResultPurchased();
    } else if (pResult is PPurchasePending) {
      return PurchaseResultPending();
    } else if (pResult is PPurchaseFailed) {
      return PurchaseResultFailed(error: pResult.error ?? '');
    } else {
      throw ArgumentError('Unknown PPurchaseResult type');
    }
  }
}

class PurchaseResultCancelled extends PurchaseResult {
  PurchaseResultCancelled();
}

class PurchaseResultPurchased extends PurchaseResult {
  PurchaseResultPurchased();
}

class PurchaseResultPending extends PurchaseResult {
  PurchaseResultPending();
}

class PurchaseResultFailed extends PurchaseResult {
  final String error;
  PurchaseResultFailed({required this.error});
}
