import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/generated/superwallhost.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/src/main/kotlin/com/superwall/superwallkit_flutter/SuperwallHostGenerated.g.kt',
  kotlinOptions: KotlinOptions(),
  dartPackageName: 'superwallkit_flutter',
  swiftOut: 'ios/Classes/SuperwallHostGenerated.swift',
  swiftOptions: SwiftOptions(),
))

// ============= CLASSES, ENUMS, DATA MODELS =============

sealed class PRedemptionResult {
  PRedemptionResult();
}

class PSuccessRedemptionResult extends PRedemptionResult {
  String code;
  PRedemptionInfo redemptionInfo;

  PSuccessRedemptionResult({
    required this.code,
    required this.redemptionInfo,
  });
}

class PErrorRedemptionResult extends PRedemptionResult {
  String code;
  PErrorInfo error;

  PErrorRedemptionResult({
    required this.code,
    required this.error,
  });
}

class PErrorInfo {
  String message;
  PErrorInfo(this.message);
}

class PExpiredCodeRedemptionResult extends PRedemptionResult {
  String code;
  PExpiredCodeInfo info;

  PExpiredCodeRedemptionResult({
    required this.code,
    required this.info,
  });
}

/// Info about the expired code.
class PExpiredCodeInfo {
  /// A boolean indicating whether the redemption email has been resent.
  bool resent;

  /// An optional String indicating the obfuscated email address that the
  /// redemption email was sent to.
  String? obfuscatedEmail;

  PExpiredCodeInfo({
    required this.resent,
    this.obfuscatedEmail,
  });
}

class PInvalidCodeRedemptionResult extends PRedemptionResult {
  String code;
  PInvalidCodeRedemptionResult(this.code);
}

class PExpiredSubscriptionCode extends PRedemptionResult {
  String code;
  PRedemptionInfo redemptionInfo;
  PExpiredSubscriptionCode(this.code, this.redemptionInfo);
}

/// Information about the redemption.
class PRedemptionInfo {
  /// The ownership of the code.
  final POwnership ownership;

  /// Info about the purchaser.
  final PPurchaserInfo purchaserInfo;

  /// Info about the paywall the purchase was made from.
  final PRedemptionPaywallInfo? paywallInfo;

  /// The entitlements array.
  final List<PEntitlement> entitlements;

  PRedemptionInfo({
    required this.ownership,
    required this.purchaserInfo,
    this.paywallInfo,
    required this.entitlements,
  });
}

/// Enum specifying code ownership.
sealed class POwnership {
  const POwnership();
}

class PAppUserOwnership extends POwnership {
  final String appUserId;
  const PAppUserOwnership(this.appUserId);
}

class PDeviceOwnership extends POwnership {
  final String deviceId;
  const PDeviceOwnership(this.deviceId);
}

/// Info about the purchaser.
class PPurchaserInfo {
  /// The app user ID of the purchaser.
  final String appUserId;

  /// The email address of the purchaser.
  final String? email;

  /// The identifiers of the store that was purchased from.
  final PStoreIdentifiers storeIdentifiers;

  PPurchaserInfo({
    required this.appUserId,
    this.email,
    required this.storeIdentifiers,
  });
}

/// Identifiers of the store that was purchased from.
sealed class PStoreIdentifiers {
  const PStoreIdentifiers();
}

/// Stripe purchase store identifiers.
class PStripeStoreIdentifiers extends PStoreIdentifiers {
  final String customerId;
  final List<String> subscriptionIds;

  const PStripeStoreIdentifiers({
    required this.customerId,
    required this.subscriptionIds,
  });
}

/// Stripe purchase store identifiers.
class PPaddleStoreIdentifiers extends PStoreIdentifiers {
  final String customerId;
  final List<String> subscriptionIds;

  const PPaddleStoreIdentifiers({
    required this.customerId,
    required this.subscriptionIds,
  });
}

/// Unknown purchase store identifiers.
class PUnknownStoreIdentifiers extends PStoreIdentifiers {
  final String store;
  final Map<String, Object> additionalInfo;

  const PUnknownStoreIdentifiers({
    required this.store,
    required this.additionalInfo,
  });
}

/// Info about the paywall the purchase was made from.
class PRedemptionPaywallInfo {
  /// The identifier of the paywall.
  final String identifier;

  /// The name of the placement.
  final String placementName;

