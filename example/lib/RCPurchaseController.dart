import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart'
    hide LogLevel; // Import Superwall and hide LogLevel to avoid conflicts with RevenueCat's LogLevel

class RCPurchaseController extends PurchaseController {
  // MARK: Configure and sync subscription Status
  /// Makes sure that Superwall knows the customers subscription status by
  /// changing `Superwall.shared.subscriptionStatus`
  configureAndSyncSubscriptionStatus() async {
    // Configure RevenueCat
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration configuration =
        Platform.isIOS ? PurchasesConfiguration("appl_XmYQBWbTAFiwLeWrBJOeeJJtTql") : PurchasesConfiguration("goog_DCSOujJzRNnPmxdgjOwdOOjwilC");
    await Purchases.configure(configuration);

    // Listen for changes
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      // Gets called whenever new CustomerInfo is available
      bool hasActiveSubscription = customerInfo.entitlements.active.length > 0; // Why? -> https://www.revenuecat.com/docs/entitlements#entitlements
      if (hasActiveSubscription) {
        Superwall.shared.setSubscriptionStatus(SubscriptionStatus.active);
      } else {
        Superwall.shared.setSubscriptionStatus(SubscriptionStatus.inactive);
      }
    });
  }

  // MARK: Handle Purchases
  /// Makes a purchase with RevenueCat and returns its result. This gets called when
  /// someone tries to purchase a product on one of your paywalls.
  @override
  Future<PurchaseResult> purchase(String productId) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchaseProduct(productId);
      // TODO handle .restored logic (see below)
      if (customerInfo.entitlements.active.length > 0) {
        return PurchaseResult.purchased;
      } else {
        return PurchaseResult.failed("No active subscriptions found.");
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.paymentPendingError) {
        return PurchaseResult.pending;
      } else if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseResult.cancelled;
      } else {
        return PurchaseResult.failed(e);
      }
    }
  }

  // MARK: Handle Restores
  /// Makes a restore with RevenueCat and returns `.restored`, unless an error is thrown.
  /// This gets called when someone tries to restore purchases on one of your paywalls.
  @override
  Future<RestorationResult> restorePurchases() async {
    try {
      await Purchases.restorePurchases();
      return RestorationResult.restored;
    } on PlatformException catch (e) {
      // Error restoring purchases
      return RestorationResult.failed(e);
    }
  }
}

class CustomInfoTransaction {
  static String? purchaseDate(CustomerInfo customerInfo) {
    // customerInfo.activeSubscriptions.first;
  }
}
