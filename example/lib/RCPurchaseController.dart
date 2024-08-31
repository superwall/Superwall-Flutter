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
    final configuration = Platform.isIOS
        ? PurchasesConfiguration('appl_XmYQBWbTAFiwLeWrBJOeeJJtTql')
        : PurchasesConfiguration('goog_DCSOujJzRNnPmxdgjOwdOOjwilC');
    await Purchases.configure(configuration);

    // Listen for changes
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      // Gets called whenever new CustomerInfo is available
      final hasActiveEntitlementOrSubscription = customerInfo
          .hasActiveEntitlementOrSubscription(); // Why? -> https://www.revenuecat.com/docs/entitlements#entitlements
      if (hasActiveEntitlementOrSubscription) {
        Superwall.shared.setSubscriptionStatus(SubscriptionStatus.active);
      } else {
        Superwall.shared.setSubscriptionStatus(SubscriptionStatus.inactive);
      }
    });
  }

  // MARK: Handle Purchases

  /// Makes a purchase from App Store with RevenueCat and returns its
  /// result. This gets called when someone tries to purchase a product on
  /// one of your paywalls from iOS.
  @override
  Future<PurchaseResult> purchaseFromAppStore(String productId) async {
    // Find products matching productId from RevenueCat
    final products = await PurchasesAdditions.getAllProducts([productId]);

    // Get first product for product ID (this will properly throw if empty)
    final storeProduct = products.firstOrNull;

    if (storeProduct == null) {
      return PurchaseResult.failed(
          'Failed to find store product for $productId');
    }

    final purchaseResult = await _purchaseStoreProduct(storeProduct);
    return purchaseResult;
  }

  /// Makes a purchase from Google Play with RevenueCat and returns its
  /// result. This gets called when someone tries to purchase a product on
  /// one of your paywalls from Android.
  @override
  Future<PurchaseResult> purchaseFromGooglePlay(
      String productId, String? basePlanId, String? offerId) async {
    // Find products matching productId from RevenueCat
    List<StoreProduct> products =
        await PurchasesAdditions.getAllProducts([productId]);

    // Choose the product which matches the given base plan.
    // If no base plan set, select first product or fail.
    String storeProductId = "$productId:$basePlanId";

    // Try to find the first product where the googleProduct's basePlanId matches the given basePlanId.
    StoreProduct? matchingProduct;

    // Loop through each product in the products list.
    for (final product in products) {
      // Check if the current product's basePlanId matches the given basePlanId.
      if (product.identifier == storeProductId) {
        // If a match is found, assign this product to matchingProduct.
        matchingProduct = product;
        // Break the loop as we found our matching product.
        break;
      }
    }

    // If a matching product is not found, then try to get the first product from the list.
    StoreProduct? storeProduct =
        matchingProduct ?? (products.isNotEmpty ? products.first : null);

    // If no product is found (either matching or the first one), return a failed purchase result.
    if (storeProduct == null) {
      return PurchaseResult.failed("Product not found");
    }

    switch (storeProduct.productCategory) {
      case ProductCategory.subscription:
        SubscriptionOption? subscriptionOption =
            await _fetchGooglePlaySubscriptionOption(
                storeProduct, basePlanId, offerId);
        if (subscriptionOption == null) {
          return PurchaseResult.failed(
              "Valid subscription option not found for product.");
        }
        return await _purchaseSubscriptionOption(subscriptionOption);
      case ProductCategory.nonSubscription:
        return await _purchaseStoreProduct(storeProduct);
      case null:
        return PurchaseResult.failed("Unable to determine product category");
    }
  }

  Future<SubscriptionOption?> _fetchGooglePlaySubscriptionOption(
    StoreProduct storeProduct,
    String? basePlanId,
    String? offerId,
  ) async {
    final subscriptionOptions = storeProduct.subscriptionOptions;

    if (subscriptionOptions != null && subscriptionOptions.isNotEmpty) {
      // Concatenate base + offer ID
      final subscriptionOptionId =
          _buildSubscriptionOptionId(basePlanId, offerId);

      // Find first subscription option that matches the subscription option ID or use the default offer
      SubscriptionOption? subscriptionOption;

      // Search for the subscription option with the matching ID
      for (final option in subscriptionOptions) {
        if (option.id == subscriptionOptionId) {
          subscriptionOption = option;
          break;
        }
      }

      // If no matching subscription option is found, use the default option
      subscriptionOption ??= storeProduct.defaultOption;

      // Return the subscription option
      return subscriptionOption;
    }

    return null;
  }

  Future<PurchaseResult> _purchaseSubscriptionOption(
      SubscriptionOption subscriptionOption) async {
    // Define the async perform purchase function
    Future<CustomerInfo> performPurchase() async {
      // Attempt to purchase product
      CustomerInfo customerInfo =
          await Purchases.purchaseSubscriptionOption(subscriptionOption);
      return customerInfo;
    }

    PurchaseResult purchaseResult =
        await _handleSharedPurchase(performPurchase);
    return purchaseResult;
  }

  Future<PurchaseResult> _purchaseStoreProduct(
      StoreProduct storeProduct) async {
    // Define the async perform purchase function
    Future<CustomerInfo> performPurchase() async {
      // Attempt to purchase product
      CustomerInfo customerInfo =
          await Purchases.purchaseStoreProduct(storeProduct);
      return customerInfo;
    }

    PurchaseResult purchaseResult =
        await _handleSharedPurchase(performPurchase);
    return purchaseResult;
  }

  // MARK: Shared purchase
  Future<PurchaseResult> _handleSharedPurchase(
      Future<CustomerInfo> Function() performPurchase) async {
    try {
      // Store the current purchase date to later determine if this is a new purchase or restore
      DateTime purchaseDate = DateTime.now();

      // Perform the purchase using the function provided
      CustomerInfo customerInfo = await performPurchase();

      // Handle the results
      if (customerInfo.hasActiveEntitlementOrSubscription()) {
        DateTime? latestTransactionPurchaseDate =
            customerInfo.getLatestTransactionPurchaseDate();

        // If no latest transaction date is found, consider it as a new purchase.
        bool isNewPurchase = (latestTransactionPurchaseDate == null);

        // If the current date (`purchaseDate`) is after the latestTransactionPurchaseDate,
        bool purchaseHappenedInThePast =
            latestTransactionPurchaseDate?.isBefore(purchaseDate) ?? false;

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
        return PurchaseResult.failed(
            e.message ?? "Purchase failed in RCPurchaseController");
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
      return RestorationResult.failed(
          e.message ?? "Restore failed in RCPurchaseController");
    }
  }
}

