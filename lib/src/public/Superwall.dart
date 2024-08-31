import 'dart:async';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/private/PaywallPresentationHandlerProxy.dart';
import 'package:superwallkit_flutter/src/public/IdentityOptions.dart';
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
class Superwall extends BridgeIdInstantiable {
  static const BridgeClass bridgeClass = 'SuperwallBridge';
  Superwall({super.bridgeId}) : super(bridgeClass: bridgeClass);

  static Logging _logging = Logging();
  static final Superwall _superwall = Superwall();

  // Used to prevent functions in this class from being used until after
  // the SDK has been configured on the native side
  static final LatestValueStreamController<bool> _isBridgedController =
      LatestValueStreamController<bool>(false);

  // Getter for the shared instance
  static Superwall get shared {
    return _superwall;
  }
  static Logging get logging {
    return _logging;
  }

  @override
  Future<void> handleMethodCall(MethodCall call) async {}

  // We'd like the configuration of Dart's Superwall to be synchronous; however,
  // because Superwall needs to be bridged, it's inherently asynchronous. In
  // order to keep `configure()` synchronous, all async functions in this
  // `Superwall` class should await this function, which will only finish
  // once Superwall has been bridged.
  Future<void> _waitForBridgeInstanceCreation() async {
    // If the value was set to true before this function was awaited,
    // return here
    if (_isBridgedController.value == true) {
      return;
    }

    // Otherwise, wait until the value is set to true
    await for (bool isNativeBridged in _isBridgedController.stream) {
      if (isNativeBridged == true) {
        break;
      }
    }
  }

  // Method to set the delegate.
  Future<void> setDelegate(SuperwallDelegate newDelegate) async {
    await _waitForBridgeInstanceCreation();

    // Store the Dart proxy
    final delegateProxy = SuperwallDelegateProxy(delegate: newDelegate);

    // Set the native instance as the delegate
    await bridgeId.communicator.invokeBridgeMethod(
        'setDelegate', {'delegateProxyBridgeId': delegateProxy.bridgeId});
  }

  // Asynchronous method to get logLevel
  Future<LogLevel> getLogLevel() async {
    await _waitForBridgeInstanceCreation();

    String logLevelJson =
        await bridgeId.communicator.invokeBridgeMethod('getLogLevel');
    return LogLevelJson.fromJson(logLevelJson);
  }

