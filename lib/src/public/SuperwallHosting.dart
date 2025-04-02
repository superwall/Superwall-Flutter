import 'dart:async';
import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart'
    as generated;
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// The primary class for integrating Superwall into your application.
/// After configuring via `configure(apiKey: purchaseController: options: completion:)`,
/// it provides access to all its features via instance functions and variables.
class Superwall {
  static final Superwall _superwall = Superwall._();
  static final generated.PSuperwallHostApi hostApi =
      generated.PSuperwallHostApi();

  // Private constructor
  Superwall._();

  /// Getter for the shared instance
  static Superwall get shared {
    return _superwall;
  }

  /// Static method to configure the Superwall instance
  static Superwall configure(String apiKey,
      {PurchaseController? purchaseController,
      SuperwallOptions? options,
      Function? completion}) {
    final purchaseControllerHost = purchaseController != null
        ? generated.PPurchaseControllerHost(
            bridgeId: 'PurchaseControllerHost-bridgeId')
        : null;

    // Convert SuperwallOptions to generated.PSuperwallOptions if needed
    final generatedOptions =
        options != null ? _convertToGeneratedOptions(options) : null;

    hostApi.configure(apiKey,
        purchaseController: purchaseControllerHost, options: generatedOptions);

    // If completion callback provided, call it
    if (completion != null) {
      completion();
    }

    return _superwall;
  }

  // Helper method to convert SuperwallOptions to generated.PSuperwallOptions
  static generated.PSuperwallOptions? _convertToGeneratedOptions(
      SuperwallOptions options) {
    final generatedOptions = generated.PSuperwallOptions();

    // Convert the PaywallOptions if available
    if (options.paywalls != null) {
      generatedOptions.paywalls = _convertPaywallOptions(options.paywalls!);
    }

    // Convert NetworkEnvironment if available
    if (options.networkEnvironment != null) {
      generatedOptions.networkEnvironment =
          _convertNetworkEnvironment(options.networkEnvironment!);
    }

    // Copy primitive values
    generatedOptions.isExternalDataCollectionEnabled =
        options.isExternalDataCollectionEnabled;
    generatedOptions.localeIdentifier = options.localeIdentifier;
    generatedOptions.isGameControllerEnabled = options.isGameControllerEnabled;
    generatedOptions.passIdentifiersToPlayStore =
        options.passIdentifiersToPlayStore;

    // Convert Logging if available
    if (options.logging != null) {
      generatedOptions.logging = _convertLogging(options.logging!);
    }

    return generatedOptions;
  }

  // Helper method to convert PaywallOptions
  static generated.PPaywallOptions _convertPaywallOptions(
      PaywallOptions options) {
    final generatedOptions = generated.PPaywallOptions();

    generatedOptions.isHapticFeedbackEnabled = options.isHapticFeedbackEnabled;
    generatedOptions.shouldShowPurchaseFailureAlert =
        options.shouldShowPurchaseFailureAlert;
    generatedOptions.shouldPreload = options.shouldPreload;
    generatedOptions.automaticallyDismiss = options.automaticallyDismiss;

    if (options.restoreFailed != null) {
      generatedOptions.restoreFailed = generated.PRestoreFailed()
        ..title = options.restoreFailed!.title
        ..message = options.restoreFailed!.message
        ..closeButtonTitle = options.restoreFailed!.closeButtonTitle;
    }

    if (options.transactionBackgroundView != null) {
      generatedOptions.transactionBackgroundView =
          _convertTransactionBackgroundView(options.transactionBackgroundView!);
    }

    return generatedOptions;
  }

  // Helper method to convert TransactionBackgroundView
  static generated.PTransactionBackgroundView _convertTransactionBackgroundView(
      TransactionBackgroundView view) {
    switch (view) {
      case TransactionBackgroundView.spinner:
        return generated.PTransactionBackgroundView.spinner;
      case TransactionBackgroundView.none:
        return generated.PTransactionBackgroundView.none;
    }
  }

  // Helper method to convert NetworkEnvironment
  static generated.PNetworkEnvironment _convertNetworkEnvironment(
      NetworkEnvironment environment) {
    switch (environment) {
      case NetworkEnvironment.release:
        return generated.PNetworkEnvironment.release;
      case NetworkEnvironment.releaseCandidate:
        return generated.PNetworkEnvironment.releaseCandidate;
      case NetworkEnvironment.developer:
        return generated.PNetworkEnvironment.developer;
    }
  }