// MARK: Helpers

String _buildSubscriptionOptionId(String? basePlanId, String? offerId) {
  String result = '';

  if (basePlanId != null) {
    result += basePlanId;
  }

  if (offerId != null) {
    if (basePlanId != null) {
      result += ':';
    }
    result += offerId;
  }

  return result;
}

extension CustomerInfoAdditions on CustomerInfo {
  bool hasActiveEntitlementOrSubscription() {
    return (activeSubscriptions.isNotEmpty || entitlements.active.isNotEmpty);
  }

  DateTime? getLatestTransactionPurchaseDate() {
    Map<String, String?> allPurchaseDates = this.allPurchaseDates;

    // Return null if there are no purchase dates
    if (allPurchaseDates.entries.isEmpty) {
      return null;
    }

    // Initialise the latestDate with the earliest possible date
    DateTime latestDate = DateTime.fromMillisecondsSinceEpoch(0);

    // Iterate over each entry in the map
    allPurchaseDates.forEach((key, value) {
      // Check if the value is not null
      if (value != null) {
        // Parse the date from the string value
        DateTime date = DateTime.parse(value);
        // Update the latestDate if the current date is after the latestDate
        if (date.isAfter(latestDate)) {
          latestDate = date;
        }
      }
    });

    // Return the latest date found
    return latestDate;
  }
}

extension PurchasesAdditions on Purchases {
  static Future<List<StoreProduct>> getAllProducts(
      List<String> productIdentifiers) async {
    final subscriptionProducts = await Purchases.getProducts(productIdentifiers,
        productCategory: ProductCategory.subscription);
    final nonSubscriptionProducts = await Purchases.getProducts(
        productIdentifiers,
        productCategory: ProductCategory.nonSubscription);
    final combinedProducts = [
      ...subscriptionProducts,
      ...nonSubscriptionProducts
    ];
    return combinedProducts;
  }
}
