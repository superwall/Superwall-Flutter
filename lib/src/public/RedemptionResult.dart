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

  RedemptionInfo({
    required this.ownership,
    required this.purchaserInfo,
    this.paywallInfo,
    required this.entitlements,
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
      paywallInfo = RedemptionPaywallInfo(
          identifier: pInfo.paywallInfo!.identifier,
          placementName: pInfo.paywallInfo!.placementName,
          placementParams: pInfo.paywallInfo!.placementParams,
          variantId: pInfo.paywallInfo!.variantId,
          experimentId: pInfo.paywallInfo!.experimentId);
    }

    final entitlements =
        pInfo.entitlements.map((e) => Entitlement(id: e.id!)).toSet();

    return RedemptionInfo(
        ownership: ownership,
        purchaserInfo: purchaserInfo,
        paywallInfo: paywallInfo,
        entitlements: entitlements);
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
  final PStoreIdentifiers storeIdentifiers;

  PurchaserInfo({
    required this.appUserId,
    this.email,
    required this.storeIdentifiers,
  });

  static PurchaserInfo fromPigeon(PPurchaserInfo info) {
    return PurchaserInfo(
        appUserId: info.appUserId,
        email: info.email,
        storeIdentifiers: info.storeIdentifiers);
  }
}

/// Identifiers of the store that was purchased from.
sealed class StoreIdentifiers {
  const StoreIdentifiers();
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

  RedemptionPaywallInfo({
    required this.identifier,
    required this.placementName,
    required this.placementParams,
    required this.variantId,
    required this.experimentId,
  });

  static RedemptionPaywallInfo fromPigeon(PRedemptionPaywallInfo info) {
    return RedemptionPaywallInfo(
        identifier: info.identifier,
        placementName: info.placementName,
        placementParams: info.placementParams,
        variantId: info.variantId,
        experimentId: info.experimentId);
  }
}
