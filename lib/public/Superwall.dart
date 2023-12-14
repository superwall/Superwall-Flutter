import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/public/LogLevel.dart';
import 'package:superwallkit_flutter/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/public/PurchaseController.dart';
import 'package:superwallkit_flutter/public/SubscriptionStatus.dart';
import 'package:superwallkit_flutter/public/SuperwallDelegate.dart';
import 'package:superwallkit_flutter/private/CompletionBlockProxy.dart';
import 'package:superwallkit_flutter/private/PurchaseControllerProxy.dart';
import 'package:superwallkit_flutter/private/SuperwallDelegateProxy.dart';
import 'package:superwallkit_flutter/public/SuperwallOptions.dart';

/// The primary class for integrating Superwall into your application.
/// After configuring via `configure(apiKey: purchaseController: options: completion:)`,
/// it provides access to all its features via instance functions and variables.
class Superwall {
  MethodChannel _channel;

  // Static instance for the singleton
  static Superwall? _superwall = null;

  // // Private constructor for assertion error
  Superwall._privateConstructor(this._channel) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  // Getter for the shared instance
  static Superwall get shared {
    assert(_superwall != null, "Superwall is not initialized. Call Superwall.configure() first.");
    return _superwall ??= Superwall._privateConstructor(MethodChannel(""));
  }

  Future<void> _handleMethodCall(MethodCall call) async {}

  // Method to set the delegate. Proxies must always be stored.
  SuperwallDelegateProxy? delegateProxy = null;
  void setDelegate(SuperwallDelegate newDelegate) async {
    // Create a native side bridge
    final delegateProxyBridge = await BridgingCreator.createSuperwallDelegateProxyBridge();

    // Store the Dart proxy
    delegateProxy = SuperwallDelegateProxy(channel: MethodChannel(delegateProxyBridge), delegate: newDelegate);

    // Set the native instance as the delegate
    _channel.invokeMethod('setDelegate', {'delegateProxyBridge': delegateProxyBridge});
  }

  // Asynchronous method to get logLevel
  Future<LogLevel> getLogLevel() async {
    final logLevelResult = await _channel.invokeMethod('getLogLevel');
    // TODO: Convert logLevelResult to LogLevel enum
    return LogLevel.values.firstWhere((element) => element.toString() == logLevelResult);
  }

  // Method to set logLevel
  void setLogLevel(LogLevel newLogLevel) {
    _channel.invokeMethod('setLogLevel', {'logLevel': newLogLevel.toString()});
  }

  // Asynchronous method to get userAttributes
  Future<Map<String, dynamic>> getUserAttributes() async {
    final attributes = await _channel.invokeMethod('getUserAttributes');
    return Map<String, dynamic>.from(attributes);
  }

  // Asynchronous method to get the current user's id
  Future<String> getUserId() async {
    return await _channel.invokeMethod('getUserId');
  }

  // Asynchronous method to check if the user is logged in to Superwall
  Future<bool> getIsLoggedIn() async {
    return await _channel.invokeMethod('getIsLoggedIn');
  }

  // Asynchronous method to get the presented paywall view controller
  // TODO:This is a placeholder implementation as Dart does not have a direct equivalent for UIViewController
  Future<dynamic> getPresentedViewController() async {
    return await _channel.invokeMethod('getPresentedViewController');
  }

  // Asynchronous method to get the latest PaywallInfo object
  Future<PaywallInfo?> getLatestPaywallInfo() async {
    final paywallInfo = await _channel.invokeMethod('getLatestPaywallInfo');
    // TODO: Convert paywallInfo to PaywallInfo
    return paywallInfo as PaywallInfo?;
  }

