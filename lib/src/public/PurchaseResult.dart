import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// An enum that defines the possible outcomes of attempting to restore a product.
///
/// When implementing the ``PurchaseController/restorePurchases()`` delegate
/// method, all cases should be considered.
class PurchaseResult extends BridgeIdInstantiable {
  PurchaseResult({required super.bridgeClass, super.bridgeId, super.initializationArgs });

  /// The purchase was cancelled.
  ///
  /// This is equivalent to various cancellation cases in StoreKit 1 and `.userCancelled` in StoreKit 2.
  /// In the context of RevenueCat, this is when the `userCancelled` boolean returns `true` from the purchase method.
  static PurchaseResult cancelled = PurchaseResultCancelled();

  /// The product was purchased.
  static PurchaseResult purchased = PurchaseResultPurchased();

  /// The product was restored.
  static PurchaseResult restored = PurchaseResultRestored();

  /// The purchase is pending and requires action from the developer.
  ///
  /// This corresponds to the `.deferred` transaction state in StoreKit 1 and `.paymentPendingError` in RevenueCat.
  static PurchaseResult pending = PurchaseResultPending();

  /// The purchase failed for a reason other than the user cancelling or the payment pending.
  ///
  /// The associated `Error` should be sent back for further handling.
  static PurchaseResult failed(String error) => PurchaseResultFailed(error: error);
}

class PurchaseResultCancelled extends PurchaseResult {
  static const BridgeClass bridgeClass = 'PurchaseResultCancelledBridge';
  PurchaseResultCancelled({super.bridgeId}): super(bridgeClass: bridgeClass);
}

class PurchaseResultPurchased extends PurchaseResult {
  static const BridgeClass bridgeClass = 'PurchaseResultPurchasedBridge';
  PurchaseResultPurchased({super.bridgeId}): super(bridgeClass: bridgeClass);
}

class PurchaseResultRestored extends PurchaseResult {
  static const BridgeClass bridgeClass = 'PurchaseResultRestoredBridge';
  PurchaseResultRestored({super.bridgeId}): super(bridgeClass: bridgeClass);
}

class PurchaseResultPending extends PurchaseResult {
  static const BridgeClass bridgeClass = 'PurchaseResultPendingBridge';
  PurchaseResultPending({super.bridgeId}): super(bridgeClass: bridgeClass);
}

class PurchaseResultFailed extends PurchaseResult {
  static const BridgeClass bridgeClass = 'PurchaseResultFailedBridge';
  PurchaseResultFailed({required String error, super.bridgeId}): super(bridgeClass: bridgeClass, initializationArgs: {'error': error});
}