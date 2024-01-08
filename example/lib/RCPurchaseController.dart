import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart' hide LogLevel;

class RCPurchaseController extends PurchaseController {
  // MARK: Configure and sync subscription Status
  /// Makes sure that Superwall knows the customers subscription status by
  /// changing `Superwall.shared.subscriptionStatus`
  Future<void> configureAndSyncSubscriptionStatus() async {
    // Configure RevenueCat
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration configuration = Platform.isIOS ? PurchasesConfiguration("appl_XmYQBWbTAFiwLeWrBJOeeJJtTql") : PurchasesConfiguration("goog_DCSOujJzRNnPmxdgjOwdOOjwilC");
    await Purchases.configure(configuration);

    // Listen for changes
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      // Gets called whenever new CustomerInfo is available
      bool hasActiveSubscription = customerInfo.entitlements.active.isNotEmpty; // Why? -> https://www.revenuecat.com/docs/entitlements#entitlements
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
      DateTime purchaseDate = DateTime.now();
      CustomerInfo customerInfo = await Purchases.purchaseProduct(productId);
      if (customerInfo.entitlements.active.isNotEmpty) {
        DateTime? latestTransactionPurchaseDate = customerInfo.getLatestTransactionPurchaseDate();

        // If no latest transaction date is found, consider it as a new purchase.
        bool isNewPurchase = (latestTransactionPurchaseDate == null);

        // If the current date (`purchaseDate`) is after the latestTransactionPurchaseDate,
        bool purchaseHappenedInThePast = latestTransactionPurchaseDate?.isBefore(purchaseDate) ?? false;

        if (!isNewPurchase && purchaseHappenedInThePast) {
          return PurchaseResult.restored;
        } else {
          return PurchaseResult.purchased;
        }
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
        return PurchaseResult.failed(e.message ?? "Purchase failed in RCPurchaseController");
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
      return RestorationResult.failed(e.message ?? "Purchase failed in RCPurchaseController");
    }
  }
}

extension CustomerInfoAdditions on CustomerInfo {
  DateTime? getLatestTransactionPurchaseDate() {
    Map<String, String> allPurchaseDates = this.allPurchaseDates;
    if (allPurchaseDates.entries.isEmpty) {
      return null;
    }

    DateTime latestDate = DateTime.fromMillisecondsSinceEpoch(0);
    allPurchaseDates.forEach((key, value) {
      DateTime date = DateTime.parse(value);
      if (date.isAfter(latestDate)) {
        latestDate = date;
      }
    });

    return latestDate;
  }
}