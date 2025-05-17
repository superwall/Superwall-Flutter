import 'package:superwallkit_flutter/src/public/StoreProduct.dart';
import 'package:superwallkit_flutter/src/public/StoreTransaction.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// Contains information about the internally tracked superwall placement.
class SuperwallEventInfo {
  SuperwallEvent event;
  Map<dynamic, dynamic>? params;

  SuperwallEventInfo({required this.event, this.params});

  factory SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo eventInfo) {
    return SuperwallEventInfo(
      event: SuperwallEvent.fromPEventType(eventInfo.eventType,
          paywallInfo: eventInfo.paywallInfo, params: eventInfo.params),
      params: eventInfo.params,
    );
  }
}

@Deprecated('Use EventType instead')
typedef PlacementType = EventType;

@Deprecated('Use SuperwallEvent instead')
typedef SuperwallPlacement = SuperwallEvent;

@Deprecated('Use SuperwallEventInfo instead')
typedef SuperwallPlacementInfo = SuperwallEventInfo;

enum EventType {
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
  shimmerViewComplete,
  redemptionStart,
  redemptionComplete,
  redemptionFail,
  enrichmentStart,
  enrichmentComplete,
  enrichmentFail,
  networkDecodingFail
}

class SuperwallEvent {
  final EventType type;

  // Optional per placement type
  final String? placementName;
  final Map<dynamic, dynamic>? deviceAttributes;
  final String? deepLinkUrl;
  final TriggerResult? result;
  final PaywallInfo? paywallInfo;
  final StoreTransaction? transaction;
  final StoreProduct? product;
  final String? error;
  final String? triggeredPlacementName;
  final Map<dynamic, dynamic>? params;
  final String? attempt;
  final String? name;
  final Survey? survey;
  final SurveyOption? selectedOption;
  final String? customResponse;
  final PaywallPresentationRequestStatus? status;
  final PaywallPresentationRequestStatusReason? reason;
  final RestoreType? restoreType;
  final Map<dynamic, dynamic>? userAttributes;
  final String? token;

  SuperwallEvent._(
      {required this.type,
      this.placementName,
      this.deviceAttributes,
      this.params,
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
      this.token});

