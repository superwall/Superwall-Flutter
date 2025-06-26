import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// The handler for ``Superwall/register(placement:params:handler:feature:)`` whose
/// functions provide status updates for a paywall.
class PaywallPresentationHandler {
  // Handlers for various events
  Function(PaywallInfo)? onPresentHandler;
  Function(PaywallInfo, PaywallResult)? onDismissHandler;
  Function(String)? onErrorHandler;
  Function(PaywallSkippedReason)? onSkipHandler;

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
}
