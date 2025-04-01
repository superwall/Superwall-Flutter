import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/generated/superwallhost.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/src/main/kotlin/com/superwall/superwallkit_flutter/Host.g.kt',
  kotlinOptions: KotlinOptions(),
  dartPackageName: 'superwallkit_flutter',
))

// ============= CLASSES, ENUMS, DATA MODELS =============

// Data Models
class PSuperwallOptions {
  PPaywallOptions? paywalls;
  PNetworkEnvironment? networkEnvironment;
  bool? isExternalDataCollectionEnabled;
  String? localeIdentifier;
  bool? isGameControllerEnabled;
  PLogging? logging;
  bool? passIdentifiersToPlayStore;
}

class PPurchaseResult {
  bool? success;
  String? error;
}

class PRestorationResult {
  bool? restored;
  String? error;
}

class PRestoreFailed {
  /// The title of the alert presented to the user when restoring a transaction
  /// fails.
  String? title;

  /// Defines the message of the alert presented to the user when restoring a
  /// transaction fails.
  String? message;

  /// Defines the title of the close button in the alert presented to the user.
  String? closeButtonTitle;
}

class PLogging {
  PLogLevel? level;
  List<PLogScope>? scopes;
}

class PPaywallOptions {
  bool? isHapticFeedbackEnabled;
  PRestoreFailed? restoreFailed;
  bool? shouldShowPurchaseFailureAlert;
  bool? shouldPreload;
  bool? automaticallyDismiss;
  PTransactionBackgroundView? transactionBackgroundView;
}

class PPurchaseControllerHost {
  String? bridgeId;
}

class PEntitlement {
  String? id;
}

sealed class PSubscriptionStatus {
  PSubscriptionStatus();
}

class PActive extends PSubscriptionStatus {
  final List<PEntitlement> entitlements;
  PActive(this.entitlements);
}

// Pigeon has issues generating empty sealed classes, so we need to use a bool.
// It is irrelevant and here just to satisfy pigeon.
class PInactive extends PSubscriptionStatus {
  bool? _alwaysFalse;
  PInactive(this._alwaysFalse);
}

class PUnknown extends PSubscriptionStatus {
  bool? _alwaysFalse;
  PUnknown(this._alwaysFalse);
}

// PaywallInfo class for delegate methods
class PPaywallInfoPigeon {
  PPaywallInfoPigeon({
    required this.identifier,
    required this.name,
    this.experimentBridgeId,
    required this.productIds,
    required this.products,
    required this.url,
    this.presentedByEventWithName,
    this.presentedByEventWithId,
    this.presentedByEventAt,
    this.presentedBy,
    this.presentationSourceType,
    this.responseLoadStartTime,
    this.responseLoadCompleteTime,
    this.responseLoadFailTime,
    this.responseLoadDuration,
    this.webViewLoadStartTime,
    this.webViewLoadCompleteTime,
    this.webViewLoadFailTime,
    this.webViewLoadDuration,
    this.productsLoadStartTime,
    this.productsLoadCompleteTime,
    this.productsLoadFailTime,
    this.productsLoadDuration,
    this.paywalljsVersion,
    this.isFreeTrialAvailable,
    this.featureGatingBehavior,
    this.closeReason,
    this.localNotifications,
    this.computedPropertyRequests,
    this.surveys,
  });

  String identifier;
  String name;
  String? experimentBridgeId;
  List<String> productIds;
  List<Map<String, Object>> products;
  String url;
  String? presentedByEventWithName;
  String? presentedByEventWithId;
  double? presentedByEventAt;
  String? presentedBy;
  String? presentationSourceType;
  double? responseLoadStartTime;
  double? responseLoadCompleteTime;
  double? responseLoadFailTime;
  double? responseLoadDuration;
  double? webViewLoadStartTime;
  double? webViewLoadCompleteTime;
  double? webViewLoadFailTime;
  double? webViewLoadDuration;
  double? productsLoadStartTime;
  double? productsLoadCompleteTime;
  double? productsLoadFailTime;
  double? productsLoadDuration;
  String? paywalljsVersion;
  bool? isFreeTrialAvailable;
  Map<String, Object>? featureGatingBehavior;
  Map<String, Object>? closeReason;
  List<Map<String, Object>>? localNotifications;
  List<Map<String, Object>>? computedPropertyRequests;
  List<Map<String, Object>>? surveys;
}

// SuperwallEventInfo class for event handling
class PSuperwallEventInfoPigeon {
  PSuperwallEventInfoPigeon({
    required this.eventType,
    this.params,
    this.paywallInfoBridgeId,
  });

  PEventType eventType;
  Map<String, Object>? params;
  String? paywallInfoBridgeId;
}

// Enums
enum PNetworkEnvironment {
  /// Default: Uses the standard latest environment.
  release,

  /// **WARNING**: Uses a release candidate environment. This is not meant
  /// for a production environment.
  releaseCandidate,

  /// **WARNING**: Uses the nightly build environment. This is not meant for
  /// a production environment.
  developer,
}

enum PLogLevel { debug, info, warn, error, none }

enum PTransactionBackgroundView {
  spinner,
  none,
}

enum PLogScope {
  localizationManager,
  bounceButton,
  coreData,
  configManager,
  identityManager,
  debugManager,
  debugViewController,
  localizationViewController,
  gameControllerManager,
  device,
  network,
  paywallEvents,
  productsManager,
  storeKitManager,
  placements,
  receipts,
  superwallCore,
  paywallPresentation,
  transactions,
  paywallViewController,
  cache,
  all
}

