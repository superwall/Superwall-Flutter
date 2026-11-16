import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Contains information about a paywall.
sealed class RedemptionResult {
  RedemptionResult();

  static RedemptionResult success(String code, RedemptionInfo redemptionInfo) =>
      RedemptionResultSuccess(code: code, redemptionInfo: redemptionInfo);

  static RedemptionResult error(String code, ErrorInfo error) =>
      RedemptionResultError(code: code, error: error);

  static RedemptionResult expiredCode(String code, ExpiredCodeInfo info) =>
      RedemptionResultExpiredCode(code: code, info: info);

  static RedemptionResult invalidCode(String code) =>
      RedemptionResultInvalidCode(code: code);

  static RedemptionResult expiredSubscription(
          String code, RedemptionInfo redemptionInfo) =>
      RedemptionResultExpiredSubscription(
          code: code, redemptionInfo: redemptionInfo);

  static RedemptionResult fromPigeon(PRedemptionResult pResult) {
    if (pResult is PSuccessRedemptionResult) {
      return RedemptionResultSuccess(
          code: pResult.code,
          redemptionInfo: RedemptionInfo.fromPigeon(pResult.redemptionInfo));
    } else if (pResult is PErrorRedemptionResult) {
      return RedemptionResultError(
          code: pResult.code, error: ErrorInfo.fromPigeon(pResult.error));
    } else if (pResult is PExpiredCodeRedemptionResult) {
      return RedemptionResultExpiredCode(
          code: pResult.code, info: ExpiredCodeInfo.fromPigeon(pResult.info));
    } else if (pResult is PInvalidCodeRedemptionResult) {
      return RedemptionResultInvalidCode(code: pResult.code);
    } else if (pResult is PExpiredSubscriptionCode) {
      return RedemptionResultExpiredSubscription(
          code: pResult.code,
          redemptionInfo: RedemptionInfo.fromPigeon(pResult.redemptionInfo));
    } else {
      throw ArgumentError('Unknown PRedemptionResult type');
    }
  }
}

class RedemptionResultSuccess extends RedemptionResult {
  final String code;
  final RedemptionInfo redemptionInfo;
  RedemptionResultSuccess({required this.code, required this.redemptionInfo});
}

class RedemptionResultError extends RedemptionResult {
  final String code;
  final ErrorInfo error;
  RedemptionResultError({required this.code, required this.error});
}

class RedemptionResultExpiredCode extends RedemptionResult {
  final String code;
  final ExpiredCodeInfo info;
  RedemptionResultExpiredCode({required this.code, required this.info});
}

class RedemptionResultInvalidCode extends RedemptionResult {
  final String code;
  RedemptionResultInvalidCode({required this.code});
}

class RedemptionResultExpiredSubscription extends RedemptionResult {
  final String code;
  final RedemptionInfo redemptionInfo;
  RedemptionResultExpiredSubscription(
      {required this.code, required this.redemptionInfo});
}

class ErrorInfo {
  String message;
  ErrorInfo(this.message);

  static ErrorInfo fromPigeon(PErrorInfo pInfo) {
    return ErrorInfo(pInfo.message);
  }
}

/// Info about the expired code.
class ExpiredCodeInfo {
  /// A boolean indicating whether the redemption email has been resent.
  bool resent;

  /// An optional String indicating the obfuscated email address that the
  /// redemption email was sent to.
  String? obfuscatedEmail;

  ExpiredCodeInfo({
    required this.resent,
    this.obfuscatedEmail,
  });

  static ExpiredCodeInfo fromPigeon(PExpiredCodeInfo pInfo) {
    return ExpiredCodeInfo(
        resent: pInfo.resent, obfuscatedEmail: pInfo.obfuscatedEmail);
  }
}

/// Information about the redemption.
class RedemptionInfo {
  /// The ownership of the code.
  final Ownership ownership;

  /// Info about the purchaser.
  final PurchaserInfo purchaserInfo;

  /// Info about the paywall the purchase was made from.
  final RedemptionPaywallInfo? paywallInfo;

  /// The entitlements array.
  final Set<Entitlement> entitlements;

  /// The user attributes saved with the purchase. iOS only.
  final Map<String, Object>? userAttributes;

  RedemptionInfo({
    required this.ownership,
    required this.purchaserInfo,
    this.paywallInfo,
    required this.entitlements,
    this.userAttributes,
  });

  static RedemptionInfo fromPigeon(PRedemptionInfo pInfo) {
    Ownership ownership;
    if (pInfo.ownership is PAppUserOwnership) {
      final typed = pInfo.ownership as PAppUserOwnership;
      ownership = AppUserOwnership.fromPigeon(typed);
    } else if (pInfo.ownership is PDeviceOwnership) {
      final typed = pInfo.ownership as PDeviceOwnership;
      ownership = DeviceOwnership.fromPigeon(typed);
    } else {
      throw ArgumentError('Unknown POwnership type');
    }

    final purchaserInfo = PurchaserInfo.fromPigeon(pInfo.purchaserInfo);

    RedemptionPaywallInfo? paywallInfo;

    if (pInfo.paywallInfo != null) {
      paywallInfo = RedemptionPaywallInfo.fromPigeon(pInfo.paywallInfo!);
    }

    final entitlements =
        pInfo.entitlements.map((e) => Entitlement(id: e.id!)).toSet();

    return RedemptionInfo(
        ownership: ownership,
        purchaserInfo: purchaserInfo,
        paywallInfo: paywallInfo,
        entitlements: entitlements,
        userAttributes: pInfo.userAttributes);
  }
}

