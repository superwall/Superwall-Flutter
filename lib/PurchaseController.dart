import 'package:superwallkit_flutter/PurchaseResult.dart';
import 'package:superwallkit_flutter/RestorationResult.dart';

abstract class PurchaseController {
  /// Called when the user initiates purchasing of a product.
  ///
  /// Implement your purchase logic here and return its result. The method should
  /// return a `Future` of `PurchaseResult`, which is the result of your purchase logic.
  /// Make sure you handle all cases of `PurchaseResult`.
  // TODO: Product
  Future<PurchaseResult> purchase(String product);

  /// Called when the user initiates a restore.
  ///
  /// Implement your restore logic here, ensuring that the user's subscription status
  /// is updated after restore, and return its result.
  ///
  /// The method should return a `Future` of `RestorationResult` which should be
  /// `.restored` if the user's purchases were restored, or `.failed` with an optional error if they weren't.
  /// Note: `restored` does not imply the user has an active subscription, it just means the restore had no errors.
  Future<RestorationResult> restorePurchases();
}