enum PConfigurationStatus { pending, configured, failed }

// Event type enum for SuperwallEventInfo
enum PEventType {
  firstSeen,
  appOpen,
  appLaunch,
  identityAlias,
  appInstall,
  restoreStart,
  restoreComplete,
  restoreFail,
  sessionStart,
  deviceAttributes,
  subscriptionStatusDidChange,
  appClose,
  deepLink,
  triggerFire,
  paywallOpen,
  paywallClose,
  paywallDecline,
  transactionStart,
  transactionFail,
  transactionAbandon,
  transactionComplete,
  subscriptionStart,
  freeTrialStart,
  transactionRestore,
  transactionTimeout,
  userAttributes,
  nonRecurringProductPurchase,
  paywallResponseLoadStart,
  paywallResponseLoadNotFound,
  paywallResponseLoadFail,
  paywallResponseLoadComplete,
  paywallWebviewLoadStart,
  paywallWebviewLoadFail,
  paywallWebviewLoadComplete,
  paywallWebviewLoadTimeout,
  paywallWebviewLoadFallback,
  paywallProductsLoadRetry,
  paywallProductsLoadStart,
  paywallProductsLoadFail,
  paywallProductsLoadComplete,
  surveyResponse,
  paywallPresentationRequest,
  touchesBegan,
  surveyClose,
  reset,
  configRefresh,
  customPlacement,
  configAttributes,
  confirmAllAssignments,
  configFail,
  adServicesTokenRequestStart,
  adServicesTokenRequestFail,
  adServicesTokenRequestComplete,
  shimmerViewStart,
  shimmerViewComplete
}

// SubscriptionStatus enum
enum PSubscriptionStatusType { active, inactive, unknown }

// PaywallPresentationRequestStatus
enum PPaywallPresentationRequestStatusType {
  presentation,
  noPresentation,
  timeout
}

// PaywallPresentationRequestStatusReason
enum PPaywallPresentationRequestStatusReason {
  debuggerPresented,
  paywallAlreadyPresented,
  holdout,
  noAudienceMatch,
  placementNotFound,
  noPaywallViewController,
  noPresenter,
  noConfig,
  subscriptionStatusTimeout
}

class PIdentityOptions {
  bool? restorePaywallAssignments;
}

// Experiment and ConfirmedAssignment classes
class PExperiment {
  PExperiment({
    required this.id,
    required this.groupId,
    required this.variant,
  });

  String id;
  String groupId;
  PVariant variant;
}

class PVariant {
  PVariant({
    required this.id,
    required this.type,
    this.paywallId,
  });

  String id;
  PVariantType type;
  String? paywallId;
}

enum PVariantType {
  treatment,
  holdout,
}

class PConfirmedAssignment {
  PConfirmedAssignment({
    required this.experimentId,
    required this.variant,
  });

  String experimentId;
  PVariant variant;
}

// ============= HOST APIs =============

@HostApi()
abstract class PSuperwallHostApi {
  @async
  void configure(String apiKey,
      {PPurchaseControllerHost? purchaseController,
      PSuperwallOptions? options});

  void reset();

  @async
  List<PConfirmedAssignment> confirmAllAssignments();

  // Logging methods
  String getLogLevel();
  void setLogLevel(String logLevel);

  // User attributes methods
  Map<String, Object> getUserAttributes();
  void setUserAttributes(Map<String, Object> userAttributes);

  // Locale methods
  String? getLocaleIdentifier();
  void setLocaleIdentifier(String? localeIdentifier);

  // User identity methods
  String getUserId();
  bool getIsLoggedIn();
  bool getIsInitialized();
  void identify(String userId, PIdentityOptions? identityOptions);

  // Entitlements methods
  List<PEntitlement> getEntitlements();

  // Paywall methods
  PSubscriptionStatus getSubscriptionStatus();
  void setSubscriptionStatus(PSubscriptionStatus subscriptionStatus);
  PConfigurationStatus getConfigurationStatus();
  bool getIsConfigured();
  bool getIsPaywallPresented();
  void preloadAllPaywalls();
  void preloadPaywallsForPlacements(List<String> placementNames);
  bool handleDeepLink(String url);
  void togglePaywallSpinner(bool isHidden);

  // Presentation methods
  void dismiss();
}

@HostApi()
abstract class PSuperwallDelegateApi {
  void subscriptionStatusDidChange(String subscriptionStatusBridgeId);
  void handleSuperwallEvent(PSuperwallEventInfoPigeon eventInfo);
  void handleCustomPaywallAction(String name);
  void willDismissPaywall(String paywallInfoBridgeId);
  void willPresentPaywall(String paywallInfoBridgeId);
  void didDismissPaywall(String paywallInfoBridgeId);
  void didPresentPaywall(String paywallInfoBridgeId);
  void paywallWillOpenURL(String url);
  void paywallWillOpenDeepLink(String url);
  void handleLog(String level, String scope, String? message,
      Map<String, Object>? info, String? error);
}

// ============= FLUTTER APIs =============

@FlutterApi()
abstract class PPurchaseControllerGenerated {
  PPurchaseResult purchaseFromAppStore(String productId);

  PPurchaseResult purchaseFromGooglePlay(
      String productId, String? basePlanId, String? offerId);

  PRestorationResult restorePurchases();
}
