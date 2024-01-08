import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// An enum that defines the possible outcomes of attempting to restore a product.
///
/// When implementing the ``PurchaseController/restorePurchases()`` delegate
/// method, all cases should be considered.
class PurchaseResult {
  BridgeId bridgeId;

  PurchaseResult._privateConstructor(this.bridgeId) {
    bridgeId.associate(this);
  }

  /// The purchase was cancelled.
  ///
  /// This is equivalent to various cancellation cases in StoreKit 1 and `.userCancelled` in StoreKit 2.
  /// In the context of RevenueCat, this is when the `userCancelled` boolean returns `true` from the purchase method.
  static PurchaseResult cancelled = PurchaseResult._privateConstructor(BridgingCreator.createPurchaseResultCancelledBridgeId());

  /// The product was purchased.
  static PurchaseResult purchased = PurchaseResult._privateConstructor(BridgingCreator.createPurchaseResultPurchasedBridgeId());

  /// The product was restored.
  static PurchaseResult restored = PurchaseResult._privateConstructor(BridgingCreator.createPurchaseResultRestoredBridgeId());

  /// The purchase is pending and requires action from the developer.
  ///
  /// This corresponds to the `.deferred` transaction state in StoreKit 1 and `.paymentPendingError` in RevenueCat.
  static PurchaseResult pending = PurchaseResult._privateConstructor(BridgingCreator.createPurchaseResultPendingBridgeId());

  /// The purchase failed for a reason other than the user cancelling or the payment pending.
  ///
  /// The associated `Error` should be sent back for further handling.
  static PurchaseResult failed(String error) => PurchaseResult._privateConstructor(BridgingCreator.createPurchaseResultFailedBridgeId(error));
}