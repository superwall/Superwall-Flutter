import 'package:superwallkit_flutter/src/public/StoreProduct.dart';
import 'package:superwallkit_flutter/src/public/StoreTransaction.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Contains information about the internally tracked superwall placement.
class SuperwallPlacementInfo {
  SuperwallPlacement placement;
  Map<dynamic, dynamic>? params;

  SuperwallPlacementInfo({required this.placement, this.params});

  factory SuperwallPlacementInfo.fromJson(Map<dynamic, dynamic> json) {
    return SuperwallPlacementInfo(
      placement: SuperwallPlacement.fromJson(json['placement']),
      params: json['params'],
    );
  }
}

enum PlacementType {
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
  entitlementStatusDidChange,
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

class SuperwallPlacement {
  final PlacementType type;

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

  SuperwallPlacement._(
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

  factory SuperwallPlacement.fromJson(Map<dynamic, dynamic> json) {
    switch (json['placement']) {
      case 'firstSeen':
        return SuperwallPlacement._(type: PlacementType.firstSeen);
      case 'appOpen':
        return SuperwallPlacement._(type: PlacementType.appOpen);
      case 'appLaunch':
        return SuperwallPlacement._(type: PlacementType.appLaunch);
      case 'identityAlias':
        return SuperwallPlacement._(type: PlacementType.identityAlias);
      case 'appInstall':
        return SuperwallPlacement._(type: PlacementType.appInstall);
      case 'sessionStart':
        return SuperwallPlacement._(type: PlacementType.sessionStart);
      case 'deviceAttributes':
        return SuperwallPlacement._(
            type: PlacementType.deviceAttributes,
            deviceAttributes: json['attributes']);
      case 'entitlementStatusDidChange':
        return SuperwallPlacement._(
            type: PlacementType.entitlementStatusDidChange);
      case 'appClose':
        return SuperwallPlacement._(type: PlacementType.appClose);
      case 'deepLink':
        var url = json['url'] as String?;
        return SuperwallPlacement._(
            type: PlacementType.deepLink, deepLinkUrl: url);
      case 'triggerFire':
        return SuperwallPlacement._(
          type: PlacementType.triggerFire,
          placementName: json['placementName'] as String?,
          result: TriggerResult.fromJson(json['result']),
        );
      case 'paywallOpen':
        return SuperwallPlacement._(
          type: PlacementType.paywallOpen,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallClose':
        return SuperwallPlacement._(
          type: PlacementType.paywallClose,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallDecline':
        return SuperwallPlacement._(
          type: PlacementType.paywallDecline,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionStart':
        return SuperwallPlacement._(
          type: PlacementType.transactionStart,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionFail':
        return SuperwallPlacement._(
          type: PlacementType.transactionFail,
          error: json['error'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionAbandon':
        return SuperwallPlacement._(
          type: PlacementType.transactionAbandon,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionComplete':
        final transactionJson = json['transaction'];

        return SuperwallPlacement._(
            type: PlacementType.transactionComplete,
            transaction: (transactionJson != null)
                ? StoreTransaction.fromJson(transactionJson)
                : null,
            product: StoreProduct.fromJson(json['product']),
            paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']));
      case 'subscriptionStart':
        return SuperwallPlacement._(
          type: PlacementType.subscriptionStart,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'freeTrialStart':
        return SuperwallPlacement._(
          type: PlacementType.freeTrialStart,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionRestore':
        return SuperwallPlacement._(
          type: PlacementType.transactionRestore,
          restoreType: RestoreType.fromJson(json['restoreType']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'transactionTimeout':
        return SuperwallPlacement._(
          type: PlacementType.transactionTimeout,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'userAttributes':
        return SuperwallPlacement._(
            type: PlacementType.userAttributes,
            userAttributes: json['attributes']);
      case 'nonRecurringProductPurchase':
        return SuperwallPlacement._(
          type: PlacementType.nonRecurringProductPurchase,
          product: StoreProduct.fromJson(json['product']),
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallResponseLoadStart':
        return SuperwallPlacement._(
            type: PlacementType.paywallResponseLoadStart,
            triggeredPlacementName: json['triggeredPlacementName']);
      case 'paywallResponseLoadNotFound':
        return SuperwallPlacement._(
            type: PlacementType.paywallResponseLoadNotFound,
            triggeredPlacementName: json['triggeredPlacementName']);
      case 'paywallResponseLoadFail':
        return SuperwallPlacement._(
            type: PlacementType.paywallResponseLoadFail,
            triggeredPlacementName: json['triggeredPlacementName']);
      case 'paywallResponseLoadComplete':
        return SuperwallPlacement._(
          type: PlacementType.paywallResponseLoadComplete,
          triggeredPlacementName: json['triggeredPlacementName'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadStart':
        return SuperwallPlacement._(
          type: PlacementType.paywallWebviewLoadStart,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadFail':
        return SuperwallPlacement._(
          type: PlacementType.paywallWebviewLoadFail,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadComplete':
        return SuperwallPlacement._(
          type: PlacementType.paywallWebviewLoadComplete,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadTimeout':
        return SuperwallPlacement._(
          type: PlacementType.paywallWebviewLoadTimeout,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallWebviewLoadFallback':
        return SuperwallPlacement._(
          type: PlacementType.paywallWebviewLoadFallback,
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallProductsLoadStart':
        return SuperwallPlacement._(
          type: PlacementType.paywallProductsLoadStart,
          triggeredPlacementName: json['triggeredPlacementName'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallProductsLoadFail':
        return SuperwallPlacement._(
          type: PlacementType.paywallProductsLoadFail,
          triggeredPlacementName: json['triggeredPlacementName'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallProductsLoadComplete':
        return SuperwallPlacement._(
          type: PlacementType.paywallProductsLoadComplete,
          triggeredPlacementName: json['triggeredPlacementName'],
        );
      case 'paywallProductsLoadRetry':
        return SuperwallPlacement._(
          type: PlacementType.paywallProductsLoadRetry,
          triggeredPlacementName: json['triggeredPlacementName'],
          attempt: json['attempt'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'surveyResponse':
        return SuperwallPlacement._(
          type: PlacementType.surveyResponse,
          survey: Survey.fromJson(json['survey']),
          selectedOption: SurveyOption.fromJson(json['selectedOption']),
          customResponse: json['customResponse'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'paywallPresentationRequest':
        final statusReasonJson = json['reason'];

        return SuperwallPlacement._(
            type: PlacementType.paywallPresentationRequest,
            status: PaywallPresentationRequestStatus.fromJson(json['status']),
            reason: (statusReasonJson != null)
                ? PaywallPresentationRequestStatusReason.fromJson(
                    statusReasonJson)
                : null);
      case 'touchesBegan':
        return SuperwallPlacement._(type: PlacementType.touchesBegan);
      case 'surveyClose':
        return SuperwallPlacement._(type: PlacementType.surveyClose);
      case 'configRefresh':
        return SuperwallPlacement._(type: PlacementType.configRefresh);
      case 'reset':
        return SuperwallPlacement._(type: PlacementType.reset);
      case 'customPlacement':
        return SuperwallPlacement._(
          type: PlacementType.customPlacement,
          name: json['name'],
          params: json['params'],
          paywallInfo: PaywallInfo(bridgeId: json['paywallInfoBridgeId']),
        );
      case 'configAttributes':
        return SuperwallPlacement._(type: PlacementType.configAttributes);
      case 'confirmAllAssignments':
        return SuperwallPlacement._(type: PlacementType.confirmAllAssignments);
      case 'configFail':
        return SuperwallPlacement._(type: PlacementType.configFail);
      case 'adServicesTokenRequestStart':
        return SuperwallPlacement._(
            type: PlacementType.adServicesTokenRequestStart);
      case 'adServicesTokenRequestFail':
        return SuperwallPlacement._(
            type: PlacementType.adServicesTokenRequestFail,
            error: json['error']);
      case 'adServicesTokenRequestComplete':
        return SuperwallPlacement._(
            type: PlacementType.adServicesTokenRequestComplete,
            token: json['token']);
      case 'shimmerViewStart':
        return SuperwallPlacement._(type: PlacementType.shimmerViewStart);
      case 'shimmerViewComplete':
        return SuperwallPlacement._(type: PlacementType.shimmerViewComplete);
      default:
        throw ArgumentError('Invalid placement type');
    }
  }
}