  factory SuperwallEvent.fromPEventType(
    PEventType eventType, {
    String? placementName,
    Map<dynamic, dynamic>? deviceAttributes,
    Map<dynamic, dynamic>? params,
    String? deepLinkUrl,
    PTriggerResult? result,
    PPaywallInfo? paywallInfo,
    PStoreTransaction? transaction,
    PStoreProduct? product,
    String? error,
    String? triggeredPlacementName,
    String? attempt,
    String? name,
    PSurvey? survey,
    PSurveyOption? selectedOption,
    String? customResponse,
    PPaywallPresentationRequestStatusType? status,
    PPaywallPresentationRequestStatusReason? reason,
    PRestoreType? restoreType,
    Map<dynamic, dynamic>? userAttributes,
    String? token,
  }) {
    EventType type;

    // Map the PEventType to EventType
    switch (eventType) {
      case PEventType.firstSeen:
        type = EventType.firstSeen;
        break;
      case PEventType.appOpen:
        type = EventType.appOpen;
        break;
      case PEventType.appLaunch:
        type = EventType.appLaunch;
        break;
      case PEventType.identityAlias:
        type = EventType.identityAlias;
        break;
      case PEventType.appInstall:
        type = EventType.appInstall;
        break;
      case PEventType.restoreStart:
        type = EventType.restoreStart;
        break;
      case PEventType.restoreComplete:
        type = EventType.restoreComplete;
        break;
      case PEventType.restoreFail:
        type = EventType.restoreFail;
        break;
      case PEventType.sessionStart:
        type = EventType.sessionStart;
        break;
      case PEventType.deviceAttributes:
        type = EventType.deviceAttributes;
        break;
      case PEventType.subscriptionStatusDidChange:
        type = EventType.subscriptionStatusDidChange;
        break;
      case PEventType.appClose:
        type = EventType.appClose;
        break;
      case PEventType.deepLink:
        type = EventType.deepLink;
        break;
      case PEventType.triggerFire:
        type = EventType.triggerFire;
        break;
      case PEventType.paywallOpen:
        type = EventType.paywallOpen;
        break;
      case PEventType.paywallClose:
        type = EventType.paywallClose;
        break;
      case PEventType.paywallDecline:
        type = EventType.paywallDecline;
        break;
      case PEventType.transactionStart:
        type = EventType.transactionStart;
        break;
      case PEventType.transactionFail:
        type = EventType.transactionFail;
        break;
      case PEventType.transactionAbandon:
        type = EventType.transactionAbandon;
        break;
      case PEventType.transactionComplete:
        type = EventType.transactionComplete;
        break;
      case PEventType.subscriptionStart:
        type = EventType.subscriptionStart;
        break;
      case PEventType.freeTrialStart:
        type = EventType.freeTrialStart;
        break;
      case PEventType.transactionRestore:
        type = EventType.transactionRestore;
        break;
      case PEventType.transactionTimeout:
        type = EventType.transactionTimeout;
        break;
      case PEventType.userAttributes:
        type = EventType.userAttributes;
        break;
      case PEventType.nonRecurringProductPurchase:
        type = EventType.nonRecurringProductPurchase;
        break;
      case PEventType.paywallResponseLoadStart:
        type = EventType.paywallResponseLoadStart;
        break;
      case PEventType.paywallResponseLoadNotFound:
        type = EventType.paywallResponseLoadNotFound;
        break;
      case PEventType.paywallResponseLoadFail:
        type = EventType.paywallResponseLoadFail;
        break;
      case PEventType.paywallResponseLoadComplete:
        type = EventType.paywallResponseLoadComplete;
        break;
      case PEventType.paywallWebviewLoadStart:
        type = EventType.paywallWebviewLoadStart;
        break;
      case PEventType.paywallWebviewLoadFail:
        type = EventType.paywallWebviewLoadFail;
        break;
      case PEventType.paywallWebviewLoadComplete:
        type = EventType.paywallWebviewLoadComplete;
        break;
      case PEventType.paywallWebviewLoadTimeout:
        type = EventType.paywallWebviewLoadTimeout;
        break;
      case PEventType.paywallWebviewLoadFallback:
        type = EventType.paywallWebviewLoadFallback;
        break;
      case PEventType.paywallProductsLoadRetry:
        type = EventType.paywallProductsLoadRetry;
        break;
      case PEventType.paywallProductsLoadStart:
        type = EventType.paywallProductsLoadStart;
        break;
      case PEventType.paywallProductsLoadFail:
        type = EventType.paywallProductsLoadFail;
        break;
      case PEventType.paywallProductsLoadComplete:
        type = EventType.paywallProductsLoadComplete;
        break;
      case PEventType.paywallResourceLoadFail:
        // No exact match in EventType, using closest equivalent
        type = EventType.paywallResponseLoadFail;
        break;
      case PEventType.surveyResponse:
        type = EventType.surveyResponse;
        break;
      case PEventType.paywallPresentationRequest:
        type = EventType.paywallPresentationRequest;
        break;
      case PEventType.touchesBegan:
        type = EventType.touchesBegan;
        break;
      case PEventType.surveyClose:
        type = EventType.surveyClose;
        break;
      case PEventType.reset:
        type = EventType.reset;
        break;
      case PEventType.configRefresh:
        type = EventType.configRefresh;
        break;
      case PEventType.customPlacement:
        type = EventType.customPlacement;
        break;
      case PEventType.configAttributes:
        type = EventType.configAttributes;
        break;
      case PEventType.confirmAllAssignments:
        type = EventType.confirmAllAssignments;
        break;
      case PEventType.configFail:
        type = EventType.configFail;
        break;
      case PEventType.adServicesTokenRequestStart:
        type = EventType.adServicesTokenRequestStart;
        break;
      case PEventType.adServicesTokenRequestFail:
        type = EventType.adServicesTokenRequestFail;
        break;
      case PEventType.adServicesTokenRequestComplete:
        type = EventType.adServicesTokenRequestComplete;
        break;
      case PEventType.shimmerViewStart:
        type = EventType.shimmerViewStart;
        break;
      case PEventType.shimmerViewComplete:
        type = EventType.shimmerViewComplete;
        break;
      case PEventType.redemptionStart:
        type = EventType.redemptionStart;
        break;
      case PEventType.redemptionComplete:
        type = EventType.redemptionComplete;
        break;
      case PEventType.redemptionFail:
        type = EventType.redemptionFail;
        break;
      case PEventType.enrichmentStart:
        type = EventType.enrichmentStart;
        break;
      case PEventType.enrichmentFail:
        type = EventType.enrichmentFail;
        break;
      case PEventType.enrichmentComplete:
        type = EventType.enrichmentComplete;
        break;
      case PEventType.networkDecodingFail:
        type = EventType.networkDecodingFail;
    }

    return SuperwallEvent._(
      type: type,
      placementName: placementName,
      deviceAttributes: deviceAttributes,
      params: params,
      deepLinkUrl: deepLinkUrl,
      result: result != null ? TriggerResult.fromPTriggerResult(result) : null,
      paywallInfo: PaywallInfo.fromPigeon(paywallInfo),
      transaction:
          transaction != null ? StoreTransaction.fromPigeon(transaction) : null,
      product: product != null ? StoreProduct.fromPigeon(product) : null,
      error: error,
      triggeredPlacementName: triggeredPlacementName,
      attempt: attempt,
      name: name,
      survey: survey != null ? Survey.fromPigeon(survey) : null,
      selectedOption: selectedOption != null
          ? SurveyOption.fromPigeon(selectedOption)
          : null,
      customResponse: customResponse,
      status: status != null
          ? PaywallPresentationRequestStatus.fromPigeon(status)
          : null,
      reason: reason != null
          ? PaywallPresentationRequestStatusReason.fromPigeon(reason)
          : null,
      restoreType:
          restoreType != null ? RestoreType.fromPigeon(restoreType) : null,
      userAttributes: userAttributes,
      token: token,
    );
  }
}