/// Enum specifying code ownership.
sealed class Ownership {
  const Ownership();
}

class AppUserOwnership extends Ownership {
  final String appUserId;
  const AppUserOwnership(this.appUserId);

  static AppUserOwnership fromPigeon(PAppUserOwnership ownership) {
    return AppUserOwnership(ownership.appUserId);
  }
}

class DeviceOwnership extends Ownership {
  final String deviceId;
  const DeviceOwnership(this.deviceId);

  static DeviceOwnership fromPigeon(PDeviceOwnership ownership) {
    return DeviceOwnership(ownership.deviceId);
  }
}

/// Info about the purchaser.
class PurchaserInfo {
  /// The app user ID of the purchaser.
  final String appUserId;

  /// The email address of the purchaser.
  final String? email;

  /// The identifiers of the store that was purchased from.
  final StoreIdentifiers storeIdentifiers;

  PurchaserInfo({
    required this.appUserId,
    this.email,
    required this.storeIdentifiers,
  });

  static PurchaserInfo fromPigeon(PPurchaserInfo info) {
    return PurchaserInfo(
        appUserId: info.appUserId,
        email: info.email,
        storeIdentifiers: StoreIdentifiers.fromPigeon(info.storeIdentifiers));
  }
}

/// Identifiers of the store that was purchased from.
sealed class StoreIdentifiers {
  const StoreIdentifiers();

  static StoreIdentifiers fromPigeon(PStoreIdentifiers ids) {
    if (ids is PStripeStoreIdentifiers) {
      return StripeStoreIdentifiers.fromPigeon(ids);
    } else if (ids is PPaddleStoreIdentifiers) {
      return PaddleStoreIdentifiers.fromPigeon(ids);
    } else if (ids is PUnknownStoreIdentifiers) {
      return UnknownStoreIdentifiers.fromPigeon(ids);
    }
    throw ArgumentError('Unknown PStoreIdentifiers type: ${ids.runtimeType}');
  }
}

/// Stripe purchase store identifiers.
class StripeStoreIdentifiers extends StoreIdentifiers {
  final String customerId;
  final List<String> subscriptionIds;

  const StripeStoreIdentifiers({
    required this.customerId,
    required this.subscriptionIds,
  });

  static StripeStoreIdentifiers fromPigeon(PStripeStoreIdentifiers ids) {
    return StripeStoreIdentifiers(
        customerId: ids.customerId, subscriptionIds: ids.subscriptionIds);
  }
}

/// Paddle purchase store identifiers.
class PaddleStoreIdentifiers extends StoreIdentifiers {
  final String customerId;
  final List<String> subscriptionIds;

  const PaddleStoreIdentifiers({
    required this.customerId,
    required this.subscriptionIds,
  });

  static PaddleStoreIdentifiers fromPigeon(PPaddleStoreIdentifiers ids) {
    return PaddleStoreIdentifiers(
        customerId: ids.customerId, subscriptionIds: ids.subscriptionIds);
  }
}

/// Unknown purchase store identifiers.
class UnknownStoreIdentifiers extends StoreIdentifiers {
  final String store;
  final Map<String, Object> additionalInfo;

  const UnknownStoreIdentifiers({
    required this.store,
    required this.additionalInfo,
  });

  static UnknownStoreIdentifiers fromPigeon(PUnknownStoreIdentifiers ids) {
    return UnknownStoreIdentifiers(
        store: ids.store, additionalInfo: ids.additionalInfo);
  }
}

/// Info about the paywall the purchase was made from.
class RedemptionPaywallInfo {
  /// The identifier of the paywall.
  final String identifier;

  /// The name of the placement.
  final String placementName;

  /// The params of the placement.
  final Map<String, Object> placementParams;

  /// The ID of the paywall variant.
  final String variantId;

  /// The ID of the experiment that the paywall belongs to.
  final String experimentId;

  /// The identifier of the product that was purchased.
  final String? productIdentifier;

  /// The product that was purchased, with its pricing details.
  final RedemptionPaywallProduct? product;

  RedemptionPaywallInfo({
    required this.identifier,
    required this.placementName,
    required this.placementParams,
    required this.variantId,
    required this.experimentId,
    this.productIdentifier,
    this.product,
  });

  static RedemptionPaywallInfo fromPigeon(PRedemptionPaywallInfo info) {
    return RedemptionPaywallInfo(
        identifier: info.identifier,
        placementName: info.placementName,
        placementParams: info.placementParams,
        variantId: info.variantId,
        experimentId: info.experimentId,
        productIdentifier: info.productIdentifier,
        product: info.product != null
            ? RedemptionPaywallProduct.fromPigeon(info.product!)
            : null);
  }
}

