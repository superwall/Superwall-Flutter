import 'package:superwallkit_flutter/src/public/CustomCallback.dart';
import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/src/public/PaywallResult.dart';
import 'package:superwallkit_flutter/src/public/PaywallSkippedReason.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// The handler for ``Superwall/register(placement:params:handler:feature:)`` whose
/// functions provide status updates for a paywall.
class PaywallPresentationHandler {
  // Handlers for various events
  Function(PaywallInfo)? onPresentHandler;
  Function(PaywallInfo, PaywallResult)? onDismissHandler;
  Function(String)? onErrorHandler;
  Function(PaywallSkippedReason)? onSkipHandler;
  Future<CustomCallbackResult> Function(CustomCallback)? onCustomCallbackHandler;

  // Setters for the handlers
  void onPresent(Function(PaywallInfo) handler) {
    onPresentHandler = handler;
  }

  void onDismiss(Function(PaywallInfo, PaywallResult) handler) {
    onDismissHandler = handler;
  }

  void onError(Function(String) handler) {
    onErrorHandler = handler;
  }

  void onSkip(Function(PaywallSkippedReason) handler) {
    onSkipHandler = handler;
  }

  /// Sets the handler that will be called when the paywall requests a custom callback.
  ///
  /// Custom callbacks allow paywalls to request arbitrary actions from the app and
  /// receive results that determine which branch (onSuccess/onFailure) executes.
  ///
  /// Example:
  /// ```dart
  /// handler.onCustomCallback((callback) async {
  ///   switch (callback.name) {
  ///     case 'validate_email':
  ///       final email = callback.variables?['email'] as String?;
  ///       if (isValidEmail(email)) {
  ///         return CustomCallbackResult.success({'validated': true});
  ///       } else {
  ///         return CustomCallbackResult.failure({'error': 'Invalid email'});
  ///       }
  ///     default:
  ///       return CustomCallbackResult.failure();
  ///   }
  /// });
  /// ```
  void onCustomCallback(
      Future<CustomCallbackResult> Function(CustomCallback) handler) {
    onCustomCallbackHandler = handler;
  }
}
