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

  /// Automatically dismisses the paywall when a product is purchased or
  /// restored. Defaults to `true`.
  bool automaticallyDismiss = true;

  /// The view that appears behind Apple's payment sheet during a transaction.
  /// Defaults to `.spinner`.
  TransactionBackgroundView transactionBackgroundView =
      TransactionBackgroundView.spinner;
}

extension PaywallOptionsJson on PaywallOptions {
  Map<dynamic, dynamic> toJson() {
    return {
      'isHapticFeedbackEnabled': isHapticFeedbackEnabled,
      'restoreFailed': restoreFailed.toJson(),
      'shouldShowPurchaseFailureAlert': shouldShowPurchaseFailureAlert,
      'shouldPreload': shouldPreload,
      'automaticallyDismiss': automaticallyDismiss,
      'transactionBackgroundView': transactionBackgroundView.toJson()
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
