import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';

/// Options for configuring the appearance and behavior of paywalls.
class PaywallOptions {
  /// Determines whether the paywall should use haptic feedback.
  /// Defaults to true.
  bool isHapticFeedbackEnabled = true;

  /// Defines the messaging of the alert presented to the user when restoring a
  /// transaction fails.
  RestoreFailed restoreFailed = RestoreFailed();

  /// Shows an alert after a purchase fails. Defaults to `true`.
  bool shouldShowPurchaseFailureAlert = true;

  /// Pre-loads and caches trigger paywalls and products when you initialize
  /// the SDK.
  /// Defaults to `true`.
  bool shouldPreload = true;

  /// Per-device-tier overrides for [shouldPreload]. Only the tiers you specify
  /// are overridden; the rest fall back to [shouldPreload].
  ///
  /// Use this to disable preloading on low-end devices while keeping it
  /// enabled on mid/high-end devices, for example.
  ///
  /// Note: Android only. Has no effect on iOS.
  Map<DeviceTier, bool> preloadDeviceOverrides = const {};

  /// Automatically dismisses the paywall when a product is purchased or
  /// restored. Defaults to `true`.
  bool automaticallyDismiss = true;

  /// The view that appears behind Apple's payment sheet during a transaction.
  /// Defaults to `.spinner`.
  TransactionBackgroundView transactionBackgroundView =
      TransactionBackgroundView.spinner;

  /// Shows an alert asking the user if they'd like to try to restore on the web, if you have added web checkout on the
  /// Superwall dashboard. Defaults to `true`.
  bool shouldShowWebRestorationAlert = true;

  /// Allows you to globally override products on any paywall that have a given name.
  /// The key is the product name in the paywall, the value is the product identifier to replace it with.
  Map<String, String>? overrideProductsByName;

  /// Shows a localized alert confirming a successful purchase via web checkout.
  /// Defaults to `true`.
  bool shouldShowWebPurchaseConfirmationAlert = true;

  /// A callback that is invoked when the back button is pressed on Android.
  /// Use this to be notified of back presses on the paywall.
  /// Call `Superwall.shared.dismiss()` within the callback if you want to dismiss the paywall.
  /// Note: This is only supported on Android.
  void Function(PaywallInfo?)? onBackPressed;

  /// A color resource used to tint the circular progress bar shown while a
  /// purchase or restoration is in progress. Defaults to `null`, which keeps
  /// the system's default spinner color.
  ///
  /// The value is an Android color resource ID (`@ColorRes`).
  ///
  /// Note: Android only. Has no effect on iOS.
  int? loadingColor;
}

extension PaywallOptionsJson on PaywallOptions {
  Map<dynamic, dynamic> toJson() {
    return {
      'isHapticFeedbackEnabled': isHapticFeedbackEnabled,
      'restoreFailed': restoreFailed.toJson(),
      'shouldShowPurchaseFailureAlert': shouldShowPurchaseFailureAlert,
      'shouldPreload': shouldPreload,
      'preloadDeviceOverrides': preloadDeviceOverrides
          .map((tier, value) => MapEntry(tier.toJson(), value)),
      'automaticallyDismiss': automaticallyDismiss,
      'transactionBackgroundView': transactionBackgroundView.toJson(),
      'shouldShowWebRestorationAlert': shouldShowWebRestorationAlert,
      'overrideProductsByName': overrideProductsByName,
      'shouldShowWebPurchaseConfirmationAlert': shouldShowWebPurchaseConfirmationAlert,
      'loadingColor': loadingColor,
    };
  }
}

/// Defines the messaging of the alert presented to the user when restoring a
/// transaction fails.
class RestoreFailed {
  /// The title of the alert presented to the user when restoring a transaction
  /// fails.
  String title = 'No Subscription Found';

  /// Defines the message of the alert presented to the user when restoring a
  /// transaction fails.
  String message = 'We couldn\'t find an active subscription for your account.';

  /// Defines the title of the close button in the alert presented to the user.
  String closeButtonTitle = 'Okay';
}

extension RestoreFailedJson on RestoreFailed {
  Map<dynamic, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'closeButtonTitle': closeButtonTitle,
    };
  }
}

/// Device tier classification used by [PaywallOptions.preloadDeviceOverrides].
///
/// Tiers are evaluated from device specs (RAM, CPU, codec support).
/// Android only.
enum DeviceTier {
  /// ≤2GB RAM, ~1.2GHz quad-core, missing modern codecs (e.g. Android Go).
  ultraLow,

  /// 3–4GB RAM, ~1.8GHz 4–8 cores, partial codec support (entry-level).
  low,

  /// 4–6GB RAM, ~2.0–2.4GHz 8 cores, full codec support.
  mid,

  /// 6–8GB RAM, ~2.4–2.8GHz 8 cores, high-density display.
  high,

  /// ≥10GB RAM, 2.8+GHz with prime cores ≥3.5GHz.
  ultraHigh,

  /// Device info could not be evaluated.
  unknown,
}

extension DeviceTierJson on DeviceTier {
  String toJson() {
    switch (this) {
      case DeviceTier.ultraLow:
        return 'ultra_low';
      case DeviceTier.low:
        return 'low';
      case DeviceTier.mid:
        return 'mid';
      case DeviceTier.high:
        return 'high';
      case DeviceTier.ultraHigh:
        return 'ultra_high';
      case DeviceTier.unknown:
        return 'unknown';
    }
  }
}

/// Defines the different types of views that can appear behind Apple's payment
/// sheet during a transaction.
enum TransactionBackgroundView {
  spinner,
  none,
}

extension TransactionBackgroundViewJson on TransactionBackgroundView {
  String toJson() {
    switch (this) {
      case TransactionBackgroundView.spinner:
        return 'spinner';
      case TransactionBackgroundView.none:
        return 'none';
      default:
        throw Exception('Unknown TransactionBackgroundView value');
    }
  }
}