  /// The params of the placement.
  final Map<String, Object> placementParams;

  /// The ID of the paywall variant.
  final String variantId;

  /// The ID of the experiment that the paywall belongs to.
  final String experimentId;

  PRedemptionPaywallInfo({
    required this.identifier,
    required this.placementName,
    required this.placementParams,
    required this.variantId,
    required this.experimentId,
  });
}

// Options for configuring Superwall
class PSuperwallOptions {
  PPaywallOptions? paywalls;
  PNetworkEnvironment? networkEnvironment;
  bool? isExternalDataCollectionEnabled;
  String? localeIdentifier;
  bool? isGameControllerEnabled;
  bool? enableExperimentalDeviceVariables;
  PLogging? logging;
  bool? passIdentifiersToPlayStore;
}

// PaywallInfo class for getting latest paywall info
class PPaywallInfo {
  PPaywallInfo({
    this.identifier,
    this.name,
    this.experiment,
    this.productIds,
    this.products,
    this.url,
    this.presentedByPlacementWithName,
    this.presentedByPlacementWithId,
    this.presentedByPlacementAt,
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

  String? identifier;
  String? name;
  PExperiment? experiment;
  List<String>? productIds;
  List<PProduct>? products;
  String? url;
  String? presentedByPlacementWithName;
  String? presentedByPlacementWithId;
  String? presentedByPlacementAt;
  String? presentedBy;
  String? presentationSourceType;
  String? responseLoadStartTime;
  String? responseLoadCompleteTime;
  String? responseLoadFailTime;
  double? responseLoadDuration;
  String? webViewLoadStartTime;
  String? webViewLoadCompleteTime;
  String? webViewLoadFailTime;
  double? webViewLoadDuration;
  String? productsLoadStartTime;
  String? productsLoadCompleteTime;
  String? productsLoadFailTime;
  double? productsLoadDuration;
  String? paywalljsVersion;
  bool? isFreeTrialAvailable;
  PFeatureGatingBehavior? featureGatingBehavior;
  PPaywallCloseReason? closeReason;
  List<PLocalNotification>? localNotifications;
  List<PComputedPropertyRequest>? computedPropertyRequests;
  List<PSurvey>? surveys;
}

// Product class for paywall products
class PProduct {
  String? id;
  String? name;
  List<PEntitlement>? entitlements;

  PProduct({
    this.id,
    this.name,
    this.entitlements,
  });
}

// FeatureGatingBehavior class
enum PFeatureGatingBehavior {
  gated,
  nonGated,
}

// PaywallCloseReason class
enum PPaywallCloseReason {
  /// The paywall was closed by system logic, either after a purchase, because
  /// a deeplink was presented, close button pressed, etc.
  systemLogic,

  /// The paywall was automatically closed because another paywall will show.
  ///
  /// This prevents ``Superwall/register(placement:params:handler:feature:)`` `feature`
  /// block from executing on dismiss of the paywall, because another paywall is set to show
  forNextPaywall,

  /// The paywall was closed because the webview couldn't be loaded.
  ///
  /// If this happens for a gated paywall, the ``PaywallPresentationHandler/onError(_:)``
  /// handler will be called. If it's for a non-gated paywall, the feature block will be called.
  webViewFailedToLoad,

  /// The paywall was closed because the user tapped the close button or dragged to dismiss.
  manualClose,

  /// The paywall hasn't been closed yet.
  none;
}

// LocalNotification class
class PLocalNotification {
  int id;
  PLocalNotificationType type;
  String title;
  String? subtitle;
  String body;
  int delay;

  PLocalNotification({
    this.id = 0,
    required this.type,
    required this.title,
    this.subtitle,
    required this.body,
    required this.delay,
  });
}

enum PLocalNotificationType {
  trialStarted,
  unsupported,
}

// ComputedPropertyRequest class
class PComputedPropertyRequest {
  final PComputedPropertyRequestType type;
  final String eventName;

  PComputedPropertyRequest({
    required this.type,
    required this.eventName,
  });
}

enum PComputedPropertyRequestType {
  minutesSince,
  hoursSince,
  daysSince,
  monthsSince,
  yearsSince,
  placementsInHour,
  placementsInDay,
  placementsInWeek,
  placementsInMonth,
  placementsSinceInstall,
}

// Survey class
class PSurvey {
  String id;
  String assignmentKey;
  String title;
  String message;
  List<PSurveyOption> options;
  PSurveyShowCondition presentationCondition;
  double presentationProbability;
  bool includeOtherOption;
  bool includeCloseOption;

  PSurvey({
    required this.id,
    required this.assignmentKey,
    required this.title,
    required this.message,
    required this.options,
    required this.presentationCondition,
    required this.presentationProbability,
    required this.includeOtherOption,
    required this.includeCloseOption,
  });
}

enum PSurveyShowCondition {
  onManualClose,
  onPurchase,
}

// SurveyOption class
class PSurveyOption {
  String? id;
  String? text;

  PSurveyOption({
    this.id,
    this.text,
  });
}

sealed class PPurchaseResult {
  PPurchaseResult();
}

class PPurchaseCancelled extends PPurchaseResult {
  bool? ignore;
  PPurchaseCancelled(this.ignore);
}

class PPurchasePurchased extends PPurchaseResult {
  bool? ignore;
  PPurchasePurchased(this.ignore);
}

class PPurchasePending extends PPurchaseResult {
  bool? ignore;
  PPurchasePending(this.ignore);
}

class PPurchaseFailed extends PPurchaseResult {
  String? error;
  PPurchaseFailed(this.error);
}

sealed class PRestorationResult {
  PRestorationResult();
}

class PRestorationRestored extends PRestorationResult {
  bool? ignore;
  PRestorationRestored(this.ignore);
}

class PRestorationFailed extends PRestorationResult {
  String? error;
  PRestorationFailed(this.error);
}

sealed class PRestoreType {
  PRestoreType();
}

class PViaPurchase extends PRestoreType {
  PStoreTransaction? storeTransaction;
  PViaPurchase(this.storeTransaction);
}

class PViaRestore extends PRestoreType {
  bool? ignore;
  PViaRestore(this.ignore);
}

class PRestoreFailed {
  // The title of the alert presented to the user when restoring a transaction
  // fails.
  String? title;

  // Defines the message of the alert presented to the user when restoring a
  // transaction fails.
  String? message;

  // Defines the title of the close button in the alert presented to the user.
  String? closeButtonTitle;
}

class PLogging {
  PLogLevel? level;
  List<PLogScope>? scopes;
}

class PStoreTransaction {
  String configRequestId;
  String appSessionId;
  String? transactionDate;
  String originalTransactionIdentifier;
  String? storeTransactionId;
  String? originalTransactionDate;
  String? webOrderLineItemID;
  String? appBundleId;
  String? subscriptionGroupId;
  bool? isUpgraded;
  String? expirationDate;
  String? offerId;
  String? revocationDate;

  PStoreTransaction(
      this.configRequestId,
      this.appSessionId,
      this.transactionDate,
      this.originalTransactionIdentifier,
      this.storeTransactionId,
      this.originalTransactionDate,
      this.webOrderLineItemID,
      this.appBundleId,
      this.subscriptionGroupId,
      this.isUpgraded,
      this.expirationDate,
      this.offerId,
      this.revocationDate);
}

class PStoreProduct {
  List<PEntitlement> entitlements;
  String productIdentifier;
  String? subscriptionGroupIdentifier;
  Map<String, String> attributes;
  String localizedPrice;
  String localizedSubscriptionPeriod;
  String period;
  String periodly;
  int periodWeeks;
  String periodWeeksString;
  int periodMonths;
  String periodMonthsString;
  int periodYears;
  String periodYearsString;
  int periodDays;
  String periodDaysString;
  String dailyPrice;
  String weeklyPrice;
  String monthlyPrice;
  String yearlyPrice;
  bool hasFreeTrial;
  String? trialPeriodEndDate;
  String trialPeriodEndDateString;
  String localizedTrialPeriodPrice;
  double trialPeriodPrice;
  int trialPeriodDays;
  String trialPeriodDaysString;
  int trialPeriodWeeks;
  String trialPeriodWeeksString;
  int trialPeriodMonths;
  String trialPeriodMonthsString;
  int trialPeriodYears;
  String trialPeriodYearsString;
  String trialPeriodText;
  String locale;
  String? languageCode;
  String? currencySymbol;
  String? currencyCode;
  bool isFamilyShareable;
  String? regionCode;
  double price;

  PStoreProduct(
      this.entitlements,
      this.productIdentifier,
      this.subscriptionGroupIdentifier,
      this.attributes,
      this.localizedPrice,
      this.localizedSubscriptionPeriod,
      this.period,
      this.periodly,
      this.periodWeeks,
      this.periodWeeksString,
      this.periodMonths,
      this.periodMonthsString,
      this.periodYears,
      this.periodYearsString,
      this.periodDays,
      this.periodDaysString,
      this.dailyPrice,
      this.weeklyPrice,
      this.monthlyPrice,
      this.yearlyPrice,
      this.hasFreeTrial,
      this.trialPeriodEndDate,
      this.trialPeriodEndDateString,
      this.localizedTrialPeriodPrice,
      this.trialPeriodPrice,
      this.trialPeriodDays,
      this.trialPeriodDaysString,
      this.trialPeriodWeeks,
      this.trialPeriodWeeksString,
      this.trialPeriodMonths,
      this.trialPeriodMonthsString,
      this.trialPeriodYears,
      this.trialPeriodYearsString,
      this.trialPeriodText,
      this.locale,
      this.languageCode,
      this.currencyCode,
      this.currencySymbol,
      this.isFamilyShareable,
      this.regionCode,
      this.price);
}

class PPaywallOptions {
  bool? isHapticFeedbackEnabled;
  PRestoreFailed? restoreFailed;
  bool? shouldShowPurchaseFailureAlert;
  bool? shouldPreload;
  bool? automaticallyDismiss;
  bool? shouldShowWebRestorationAlert;
  PTransactionBackgroundView? transactionBackgroundView;
  Map<String, String>? overrideProductsByName;
  bool? shouldShowWebPurchaseConfirmationAlert;
}

class PPurchaseControllerHost {
  // The hostId is unused since only one can exist here at a time
  String? hostId;
}

class PConfigureCompletionHost {
  // The hostId is unused since only one can exist here at a time
  String? hostId;
}

class PPaywallPresentationHandlerHost {
  // The hostId is used here to identify the flutter handler based on the id
  String? hostId;
}

class PFeatureHandlerHost {
  // The hostId is used here to identify the flutter handler based on the id
  String? hostId;
}

class PEntitlement {
  String? id;
}

class PEntitlements {
  List<PEntitlement> active;
  List<PEntitlement> inactive;
  List<PEntitlement> all;

  PEntitlements(this.active, this.inactive, this.all);
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
  bool? ignore;
  PInactive(this.ignore);
}

class PUnknown extends PSubscriptionStatus {
  bool? ignore;
  PUnknown(this.ignore);
}

// SuperwallEventInfo class for event handling
class PSuperwallEventInfo {
  PEventType eventType;
  Map<String, Object>? params;
  String? placementName;
  Map<String, Object>? deviceAttributes;
  String? deepLinkUrl;
  PTriggerResult? result;
  PPaywallInfo? paywallInfo;
  PStoreTransaction? transaction;
  PStoreProduct? product;
  String? error;
  String? triggeredPlacementName;
  int? attempt;
  String? name;
  PSurvey? survey;
  PSurveyOption? selectedOption;
  String? customResponse;
  PPaywallPresentationRequestStatusType? status;
  PPaywallPresentationRequestStatusReason? reason;
  PRestoreType? restoreType;
  Map<String, Object>? userAttributes;
  String? token;
  Map<String, Object>? userEnrichment;
  Map<String, Object>? deviceEnrichment;
  String? message;

  PSuperwallEventInfo(
      {required this.eventType,
      this.params,
      this.placementName,
      this.deviceAttributes,
      this.deepLinkUrl,
      this.result,
      this.paywallInfo,
      this.transaction,
      this.product,
      this.error,
      this.triggeredPlacementName,
      this.attempt,
      this.name,
      this.survey,
      this.selectedOption,
      this.customResponse,
      this.status,
      this.reason,
      this.restoreType,
      this.userAttributes,
      this.token,
      this.userEnrichment,
      this.deviceEnrichment,
      this.message});
}

// Enums
enum PNetworkEnvironment {
  // Default: Uses the standard latest environment.
  release,

  // **WARNING**: Uses a release candidate environment. This is not meant
  // for a production environment.
  releaseCandidate,

  // **WARNING**: Uses the nightly build environment. This is not meant for
  // a production environment.
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
  paywallResourceLoadFail,
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
  shimmerViewComplete,
  redemptionStart,
  redemptionComplete,
  redemptionFail,
  enrichmentStart,
  enrichmentComplete,
  enrichmentFail,
  networkDecodingFail
}

// SubscriptionStatus enum
enum PSubscriptionStatusType { active, inactive, unknown }

// PaywallPresentationRequestStatus
enum PPaywallPresentationRequestStatusType {
  presentation,
  noPresentation,
  timeout
}

sealed class PPaywallPresentationRequestStatusReason {
  PPaywallPresentationRequestStatusReason();
}

class PStatusReasonDebuggerPresented
    extends PPaywallPresentationRequestStatusReason {
  bool? ignore;
  PStatusReasonDebuggerPresented(this.ignore);
}

class PStatusReasonPaywallAlreadyPresented
    extends PPaywallPresentationRequestStatusReason {
  bool? ignore;
  PStatusReasonPaywallAlreadyPresented(this.ignore);
}

class PStatusReasonHoldout extends PPaywallPresentationRequestStatusReason {
  PExperiment experiment;
  PStatusReasonHoldout(this.experiment);
}

class PStatusReasonNoAudienceMatch
    extends PPaywallPresentationRequestStatusReason {
  bool? ignore;
  PStatusReasonNoAudienceMatch(this.ignore);
}

class PStatusReasonPlacementNotFound
    extends PPaywallPresentationRequestStatusReason {
  bool? ignore;
  PStatusReasonPlacementNotFound(this.ignore);
}

class PStatusReasonNoPaywallVc extends PPaywallPresentationRequestStatusReason {
  bool? ignore;
  PStatusReasonNoPaywallVc(this.ignore);
}

class PStatusReasonNoPresenter extends PPaywallPresentationRequestStatusReason {
  bool? ignore;
  PStatusReasonNoPresenter(this.ignore);
}

class PStatusReasonNoConfig extends PPaywallPresentationRequestStatusReason {
  bool? ignore;
  PStatusReasonNoConfig(this.ignore);
}

class PStatusReasonSubsStatusTimeout
    extends PPaywallPresentationRequestStatusReason {
  bool? ignore;
  PStatusReasonSubsStatusTimeout(this.ignore);
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

// TriggerResult sealed class and related types
sealed class PTriggerResult {
  PTriggerResult();
}

class PPlacementNotFoundTriggerResult extends PTriggerResult {
  bool? ignore;
  PPlacementNotFoundTriggerResult(this.ignore);
}

class PNoAudienceMatchTriggerResult extends PTriggerResult {
  bool? ignore;
  PNoAudienceMatchTriggerResult(this.ignore);
}

class PPaywallTriggerResult extends PTriggerResult {
  PExperiment experiment;
  PPaywallTriggerResult({required this.experiment});
}

class PHoldoutTriggerResult extends PTriggerResult {
  PExperiment experiment;
  PHoldoutTriggerResult({required this.experiment});
}

class PErrorTriggerResult extends PTriggerResult {
  String error;
  PErrorTriggerResult({required this.error});
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

enum PPaywallSkippedReason {
  holdout,
  noAudienceMatch,
  placementNotFound,
}

sealed class PPaywallResult {
  PPaywallResult();
}

class PPurchasedPaywallResult extends PPaywallResult {
  String productId;
  PPurchasedPaywallResult({required this.productId});
}

class PDeclinedPaywallResult extends PPaywallResult {
  bool? ignore;
  PDeclinedPaywallResult(this.ignore);
}

class PRestoredPaywallResult extends PPaywallResult {
  bool? ignore;
  PRestoredPaywallResult(this.ignore);
}

sealed class PPresentationResult {
  PPresentationResult();
}

class PPlacementNotFoundPresentationResult extends PPresentationResult {
  bool? ignore;
  PPlacementNotFoundPresentationResult(this.ignore);
}

class PNoAudienceMatchPresentationResult extends PPresentationResult {
  bool? ignore;
  PNoAudienceMatchPresentationResult(this.ignore);
}

class PPaywallPresentationResult extends PPresentationResult {
  PExperiment experiment;
  PPaywallPresentationResult(this.experiment);
}

class PHoldoutPresentationResult extends PPresentationResult {
  PExperiment experiment;
  PHoldoutPresentationResult(this.experiment);
}

class PPaywallNotAvailablePresentationResult extends PPresentationResult {
  bool? ignore;
  PPaywallNotAvailablePresentationResult(this.ignore);
}
// ============= HOST APIs =============

@HostApi()
abstract class PSuperwallHostApi {
  @async
  void configure(
    String apiKey, {
    PPurchaseControllerHost? purchaseController,
    PSuperwallOptions? options,
    PConfigureCompletionHost? completion,
  });

  void reset();
  void setDelegate(bool hasDelegate);

  @async
  List<PConfirmedAssignment> confirmAllAssignments();

  @async
  PRestorationResult restorePurchases();

  // Logging methods
  String getLogLevel();
  void setLogLevel(String logLevel);

  // User attributes methods
  Map<String, Object> getUserAttributes();
  void setUserAttributes(Map<String, Object> userAttributes);

  @async
  Map<String, Object> getDeviceAttributes();

  @async
  String consume(String purchaseToken);

  // Locale methods
  String? getLocaleIdentifier();
  void setLocaleIdentifier(String? localeIdentifier);

  // User identity methods
  String getUserId();
  bool getIsLoggedIn();
  bool getIsInitialized();
  void identify(String userId, PIdentityOptions? identityOptions);

  // Entitlements methods
  PEntitlements getEntitlements();

  // Subscription status methods
  PSubscriptionStatus getSubscriptionStatus();
  void setSubscriptionStatus(PSubscriptionStatus subscriptionStatus);

  // Configuration methods
  PConfigurationStatus getConfigurationStatus();
  bool getIsConfigured();

  // Presentation methods
  @async
  PPresentationResult getPresentationResult(
      String placement, Map<String, Object>? params);

  // Paywall methods
  bool getIsPaywallPresented();
  void preloadAllPaywalls();
  void preloadPaywallsForPlacements(List<String> placementNames);
  bool handleDeepLink(String url);
  void togglePaywallSpinner(bool isHidden);
  PPaywallInfo? getLatestPaywallInfo();
  @async
  void registerPlacement(String placement,
      {Map<String, Object>? params,
      PPaywallPresentationHandlerHost? handler,
      PFeatureHandlerHost? feature});
  // Presentation methods
  void dismiss();

  // Override products by name globally - getter and setter
  Map<String, String>? getOverrideProductsByName();
  void setOverrideProductsByName(Map<String, String>? overrideProducts);
}

@FlutterApi()
abstract class PSuperwallDelegateGenerated {
  void subscriptionStatusDidChange(
      PSubscriptionStatus from, PSubscriptionStatus to);
  void handleSuperwallEvent(PSuperwallEventInfo eventInfo);
  void handleCustomPaywallAction(String name);
  void willDismissPaywall(PPaywallInfo paywallInfo);
  void willPresentPaywall(PPaywallInfo paywallInfo);
  void didDismissPaywall(PPaywallInfo paywallInfo);
  void didPresentPaywall(PPaywallInfo paywallInfo);
  void paywallWillOpenURL(String url);
  void paywallWillOpenDeepLink(String url);
  void handleLog(String level, String scope, String? message,
      Map<String, Object>? info, String? error);
  void willRedeemLink();
  void didRedeemLink(PRedemptionResult result);
  void handleSuperwallDeepLink(String fullURL, List<String> pathComponents,
      Map<String, String> queryParameters);
}

// ============= FLUTTER APIs =============

@FlutterApi()
abstract class PPurchaseControllerGenerated {
  @async
  PPurchaseResult purchaseFromAppStore(String productId);

  @async
  PPurchaseResult purchaseFromGooglePlay(
      String productId, String? basePlanId, String? offerId);

  @async
  PRestorationResult restorePurchases();
}

@FlutterApi()
abstract class PConfigureCompletionGenerated {
  void onConfigureCompleted(bool success);
}

@FlutterApi()
abstract class PPaywallPresentationHandlerGenerated {
  void onPresent(PPaywallInfo paywallInfo);
  void onDismiss(PPaywallInfo paywallInfo, PPaywallResult paywallResult);
  void onError(String error);
  void onSkip(PPaywallSkippedReason reason);
}

@FlutterApi()
abstract class PFeatureHandlerGenerated {
  void onFeature(String id);
}

@EventChannelApi()
abstract class SubscriptionStatusStream {
  PSubscriptionStatus streamSubscriptionStatus();
}