  // Asynchronous method to set logLevel
  Future<void> setLogLevel(LogLevel newLogLevel) async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator
        .invokeBridgeMethod('setLogLevel', {'logLevel': newLogLevel.toJson()});
  }

  // Asynchronous method to get userAttributes
  Future<Map<String, dynamic>> getUserAttributes() async {
    await _waitForBridgeInstanceCreation();

    final attributes =
        await bridgeId.communicator.invokeBridgeMethod('getUserAttributes');
    return Map<String, dynamic>.from(attributes);
  }

  // Asynchronous method to set userAttributes
  Future<void> setUserAttributes(Map<String, dynamic> userAttributes) async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator.invokeBridgeMethod(
        'setUserAttributes', {'userAttributes': userAttributes});
  }

  // Asynchronous method to get the current user's id
  Future<String> getUserId() async {
    await _waitForBridgeInstanceCreation();

    return await bridgeId.communicator.invokeBridgeMethod('getUserId');
  }

  // Asynchronous method to check if the user is logged in to Superwall
  Future<bool> getIsLoggedIn() async {
    await _waitForBridgeInstanceCreation();

    return await bridgeId.communicator.invokeBridgeMethod('getIsLoggedIn');
  }

  // Asynchronous method to check if Superwall is initialized
  Future<bool> getIsInitialized() async {
    return await bridgeId.communicator.invokeBridgeMethod('getIsInitialized');
  }

  // Asynchronous method to get the presented paywall view controller
  // Future<dynamic> getPresentedViewController() async {
  //   await _waitForBridgeInstanceCreation();
  //
  //   return await bridgeId.communicator.invokeBridgeMethod('getPresentedViewController');
  // }

  // Asynchronous method to get the latest PaywallInfo object
  Future<PaywallInfo?> getLatestPaywallInfo() async {
    await _waitForBridgeInstanceCreation();

    final paywallInfoBridgeId = await bridgeId.communicator
        .invokeBridgeMethod('getLatestPaywallInfoBridgeId');
    if (paywallInfoBridgeId != null) {
      return PaywallInfo(bridgeId: paywallInfoBridgeId);
    } else {
      return null;
    }
  }

  // Asynchronous method to get the subscription status of the user
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    await _waitForBridgeInstanceCreation();

    final subscriptionStatusBridgeId = await bridgeId.communicator
        .invokeBridgeMethod('getSubscriptionStatusBridgeId');
    final status = SubscriptionStatus.createSubscriptionStatusFromBridgeId(
            subscriptionStatusBridgeId) ??
        SubscriptionStatus.unknown;

    return status;
  }

  // Asynchronous method to set the subscription status of the user
  Future<void> setSubscriptionStatus(SubscriptionStatus status) async {
    await _waitForBridgeInstanceCreation();

    final subscriptionStatusBridgeId = status.bridgeId;

    var result = await bridgeId.communicator.invokeBridgeMethod(
        'setSubscriptionStatus',
        {'subscriptionStatusBridgeId': subscriptionStatusBridgeId});
    logging.debug('invokeBridgeResult setSubscriptionStatus: $result');
  }

  // Asynchronous method to check if Superwall has finished configuring
  Future<bool> getIsConfigured() async {
    await _waitForBridgeInstanceCreation();

    return await bridgeId.communicator.invokeBridgeMethod('getIsConfigured');
  }

  // Asynchronous method to set the configured state of Superwall
  Future<void> setIsConfigured(bool configured) async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator
        .invokeBridgeMethod('setIsConfigured', {'configured': configured});
  }

  // Asynchronous method to check if a paywall is currently being presented
  Future<bool> getIsPaywallPresented() async {
    await _waitForBridgeInstanceCreation();

    return await bridgeId.communicator
        .invokeBridgeMethod('getIsPaywallPresented');
  }

  // Asynchronous method to preload all paywalls
  Future<void> preloadAllPaywalls() async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator.invokeBridgeMethod('preloadAllPaywalls');
  }

  // Asynchronous method to preload paywalls for specific event names
  Future<void> preloadPaywallsForEvents(Set<String> eventNames) async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator.invokeBridgeMethod(
        'preloadPaywallsForEvents', {'eventNames': eventNames.toList()});
  }

  // Asynchronous method to handle deep links for paywall previews
  Future<bool> handleDeepLink(Uri url) async {
    await _waitForBridgeInstanceCreation();

    return await bridgeId.communicator
        .invokeBridgeMethod('handleDeepLink', {'url': url.toString()});
  }

  // Asynchronous method to toggle the paywall loading spinner
  Future<void> togglePaywallSpinner(bool isHidden) async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator
        .invokeBridgeMethod('togglePaywallSpinner', {'isHidden': isHidden});
  }

  // Asynchronous method to reset the user ID, on-device paywall assignments, and stored data
  Future<void> reset() async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator.invokeBridgeMethod('reset');
  }

  // Asynchronous method to configure the Superwall instance. Proxies must always be stored.
  static Superwall configure(String apiKey,
      {PurchaseController? purchaseController,
      SuperwallOptions? options,
      Function? completion}) {
    // Configure async
    _configure(apiKey,
        purchaseController: purchaseController,
        options: options,
        completion: completion);

    // Provide this instance as opposed to what we'd get from the native side
    // so that consumers can call functions on this Dart instance
    return _superwall;
  }

  static Future<void> _configure(String apiKey,
      {PurchaseController? purchaseController,
      SuperwallOptions? options,
      Function? completion}) async {
    PurchaseControllerProxy? purchaseControllerProxy;

    if (purchaseController != null) {
      // Create a proxy bridge for the non-null purchaseController
      purchaseControllerProxy = PurchaseControllerProxy(
          purchaseController: purchaseController,
          givenId: 'PurchaseControllerProxyBridge-bridgeId');
    }

    CompletionBlockProxy? completionBlockProxy;
    if (completion != null) {
      // Define the completion block to set for the CompletionBlockProxy
      void completionBlock(dynamic argument) {
        completion();
      }

      // Create the Dart proxy and native side bridge
      completionBlockProxy = CompletionBlockProxy(block: completionBlock);
    }

    final sdkVersion = await getPackageVersion('flutter');
    final defaultLogger = options?.logging ?? Logging();
    try {
      await _superwall.bridgeId.communicator.invokeBridgeMethod('configure', {
        'apiKey': apiKey,
        'purchaseControllerProxyBridgeId': purchaseControllerProxy?.bridgeId,
        'options': options?.toJson(),
        'completionBlockProxyBridgeId': completionBlockProxy?.bridgeId,
        'sdkVersion': sdkVersion
      });
    } catch (e) {
      // Handle any errors that occur during configuration
      defaultLogger.error('Failed to configure Superwall', e);
    }

    // Allows the functions in this class to now be invoked
    _logging = defaultLogger;
    _isBridgedController.update(true);
  }

  static Future<String> getPackageVersion(String packageName) async {
    final pubspec = await rootBundle
        .loadString('packages/superwallkit_flutter/pubspec.yaml');

    // Read the pubspec.yaml file
    //final pubspec =
    // await File('package:superwallkit_flutter/pubspec.yaml').readAsString();

    // Parse the YAML content
    final yaml = loadYaml(pubspec);

    // Retrieve the version of the specified package
    final version = yaml['version'];

    if (version == null) {
      return '';
    }

    return version.toString();
  }
}

