import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart' hide LogLevel;

class TestingPurchaseController extends PurchaseController {
  // State variables
  bool rejectPurchase = true;
  bool restorePurchase = true;
  bool shouldShowDialog = false;
  BuildContext? _context;

  // Constructor with context parameter
  TestingPurchaseController({BuildContext? context}) : _context = context;

  // Toggle methods
  void toggleRejectPurchase() {
    rejectPurchase = !rejectPurchase;
  }

  void toggleRestorePurchase() {
    restorePurchase = !restorePurchase;
  }

  void toggleShowDialog() {
    shouldShowDialog = !shouldShowDialog;
  }

  // Helper method to show dialog
  Future<void> _showResultDialog(
      BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Future<PurchaseResult> purchaseFromAppStore(String productId) async {
    if (rejectPurchase) {
      return PurchaseResult.failed(
          "Purchase was rejected in TestingPurchaseController");
    } else {
      return PurchaseResult.purchased;
    }
  }

  /// Makes a purchase from Google Play with RevenueCat and returns its
  /// result. This gets called when someone tries to purchase a product on
  /// one of your paywalls from Android.
  @override
  Future<PurchaseResult> purchaseFromGooglePlay(
      String productId, String? basePlanId, String? offerId) async {
    if (rejectPurchase) {
      return PurchaseResult.failed(
          "Purchase was rejected in TestingPurchaseController");
    } else {
      Superwall.shared.setSubscriptionStatus(SubscriptionStatusActive(
          entitlements: [
        Entitlement(id: "test_entitlement"),
      ].toSet()));
      return PurchaseResult.purchased;
    }
  }

  @override
  Future<RestorationResult> restorePurchases() async {
    if (shouldShowDialog && _context != null) {
      await _showResultDialog(
          _context!,
          restorePurchase ? "Restore Success" : "Restore Failed",
          restorePurchase
              ? "Purchases were restored successfully."
              : "Failed to restore purchases.");
    }

    if (restorePurchase) {
      return RestorationResult.restored;
    } else {
      return RestorationResult.failed(
          "Restore failed in TestingPurchaseController");
    }
  }
}
