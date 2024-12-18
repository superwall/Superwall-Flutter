import 'package:superwallkit_flutter/src/public/StoreProduct.dart';
import 'package:superwallkit_flutter/src/public/StoreTransaction.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Contains information about the internally tracked superwall event.
class SuperwallEventInfo {
  SuperwallEvent event;
  Map<dynamic, dynamic>? params;

  SuperwallEventInfo({required this.event, this.params});

  factory SuperwallEventInfo.fromJson(Map<dynamic, dynamic> json) {
    return SuperwallEventInfo(
      event: SuperwallEvent.fromJson(json['event']),
      params: json['params'],
    );
  }
}

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
  shimmerViewComplete
}

class SuperwallEvent {
  final EventType type;

  // Optional per event type
  final String? eventName;
  final Map<dynamic, dynamic>? deviceAttributes;
  final String? deepLinkUrl;
  final TriggerResult? result;
  final PaywallInfo? paywallInfo;
  final StoreTransaction? transaction;
  final StoreProduct? product;
  final String? error;
  final String? triggeredEventName;
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
      this.eventName,
      this.deviceAttributes,
      this.params,
      this.deepLinkUrl,
      this.result,
      this.paywallInfo,
      this.transaction,
      this.product,
      this.error,
      this.triggeredEventName,
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