/// The product purchased from a paywall during a web checkout.
class RedemptionPaywallProduct {
  /// The product's identifier.
  final String identifier;

  /// The language code of the product's locale.
  final String languageCode;

  /// The product's locale.
  final String locale;

  /// The currency code of the product's price.
  final String currencyCode;

  /// The currency symbol of the product's price.
  final String currencySymbol;

  /// The subscription period unit, e.g., week.
  final String period;

  /// The subscription period as an adverb, e.g., weekly.
  final String periodly;

  /// The localized subscription period.
  final String localizedPeriod;

  /// An alternative description of the subscription period.
  final String periodAlt;

  /// The number of days in the subscription period.
  final int periodDays;

  /// The number of weeks in the subscription period.
  final int periodWeeks;

  /// The number of months in the subscription period.
  final int periodMonths;

  /// The number of years in the subscription period.
  final int periodYears;

  /// The price of the product in the local currency.
  final double rawPrice;

  /// The localized price.
  final String price;

  /// The localized daily price.
  final String dailyPrice;

  /// The localized weekly price.
  final String weeklyPrice;

  /// The localized monthly price.
  final String monthlyPrice;

  /// The localized yearly price.
  final String yearlyPrice;

  /// The price of the trial period in the local currency.
  final double rawTrialPeriodPrice;

  /// The localized price of the trial period.
  final String trialPeriodPrice;

  /// The localized daily price of the trial period.
  final String trialPeriodDailyPrice;

  /// The localized weekly price of the trial period.
  final String trialPeriodWeeklyPrice;

  /// The localized monthly price of the trial period.
  final String trialPeriodMonthlyPrice;

  /// The localized yearly price of the trial period.
  final String trialPeriodYearlyPrice;

  /// The trial period's duration in days.
  final int trialPeriodDays;

  /// The trial period's duration in weeks.
  final int trialPeriodWeeks;

  /// The trial period's duration in months.
  final int trialPeriodMonths;

  /// The trial period's duration in years.
  final int trialPeriodYears;

  /// The trial period's duration as text, e.g., 7-day.
  final String trialPeriodText;

  /// The formatted end date of the trial period.
  final String trialPeriodEndDate;

  RedemptionPaywallProduct({
    required this.identifier,
    required this.languageCode,
    required this.locale,
    required this.currencyCode,
    required this.currencySymbol,
    required this.period,
    required this.periodly,
    required this.localizedPeriod,
    required this.periodAlt,
    required this.periodDays,
    required this.periodWeeks,
    required this.periodMonths,
    required this.periodYears,
    required this.rawPrice,
    required this.price,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.rawTrialPeriodPrice,
    required this.trialPeriodPrice,
    required this.trialPeriodDailyPrice,
    required this.trialPeriodWeeklyPrice,
    required this.trialPeriodMonthlyPrice,
    required this.trialPeriodYearlyPrice,
    required this.trialPeriodDays,
    required this.trialPeriodWeeks,
    required this.trialPeriodMonths,
    required this.trialPeriodYears,
    required this.trialPeriodText,
    required this.trialPeriodEndDate,
  });

  static RedemptionPaywallProduct fromPigeon(PRedemptionPaywallProduct product) {
    return RedemptionPaywallProduct(
      identifier: product.identifier,
      languageCode: product.languageCode,
      locale: product.locale,
      currencyCode: product.currencyCode,
      currencySymbol: product.currencySymbol,
      period: product.period,
      periodly: product.periodly,
      localizedPeriod: product.localizedPeriod,
      periodAlt: product.periodAlt,
      periodDays: product.periodDays,
      periodWeeks: product.periodWeeks,
      periodMonths: product.periodMonths,
      periodYears: product.periodYears,
      rawPrice: product.rawPrice,
      price: product.price,
      dailyPrice: product.dailyPrice,
      weeklyPrice: product.weeklyPrice,
      monthlyPrice: product.monthlyPrice,
      yearlyPrice: product.yearlyPrice,
      rawTrialPeriodPrice: product.rawTrialPeriodPrice,
      trialPeriodPrice: product.trialPeriodPrice,
      trialPeriodDailyPrice: product.trialPeriodDailyPrice,
      trialPeriodWeeklyPrice: product.trialPeriodWeeklyPrice,
      trialPeriodMonthlyPrice: product.trialPeriodMonthlyPrice,
      trialPeriodYearlyPrice: product.trialPeriodYearlyPrice,
      trialPeriodDays: product.trialPeriodDays,
      trialPeriodWeeks: product.trialPeriodWeeks,
      trialPeriodMonths: product.trialPeriodMonths,
      trialPeriodYears: product.trialPeriodYears,
      trialPeriodText: product.trialPeriodText,
      trialPeriodEndDate: product.trialPeriodEndDate,
    );
  }
}