//region PublicPresentation

/// Extension for public presentation functionalities in Superwall.
extension PublicPresentation on Superwall {
  /// Dismisses the presented paywall, if one exists.
  Future<void> dismiss() async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator.invokeBridgeMethod('dismiss');
  }

  /// Registers an event to access a feature, potentially showing a paywall.
  ///
  /// Shows a paywall based on the event, user matching campaign rules, and subscription status.
  /// Requires creating a campaign and adding the event on the Superwall Dashboard.
  /// The shown paywall is determined by campaign rules and user assignments.
  Future<void> registerEvent(String event,
      {Map<String, dynamic>? params,
      PaywallPresentationHandler? handler,
      Function? feature}) async {
    await _waitForBridgeInstanceCreation();

    CompletionBlockProxy? featureBlockProxy;
    if (feature != null) {
      // Define the feature block to set for the CompletionBlockProxy
      void featureBlock(dynamic argument) {
        feature();
      }

      // Create the Dart proxy and native side bridge
      featureBlockProxy = CompletionBlockProxy(block: featureBlock);
    }

    PaywallPresentationHandlerProxy? handlerProxy;
    if (handler != null) {
      // Create the Dart proxy and native side bridge
      handlerProxy = PaywallPresentationHandlerProxy(handler: handler);
    }

    var result =
        await bridgeId.communicator.invokeBridgeMethod('registerEvent', {
      'event': event,
      'params': params,
      'handlerProxyBridgeId': handlerProxy?.bridgeId,
      'featureBlockProxyBridgeId': featureBlockProxy?.bridgeId
    });

    Superwall.logging.debug('invokeBridgeResult registerEvent: $result');
  }
}

//endregion

//region PublicPresentation

/// Extension for public identity functionalities in Superwall.
extension PublicIdentity on Superwall {
  Future<void> identify(String userId, [IdentityOptions? options]) async {
    await _waitForBridgeInstanceCreation();

    await bridgeId.communicator.invokeBridgeMethod(
        'identify', {'userId': userId, 'identityOptions': options?.toJson()});
  }
}

//endregion