  // Asynchronous method to get the subscription status of the user
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final rawValue = await _channel.invokeMethod('getSubscriptionStatus');
    return SubscriptionStatus.fromRawValue(rawValue);
  }

  // Asynchronous method to set the subscription status of the user
  Future<void> setSubscriptionStatus(SubscriptionStatus status) async {
    await _channel.invokeMethod('setSubscriptionStatus', {'status': status.rawValue });
  }

  // Asynchronous method to check if Superwall has finished configuring
  Future<bool> getIsConfigured() async {
    return await _channel.invokeMethod('getIsConfigured');
  }

  // Asynchronous method to set the configured state of Superwall
  Future<void> setIsConfigured(bool configured) async {
    await _channel.invokeMethod('setIsConfigured', {'configured': configured});
  }

  // Asynchronous method to check if a paywall is currently being presented
  Future<bool> getIsPaywallPresented() async {
    return await _channel.invokeMethod('getIsPaywallPresented');
  }

  // Asynchronous method to preload all paywalls
  Future<void> preloadAllPaywalls() async {
    await _channel.invokeMethod('preloadAllPaywalls');
  }

  // Asynchronous method to preload paywalls for specific event names
  Future<void> preloadPaywallsForEvents(Set<String> eventNames) async {
    await _channel.invokeMethod('preloadPaywallsForEvents', {'eventNames': eventNames.toList()});
  }

  // Asynchronous method to handle deep links for paywall previews
  Future<bool> handleDeepLink(Uri url) async {
    return await _channel.invokeMethod('handleDeepLink', {'url': url.toString()});
  }

  // Asynchronous method to toggle the paywall loading spinner
  Future<void> togglePaywallSpinner(bool isHidden) async {
    await _channel.invokeMethod('togglePaywallSpinner', {'isHidden': isHidden});
  }

  // Asynchronous method to reset the user ID, on-device paywall assignments, and stored data
  Future<void> reset() async {
    await _channel.invokeMethod('reset');
  }

  // Asynchronous method to configure the Superwall instance. Proxies must always be stored.
  static PurchaseControllerProxy? purchaseControllerProxy = null;
  static Future<Superwall> configure(String apiKey, {PurchaseController? purchaseController, SuperwallOptions? options, Function? completion}) async {
    // TODO: Pass purchase controller and options as primitives

    String? purchaseControllerProxyBridge = null;
    if (purchaseController != null) {
      // Create a proxy bridge for the non-null purchaseController
      purchaseControllerProxyBridge = await BridgingCreator.createPurchaseControllerProxyBridge();

      // Store the Dart proxy
      purchaseControllerProxy = PurchaseControllerProxy(
          channel: MethodChannel(purchaseControllerProxyBridge),
          purchaseController: purchaseController
      );
    }

    // Create native Superwall
    String superwallBridge = await BridgingCreator.createSuperwallBridge();

    // Create a Superwall proxy
    MethodChannel channel = MethodChannel(superwallBridge);
    Superwall proxy = Superwall._privateConstructor(channel);
    _superwall = proxy;

    await channel.invokeMethod('configure', {
      'apiKey': apiKey,
      'purchaseControllerProxyBridge': purchaseControllerProxyBridge,
      'options': options,
    });

    // TODO: is this the best way to handle completion handlers?
    if (completion != null) {
      completion();
    }

    // Provide this instance as opposed to what we'd get from the native side
    // so that consumers can call dart functions on this
    return proxy;
  }
}

//region PublicPresentation

// TODO
class PaywallPresentationHandler {}

/// Extension for public presentation functionalities in Superwall.
extension PublicPresentation on Superwall {
  /// Dismisses the presented paywall, if one exists.
  Future<void> dismiss() async {
    await _channel.invokeMethod('dismiss');
  }

  /// Registers an event to access a feature, potentially showing a paywall.
  ///
  /// Shows a paywall based on the event, user matching campaign rules, and subscription status.
  /// Requires creating a campaign and adding the event on the Superwall Dashboard.
  /// The shown paywall is determined by campaign rules and user assignments.
  Future<void> registerEvent(String event, {Map<String, dynamic>? params, PaywallPresentationHandler? handler, Function? feature}) async {
    CompletionBlockProxy? featureBlockProxy = null;
    if (feature != null) {
      final bridge = await BridgingCreator.createCompletionBlockProxyBridge();

      // Store the Dart proxy and native side bridge
      featureBlockProxy = CompletionBlockProxy(
        bridge: bridge,
        block: (dynamic arguments) {
          feature();
        },
      );
    }

    await _channel.invokeMethod('registerEvent', {
      'event': event,
      'params': params,
      'handler': handler,
      'featureBlockProxyBridge': featureBlockProxy?.bridge,
    });
  }
}

//endregion