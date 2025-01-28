import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// The status of the paywall request
class PaywallPresentationRequestStatus {
  final PaywallPresentationRequestStatusType type;

  PaywallPresentationRequestStatus._(this.type);

  factory PaywallPresentationRequestStatus.fromJson(
      Map<dynamic, dynamic> json) {
    switch (json['status']) {
      case 'presentation':
        return PaywallPresentationRequestStatus._(
            PaywallPresentationRequestStatusType.presentation);
      case 'noPresentation':
        return PaywallPresentationRequestStatus._(
            PaywallPresentationRequestStatusType.noPresentation);
      case 'timeout':
        return PaywallPresentationRequestStatus._(
            PaywallPresentationRequestStatusType.timeout);
      default:
        throw ArgumentError('Invalid PaywallPresentationRequestStatus type');
    }
  }
}

enum PaywallPresentationRequestStatusType {
  presentation,
  noPresentation,
  timeout
}

/// The reason to why the paywall couldn't present.
class PaywallPresentationRequestStatusReason {
  final PaywallPresentationRequestStatusReasonType type;
  final Experiment? experiment;

  PaywallPresentationRequestStatusReason._(
      {required this.type, this.experiment});

  factory PaywallPresentationRequestStatusReason.fromJson(
      Map<dynamic, dynamic> json) {
    switch (json['reason']) {
      case 'debuggerPresented':
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.debuggerPresented);
      case 'paywallAlreadyPresented':
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType
                .paywallAlreadyPresented);
      case 'holdout':
        return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.holdout,
          experiment: Experiment(bridgeId: json['experimentBridgeId']),
        );
      case 'noAudienceMatch':
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.noAudienceMatch);
      case 'placementNotFound':
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.placementNotFound);
      case 'noPaywallViewController':
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType
                .noPaywallViewController);
      case 'noPresenter':
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.noPresenter);
      case 'noConfig':
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.noConfig);
      case 'entitlementsTimeout':
        return PaywallPresentationRequestStatusReason._(
            type:
                PaywallPresentationRequestStatusReasonType.entitlementsTimeout);
      default:
        throw ArgumentError(
            'Invalid PaywallPresentationRequestStatusReason type');
    }
  }
}

enum PaywallPresentationRequestStatusReasonType {
  debuggerPresented,
  paywallAlreadyPresented,
  holdout,
  noAudienceMatch,
  placementNotFound,
  noPaywallViewController,
  noPresenter,
  noConfig,
  entitlementsTimeout
}
