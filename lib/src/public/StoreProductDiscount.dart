import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/public/SubscriptionPeriod.dart';

/// How an App Store subscription is billed.
///
/// iOS only.
enum BillingPlanType {
  /// The whole subscription period is paid for up front.
  upFront,

  /// The subscription is paid for in monthly instalments.
  monthly;

  static BillingPlanType fromPigeon(PBillingPlanType pigeon) {
    switch (pigeon) {
      case PBillingPlanType.upFront:
        return BillingPlanType.upFront;
      case PBillingPlanType.monthly:
        return BillingPlanType.monthly;
    }
  }
}

/// How the price of a [StoreProductDiscount] is charged.
///
/// iOS only.
enum StoreProductDiscountPaymentMode {
  /// The discounted price is charged every period.
  payAsYouGo,

  /// The discounted price is charged once, up front.
  payUpFront,

  /// Nothing is charged for the duration of the discount.
  freeTrial;

  static StoreProductDiscountPaymentMode fromPigeon(
      PStoreProductDiscountPaymentMode pigeon) {
    switch (pigeon) {
      case PStoreProductDiscountPaymentMode.payAsYouGo:
        return StoreProductDiscountPaymentMode.payAsYouGo;
      case PStoreProductDiscountPaymentMode.payUpFront:
        return StoreProductDiscountPaymentMode.payUpFront;
      case PStoreProductDiscountPaymentMode.freeTrial:
        return StoreProductDiscountPaymentMode.freeTrial;
    }
  }
}

/// The kind of a [StoreProductDiscount].
///
/// iOS only.
enum StoreProductDiscountType {
  /// An introductory offer.
  introductory,

  /// A promotional offer.
  promotional;

  static StoreProductDiscountType fromPigeon(PStoreProductDiscountType pigeon) {
    switch (pigeon) {
      case PStoreProductDiscountType.introductory:
        return StoreProductDiscountType.introductory;
      case PStoreProductDiscountType.promotional:
        return StoreProductDiscountType.promotional;
    }
  }
}

/// An introductory or promotional offer of a product.
///
/// iOS only.
class StoreProductDiscount {
  /// The identifier of the offer. `null` for introductory offers.
  final String? offerIdentifier;

  /// The currency code of the discount's price.
  final String? currencyCode;

  /// The price of the discount in the local currency.
  final double price;

  /// The localized price of the discount.
  final String localizedPriceString;

  /// How the price of the discount is charged.
  final StoreProductDiscountPaymentMode paymentMode;

  /// The length of one period of the discount.
  final SubscriptionPeriod subscriptionPeriod;

  /// The number of periods the discount lasts for.
  final int numberOfPeriods;

  /// The kind of discount.
  final StoreProductDiscountType type;

  StoreProductDiscount({
    this.offerIdentifier,
    this.currencyCode,
    required this.price,
    required this.localizedPriceString,
    required this.paymentMode,
    required this.subscriptionPeriod,
    required this.numberOfPeriods,
    required this.type,
  });

  factory StoreProductDiscount.fromPigeon(PStoreProductDiscount pigeon) {
    return StoreProductDiscount(
      offerIdentifier: pigeon.offerIdentifier,
      currencyCode: pigeon.currencyCode,
      price: pigeon.price,
      localizedPriceString: pigeon.localizedPriceString,
      paymentMode:
          StoreProductDiscountPaymentMode.fromPigeon(pigeon.paymentMode),
      subscriptionPeriod:
          SubscriptionPeriod.fromPigeon(pigeon.subscriptionPeriod),
      numberOfPeriods: pigeon.numberOfPeriods,
      type: StoreProductDiscountType.fromPigeon(pigeon.type),
    );
  }
}
