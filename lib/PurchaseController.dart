import 'package:superwallkit_flutter/PurchaseResult.dart';
import 'package:superwallkit_flutter/RestorationResult.dart';

/// The abstract class that handles Superwall's subscription-related logic.
///
/// By default, the Superwall SDK handles all subscription-related logic. However, if you'd like more
/// control, you can return a `PurchaseController` when configuring the SDK.
///
/// When implementing this, you also need to set the subscription status using
/// `Superwall.subscriptionStatus`.
///
/// To learn how to implement the `PurchaseController` in your app
/// and best practices, see [Purchases and Subscription Status](https://docs.superwall.com/docs/advanced-configuration).
abstract class PurchaseController {
  /// Called when the user initiates purchasing of a product.
  ///
  /// Add your purchase logic here and return its result. You can use platform-specific purchasing APIs.
  /// Make sure you handle all cases of `PurchaseResult`.
  ///
  /// - Parameters:
  ///   - productId: The product id of the product the user would like to purchase.
  ///
  /// - Returns: A `PurchaseResult` object, which is the result of your purchase logic.
  Future<PurchaseResult> purchase(String productId);

  /// Called when the user initiates a restore.
  ///
  /// Add your restore logic here, making sure that the user's subscription status is updated after restore,
  /// and return its result.
  ///
  /// - Returns: A `RestorationResult` that's `.restored` if the user's purchases were restored or `.failed(Error?)` if they weren't.
  /// **Note**: `restored` does not imply the user has an active subscription, it just mean the restore had no errors.
  Future<RestorationResult> restorePurchases();
}


