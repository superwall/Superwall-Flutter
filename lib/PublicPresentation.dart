import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/Superwall.dart';

// TODO
class PaywallPresentationHandler {}

/// Extension for public presentation functionalities in Superwall.
extension PublicPresentation on Superwall {
  static final MethodChannel _channel = MethodChannel('SWK_PublicPresentationPlugin');

  /// Dismisses the presented paywall, if one exists.
  Future<void> dismiss() async {
    await _channel.invokeMethod('dismiss');
  }

  /// Registers an event to access a feature, potentially showing a paywall.
  ///
  /// Shows a paywall based on the event, user matching campaign rules, and subscription status.
  /// Requires creating a campaign and adding the event on the Superwall Dashboard.
  /// The shown paywall is determined by campaign rules and user assignments.
  // TODO: Do we need both of these functions
  Future<void> registerEventWithFeature(String event, {Map<String, dynamic>? params, PaywallPresentationHandler? handler, Function? feature}) async {
    await _channel.invokeMethod('registerEventWithFeature', {
      'event': event,
      'params': params,
      'handler': handler,
      'feature': feature,
    });
  }

  /// Registers an event to trigger a paywall, based on campaign rules.
  ///
  /// Paywall presentation is determined by user matching campaign rules, and subscription status.
  /// Campaign creation and event addition on the Superwall Dashboard are prerequisites.
  /// Continues showing an assigned paywall unless removed from the campaign or reset.
  Future<void> registerEvent(String event, {Map<String, dynamic>? params, PaywallPresentationHandler? handler}) async {
    await _channel.invokeMethod('registerEvent', {
      'event': event,
      'params': params,
      'handler': handler,
    });
  }
}