  factory SuperwallEvent.fromJson(Map<dynamic, dynamic> json) {
    switch (json['event']) {
      case 'firstSeen':
        return SuperwallEvent._(type: EventType.firstSeen);
      case 'appOpen':
        return SuperwallEvent._(type: EventType.appOpen);
      case 'appLaunch':
        return SuperwallEvent._(type: EventType.appLaunch);
      case 'identityAlias':
        return SuperwallEvent._(type: EventType.identityAlias);
      case 'appInstall':
        return SuperwallEvent._(type: EventType.appInstall);
      case 'sessionStart':
        return SuperwallEvent._(type: EventType.sessionStart);
      case 'deviceAttributes':
        return SuperwallEvent._(
            type: EventType.deviceAttributes,
            deviceAttributes: json['attributes']);
      case 'subscriptionStatusDidChange':
        return SuperwallEvent._(type: EventType.subscriptionStatusDidChange);
      case 'appClose':
        return SuperwallEvent._(type: EventType.appClose);
      case 'deepLink':
        var url = json['url'] as String?;
        return SuperwallEvent._(type: EventType.deepLink, deepLinkUrl: url);
      case 'triggerFire':
        return SuperwallEvent._(
          type: EventType.triggerFire,
          eventName: json['eventName'] as String?,
          result: TriggerResult.fromJson(json['result']),
        );
      case 'paywallOpen':
        return SuperwallEvent._(
          type: EventType.paywallOpen,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallClose':
        return SuperwallEvent._(
          type: EventType.paywallClose,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallDecline':
        return SuperwallEvent._(
          type: EventType.paywallDecline,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionStart':
        return SuperwallEvent._(
          type: EventType.transactionStart,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionFail':
        return SuperwallEvent._(
          type: EventType.transactionFail,
          error: json['error'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionAbandon':
        return SuperwallEvent._(
          type: EventType.transactionAbandon,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionComplete':
        final transactionJson = json['transaction'];

        return SuperwallEvent._(
            type: EventType.transactionComplete,
            transaction: (transactionJson != null)
                ? StoreTransaction.fromJson(transactionJson)
                : null,
            product: StoreProduct.fromJson(json['product']),
            paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']));
      case 'subscriptionStart':
        return SuperwallEvent._(
          type: EventType.subscriptionStart,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'freeTrialStart':
        return SuperwallEvent._(
          type: EventType.freeTrialStart,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionRestore':
        return SuperwallEvent._(
          type: EventType.transactionRestore,
          restoreType: RestoreType.fromJson(json['restoreType']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionTimeout':
        return SuperwallEvent._(
          type: EventType.transactionTimeout,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'userAttributes':
        return SuperwallEvent._(
            type: EventType.userAttributes, userAttributes: json['attributes']);
      case 'nonRecurringProductPurchase':
        return SuperwallEvent._(
          type: EventType.nonRecurringProductPurchase,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallResponseLoadStart':
        return SuperwallEvent._(
            type: EventType.paywallResponseLoadStart,
            triggeredEventName: json['triggeredEventName']);
      case 'paywallResponseLoadNotFound':
        return SuperwallEvent._(
            type: EventType.paywallResponseLoadNotFound,
            triggeredEventName: json['triggeredEventName']);
      case 'paywallResponseLoadFail':
        return SuperwallEvent._(
            type: EventType.paywallResponseLoadFail,
            triggeredEventName: json['triggeredEventName']);
      case 'paywallResponseLoadComplete':
        return SuperwallEvent._(
          type: EventType.paywallResponseLoadComplete,
          triggeredEventName: json['triggeredEventName'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadStart':
        return SuperwallEvent._(
          type: EventType.paywallWebviewLoadStart,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadFail':
        return SuperwallEvent._(
          type: EventType.paywallWebviewLoadFail,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadComplete':
        return SuperwallEvent._(
          type: EventType.paywallWebviewLoadComplete,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadTimeout':
        return SuperwallEvent._(
          type: EventType.paywallWebviewLoadTimeout,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadFallback':
        return SuperwallEvent._(
          type: EventType.paywallWebviewLoadFallback,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallProductsLoadStart':
        return SuperwallEvent._(
          type: EventType.paywallProductsLoadStart,
          triggeredEventName: json['triggeredEventName'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallProductsLoadFail':
        return SuperwallEvent._(
          type: EventType.paywallProductsLoadFail,
          triggeredEventName: json['triggeredEventName'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallProductsLoadComplete':
        return SuperwallEvent._(
          type: EventType.paywallProductsLoadComplete,
          triggeredEventName: json['triggeredEventName'],
        );
      case 'paywallProductsLoadRetry':
        return SuperwallEvent._(
          type: EventType.paywallProductsLoadRetry,
          triggeredEventName: json['triggeredEventName'],
          attempt: json['attempt'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'surveyResponse':
        return SuperwallEvent._(
          type: EventType.surveyResponse,
          survey: Survey.fromJson(json['survey']),
          selectedOption: SurveyOption.fromJson(json['selectedOption']),
          customResponse: json['customResponse'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallPresentationRequest':
        final statusReasonJson = json['reason'];

        return SuperwallEvent._(
            type: EventType.paywallPresentationRequest,
            status: PaywallPresentationRequestStatus.fromJson(json['status']),
            reason: (statusReasonJson != null)
                ? PaywallPresentationRequestStatusReason.fromJson(
                    statusReasonJson)
                : null);
      case 'touchesBegan':
        return SuperwallEvent._(type: EventType.touchesBegan);
      case 'surveyClose':
        return SuperwallEvent._(type: EventType.surveyClose);
      case 'configRefresh':
        return SuperwallEvent._(type: EventType.configRefresh);
      case 'reset':
        return SuperwallEvent._(type: EventType.reset);
      case 'customPlacement':
        return SuperwallEvent._(
          type: EventType.customPlacement,
          name: json['name'],
          params: json['params'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'configAttributes':
        return SuperwallEvent._(type: EventType.configAttributes);
      case 'confirmAllAssignments':
        return SuperwallEvent._(type: EventType.confirmAllAssignments);
      case 'configFail':
        return SuperwallEvent._(type: EventType.configFail);
      case 'adServicesTokenRequestStart':
        return SuperwallEvent._(type: EventType.adServicesTokenRequestStart);
      case 'adServicesTokenRequestFail':
        return SuperwallEvent._(
            type: EventType.adServicesTokenRequestFail, error: json['error']);
      case 'adServicesTokenRequestComplete':
        return SuperwallEvent._(
            type: EventType.adServicesTokenRequestComplete,
            token: json['token']);
      case 'shimmerViewStart':
        return SuperwallEvent._(type: EventType.shimmerViewStart);
      case 'shimmerViewComplete':
        return SuperwallEvent._(type: EventType.shimmerViewComplete);
      default:
        throw ArgumentError('Invalid event type');
    }
  }
}
