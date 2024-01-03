import 'dart:async';
import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/private/PaywallPresentationHandlerProxy.dart';
import 'package:superwallkit_flutter/src/public/LogLevel.dart';
import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/src/public/PaywallPresentationHandler.dart';
import 'package:superwallkit_flutter/src/public/PurchaseController.dart';
import 'package:superwallkit_flutter/src/public/SubscriptionStatus.dart';
import 'package:superwallkit_flutter/src/public/SuperwallDelegate.dart';
import 'package:superwallkit_flutter/src/private/CompletionBlockProxy.dart';
import 'package:superwallkit_flutter/src/private/PurchaseControllerProxy.dart';
import 'package:superwallkit_flutter/src/private/SuperwallDelegateProxy.dart';
import 'package:superwallkit_flutter/src/public/SuperwallOptions.dart';

import '../private/LatestValueStreamController.dart';

/// The primary class for integrating Superwall into your application.
/// After configuring via `configure(apiKey: purchaseController: options: completion:)`,
/// it provides access to all its features via instance functions and variables.
class Superwall {
  final Bridge bridge;
  final MethodChannel _channel;

  static final Superwall _superwall = Superwall._privateConstructor(BridgingCreator.createSuperwallBridge());

  // Used to prevent functions in this class from being used until after
  // the SDK has been configured on the native side
  static final LatestValueStreamController<bool> _isNativeBridgedController = LatestValueStreamController<bool>(false);

  // Getter for the shared instance
  static Superwall get shared {
    return _superwall;
  }

  // // Private constructor for assertion error
  Superwall._privateConstructor(this.bridge): _channel = MethodChannel(bridge) {
    bridge.associate(this);
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {}

  // We'd like the configuration of Dart's Superwall to be synchronous; however,
  // because Superwall needs to be bridged, it's inherently asynchronous. In
  // order to keep `configure()` synchronous, all async functions in this
  // `Superwall` class should await this function, which will only finish
  // once Superwall has been bridged.
  Future<void> _waitForNativeBridge() async {
    // If the value was set to true before this function was awaited,
    // return here
    if (_isNativeBridgedController.value == true) {
      return;
    }

    // Otherwise, wait until the value is set to true
    await for (bool isNativeBridged in _isNativeBridgedController.stream) {
      if (isNativeBridged == true) {
        break;
      }
    }
  }

  // Method to set the delegate. Proxies must always be stored.
  SuperwallDelegateProxy? delegateProxy;
  void setDelegate(SuperwallDelegate newDelegate) async {
    await _waitForNativeBridge();

    // Create a native side bridge
    final delegateProxyBridge = BridgingCreator.createSuperwallDelegateProxyBridge();

    // Store the Dart proxy
    delegateProxy = SuperwallDelegateProxy(channel: MethodChannel(delegateProxyBridge), delegate: newDelegate);

    // Set the native instance as the delegate
    _channel.invokeBridgeMethod('setDelegate', {'delegateProxyBridge': delegateProxyBridge});
  }

  // Asynchronous method to get logLevel
  Future<LogLevel> getLogLevel() async {
    await _waitForNativeBridge();

    final logLevelResult = await _channel.invokeBridgeMethod('getLogLevel');
    // TODO: Convert logLevelResult to LogLevel enum
    return LogLevel.values.firstWhere((element) => element.toString() == logLevelResult);
  }

  // Method to set logLevel
  Future<void> setLogLevel(LogLevel newLogLevel) async {
    await _waitForNativeBridge();

    _channel.invokeBridgeMethod('setLogLevel', {'logLevel': newLogLevel.toString()});
  }

  // Asynchronous method to get userAttributes
  Future<Map<String, dynamic>> getUserAttributes() async {
    await _waitForNativeBridge();

    final attributes = await _channel.invokeBridgeMethod('getUserAttributes');
    return Map<String, dynamic>.from(attributes);
  }

  // Asynchronous method to get the current user's id
  Future<String> getUserId() async {
    await _waitForNativeBridge();

    return await _channel.invokeBridgeMethod('getUserId');
  }

  // Asynchronous method to check if the user is logged in to Superwall
  Future<bool> getIsLoggedIn() async {
    await _waitForNativeBridge();

    return await _channel.invokeBridgeMethod('getIsLoggedIn');
  }

  // Asynchronous method to get the presented paywall view controller
  // TODO:This is a placeholder implementation as Dart does not have a direct equivalent for UIViewController
  Future<dynamic> getPresentedViewController() async {
    await _waitForNativeBridge();

    return await _channel.invokeBridgeMethod('getPresentedViewController');
  }

  // Asynchronous method to get the latest PaywallInfo object
  Future<PaywallInfo?> getLatestPaywallInfo() async {
    await _waitForNativeBridge();

    final paywallInfo = await _channel.invokeBridgeMethod('getLatestPaywallInfo');
    // TODO: Convert paywallInfo to PaywallInfo
    return paywallInfo as PaywallInfo?;
  }

  // Asynchronous method to get the subscription status of the user
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    await _waitForNativeBridge();

    final json = await _channel.invokeBridgeMethod('getSubscriptionStatus');
    return SubscriptionStatus.fromJson(json);
  }

  // Asynchronous method to set the subscription status of the user
  Future<void> setSubscriptionStatus(SubscriptionStatus status) async {
    await _waitForNativeBridge();

    Bridge bridge(SubscriptionStatus status) {
      if (status == SubscriptionStatus.active) {
        return BridgingCreator.createSubscriptionStatusActiveBridge();
      }
      else if (status == SubscriptionStatus.inactive) {
        return BridgingCreator.createSubscriptionStatusInactiveBridge();
      }
      else {
        return BridgingCreator.createSubscriptionStatusUnknownBridge();
      }
    }
    final subscriptionStatusBridge = bridge(status);
    await _channel.invokeBridgeMethod('setSubscriptionStatus', {'subscriptionStatusBridge': subscriptionStatusBridge});
  }