  // Helper method to convert Logging object
  static generated.PLogging _convertLogging(Logging logging) {
    final generatedLogging = generated.PLogging();

    if (logging.level != null) {
      generatedLogging.level = _convertLogLevel(logging.level!);
    }

    if (logging.scopes != null && logging.scopes!.isNotEmpty) {
      generatedLogging.scopes =
          logging.scopes!.map((scope) => _convertLogScope(scope)).toList();
    }

    return generatedLogging;
  }

  // Helper method to convert LogLevel
  static generated.PLogLevel _convertLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return generated.PLogLevel.debug;
      case LogLevel.info:
        return generated.PLogLevel.info;
      case LogLevel.warn:
        return generated.PLogLevel.warn;
      case LogLevel.error:
        return generated.PLogLevel.error;
      case LogLevel.none:
        return generated.PLogLevel.none;
    }
  }

  // Helper method to convert LogScope
  static generated.PLogScope _convertLogScope(LogScope scope) {
    switch (scope) {
      case LogScope.localizationManager:
        return generated.PLogScope.localizationManager;
      case LogScope.bounceButton:
        return generated.PLogScope.bounceButton;
      case LogScope.coreData:
        return generated.PLogScope.coreData;
      case LogScope.configManager:
        return generated.PLogScope.configManager;
      case LogScope.identityManager:
        return generated.PLogScope.identityManager;
      case LogScope.debugManager:
        return generated.PLogScope.debugManager;
      case LogScope.debugViewController:
        return generated.PLogScope.debugViewController;
      case LogScope.localizationViewController:
        return generated.PLogScope.localizationViewController;
      case LogScope.gameControllerManager:
        return generated.PLogScope.gameControllerManager;
      case LogScope.device:
        return generated.PLogScope.device;
      case LogScope.network:
        return generated.PLogScope.network;
      case LogScope.paywallEvents:
        return generated.PLogScope.paywallEvents;
      case LogScope.productsManager:
        return generated.PLogScope.productsManager;
      case LogScope.storeKitManager:
        return generated.PLogScope.storeKitManager;
      case LogScope.placements:
        return generated.PLogScope.placements;
      case LogScope.receipts:
        return generated.PLogScope.receipts;
      case LogScope.superwallCore:
        return generated.PLogScope.superwallCore;
      case LogScope.paywallPresentation:
        return generated.PLogScope.paywallPresentation;
      case LogScope.transactions:
        return generated.PLogScope.transactions;
      case LogScope.paywallViewController:
        return generated.PLogScope.paywallViewController;
      case LogScope.cache:
        return generated.PLogScope.cache;
      case LogScope.all:
        return generated.PLogScope.all;
    }
  }

  // Helper method to convert from generated.PLogLevel to LogLevel
  static LogLevel _convertFromGeneratedLogLevel(generated.PLogLevel level) {
    switch (level) {
      case generated.PLogLevel.debug:
        return LogLevel.debug;
      case generated.PLogLevel.info:
        return LogLevel.info;
      case generated.PLogLevel.warn:
        return LogLevel.warn;
      case generated.PLogLevel.error:
        return LogLevel.error;
      case generated.PLogLevel.none:
        return LogLevel.none;
    }
  }

  /// Resets the user ID, on-device paywall assignments, and stored data
  Future<void> reset() async {
    await hostApi.reset();
  }

  /// Confirms all user assignments
  Future<void> confirmAllAssignments() async {
    await hostApi.confirmAllAssignments();
  }

  /// Gets the log level
  Future<LogLevel> getLogLevel() async {
    final logLevelJson = await hostApi.getLogLevel();
    // Convert from JSON string to LogLevel using the extension method
    return LogLevelJson.fromJson(logLevelJson);
  }

  /// Sets the log level
  Future<void> setLogLevel(LogLevel newLogLevel) async {
    // Convert LogLevel to string using the extension method
    final logLevelString = newLogLevel.toJson();
    await hostApi.setLogLevel(logLevelString);
  }

  /// Gets the user attributes
  Future<Map<String, dynamic>> getUserAttributes() async {
    return await hostApi.getUserAttributes();
  }

  /// Sets the user attributes
  Future<void> setUserAttributes(Map<String, dynamic> userAttributes) async {
    await hostApi.setUserAttributes(userAttributes);
  }

  /// Gets the locale identifier
  Future<String?> getLocaleIdentifier() async {
    return await hostApi.getLocaleIdentifier();
  }

  /// Sets the locale identifier
  Future<void> setLocaleIdentifier(String? localeIdentifier) async {
    await hostApi.setLocaleIdentifier(localeIdentifier);
  }

  /// Gets the current user's ID
  Future<String> getUserId() async {
    return await hostApi.getUserId();
  }

  /// Checks if the user is logged in to Superwall
  Future<bool> getIsLoggedIn() async {
    return await hostApi.getIsLoggedIn();
  }

  /// Checks if Superwall is initialized
  Future<bool> getIsInitialized() async {
    return await hostApi.getIsInitialized();
  }

  /// Gets the entitlements
  Future<Entitlements> getEntitlements() async {
    return hostApi.getEntitlements().map((e) => Entitlement(id: e.id)).toList();
  }

  /// Gets the latest PaywallInfo object
  Future<PaywallInfo?> getLatestPaywallInfo() async {
    final paywallInfoBridgeId = await hostApi.getLatestPaywallInfo();
  }

  /// Gets the subscription status of the user
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final subscriptionStatusBridgeId = await hostApi.getSubscriptionStatus();

    try {
      return await _createSubscriptionStatus(subscriptionStatusBridgeId);
    } catch (e) {
      return SubscriptionStatus.unknown;
    }
  }

  Future<SubscriptionStatus> _createSubscriptionStatus(String bridgeId) async {
    // Implementation would depend on your SubscriptionStatus class
    // This is a placeholder that just returns unknown
    return SubscriptionStatus.unknown;
  }

  /// Sets the subscription status of the user
  Future<void> setSubscriptionStatus(SubscriptionStatus status) async {
    final subscriptionStatusBridgeId = _getSubscriptionStatusBridgeId(status);
    await hostApi.setSubscriptionStatus(status);
  }

  String _getSubscriptionStatusBridgeId(SubscriptionStatus status) {
    // Implementation would depend on your SubscriptionStatus class
    // This is a placeholder that returns a dummy ID
    return "subscription-status-bridge-id";
  }

  /// Gets the configuration status of Superwall
  Future<String> getConfigurationStatus() async {
    return await hostApi.getConfigurationStatusBridgeId();
  }

  /// Checks if Superwall has finished configuring
  Future<bool> getIsConfigured() async {
    return await hostApi.getIsConfigured();
  }

  /// Checks if a paywall is currently being presented
  Future<bool> getIsPaywallPresented() async {
    return await hostApi.getIsPaywallPresented();
  }

  /// Preloads all paywalls
  Future<void> preloadAllPaywalls() async {
    await hostApi.preloadAllPaywalls();
  }

  /// Preloads paywalls for specific placement names
  Future<void> preloadPaywallsForPlacements(Set<String> placementNames) async {
    await hostApi.preloadPaywallsForPlacements(placementNames.toList());
  }

  /// Handles deep links for paywall previews
  Future<bool> handleDeepLink(Uri url) async {
    return await hostApi.handleDeepLink(url.toString());
  }

  /// Toggles the paywall loading spinner
  Future<void> togglePaywallSpinner(bool isHidden) async {
    await hostApi.togglePaywallSpinner(isHidden);
  }

  /// Dismisses the presented paywall, if one exists
  Future<void> dismiss() async {
    await hostApi.dismiss();
  }

  /// Registers a placement to access a feature, potentially showing a paywall
  Future<void> registerPlacement(String placement,
      {Map<String, dynamic>? params,
      PaywallPresentationHandler? handler,
      Function? feature}) async {
    throw UnimplementedError(
        'registerPlacement is not yet implemented in the new API');
  }

  /// Identifies a user with the given ID and options
  Future<void> identify(String userId, [IdentityOptions? options]) async {
    generated.PIdentityOptions? generatedOptions;

    if (options != null) {
      generated.PIdentityOptions generatedOptions = generated.PIdentityOptions(
          restorePaywallAssignments: options.restorePaywallAssignments);
    }

    await hostApi.identify(userId, generatedOptions);
  }
}