  // Asynchronous method to check if Superwall has finished configuring
  Future<bool> getIsConfigured() async {
    await _waitForNativeBridge();

    return await _channel.invokeBridgeMethod('getIsConfigured');
  }

  // Asynchronous method to set the configured state of Superwall
  Future<void> setIsConfigured(bool configured) async {
    await _waitForNativeBridge();

    await _channel.invokeBridgeMethod('setIsConfigured', {'configured': configured});
  }

  // Asynchronous method to check if a paywall is currently being presented
  Future<bool> getIsPaywallPresented() async {
    await _waitForNativeBridge();

    return await _channel.invokeBridgeMethod('getIsPaywallPresented');
  }

  // Asynchronous method to preload all paywalls
  Future<void> preloadAllPaywalls() async {
    await _waitForNativeBridge();

    await _channel.invokeBridgeMethod('preloadAllPaywalls');
  }

  // Asynchronous method to preload paywalls for specific event names
  Future<void> preloadPaywallsForEvents(Set<String> eventNames) async {
    await _waitForNativeBridge();

    await _channel.invokeBridgeMethod('preloadPaywallsForEvents', {'eventNames': eventNames.toList()});
  }

  // Asynchronous method to handle deep links for paywall previews
  Future<bool> handleDeepLink(Uri url) async {
    await _waitForNativeBridge();

    return await _channel.invokeBridgeMethod('handleDeepLink', {'url': url.toString()});
  }

  // Asynchronous method to toggle the paywall loading spinner
  Future<void> togglePaywallSpinner(bool isHidden) async {
    await _waitForNativeBridge();

    await _channel.invokeBridgeMethod('togglePaywallSpinner', {'isHidden': isHidden});
  }

  // Asynchronous method to reset the user ID, on-device paywall assignments, and stored data
  Future<void> reset() async {
    await _waitForNativeBridge();

    await _channel.invokeBridgeMethod('reset');
  }

  // Asynchronous method to configure the Superwall instance. Proxies must always be stored.
  static PurchaseControllerProxy? purchaseControllerProxy;
  static Superwall configure(String apiKey, {PurchaseController? purchaseController, SuperwallOptions? options, Function? completion}) {
    // Configure async
    _configure(apiKey, purchaseController: purchaseController, options: options, completion: completion);

    // Provide this instance as opposed to what we'd get from the native side
    // so that consumers can call functions on this Dart instance
    return _superwall;
  }

  static Future<void> _configure(String apiKey, {PurchaseController? purchaseController, SuperwallOptions? options, Function? completion}) async {
    // TODO: Pass options as primitives
    String? purchaseControllerProxyBridge;
    if (purchaseController != null) {
      // Create a proxy bridge for the non-null purchaseController
      purchaseControllerProxyBridge = BridgingCreator.createPurchaseControllerProxyBridge();

      // Store the Dart proxy
      purchaseControllerProxy = PurchaseControllerProxy(
          channel: MethodChannel(purchaseControllerProxyBridge),
          purchaseController: purchaseController
      );
    }

    try {
      _superwall._channel.invokeBridgeMethod('configure', {
        'apiKey': apiKey,
        'purchaseControllerProxyBridge': purchaseControllerProxyBridge,
        'options': options,
      });
    } catch (e) {
      // Handle any errors that occur during configuration
      print('Failed to configure Superwall: $e');
    }

    // Allows the functions in this class to now be invoked
    _isNativeBridgedController.update(true);

    // TODO: is this the best way to handle completion handlers?
    if (completion != null) {
      completion();
    }
  }
}

//region PublicPresentation

/// Extension for public presentation functionalities in Superwall.
extension PublicPresentation on Superwall {
  /// Dismisses the presented paywall, if one exists.
  Future<void> dismiss() async {
    await _waitForNativeBridge();

    await _channel.invokeBridgeMethod('dismiss');
  }

  /// Registers an event to access a feature, potentially showing a paywall.
  ///
  /// Shows a paywall based on the event, user matching campaign rules, and subscription status.
  /// Requires creating a campaign and adding the event on the Superwall Dashboard.
  /// The shown paywall is determined by campaign rules and user assignments.
  Future<void> registerEvent(String event, {Map<String, dynamic>? params, PaywallPresentationHandler? handler, Function? feature}) async {
    CompletionBlockProxy? featureBlockProxy;
    await _waitForNativeBridge();

    if (feature != null) {
      final bridge = BridgingCreator.createCompletionBlockProxyBridge();

      // Store the Dart proxy and native side bridge
      featureBlockProxy = CompletionBlockProxy(
        bridge: bridge,
        block: (dynamic arguments) {
          feature();
        },
      );
    }

    PaywallPresentationHandlerProxy? handlerProxy;
    if (handler != null) {
      final bridge = BridgingCreator.createPaywallPresentationHandlerProxyBridge();

      // Store the Dart proxy and native side bridge
      handlerProxy = PaywallPresentationHandlerProxy(
        bridge: bridge,
        paywallPresentationHandler: handler
      );
    }

    await _channel.invokeBridgeMethod('registerEvent', {
      'event': event,
      'params': params,
      'handlerProxyBridge': handlerProxy?.bridge,
      'featureBlockProxyBridge': featureBlockProxy?.bridge
    });
  }
}

//endregion