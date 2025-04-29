import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
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

  factory PaywallPresentationRequestStatusReason.fromPPaywallPresentationRequestStatusReason(
      PPaywallPresentationRequestStatusReason reason) {
    switch (reason) {
      case PPaywallPresentationRequestStatusReason.debuggerPresented:
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.debuggerPresented);
      case PPaywallPresentationRequestStatusReason.paywallAlreadyPresented:
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType
                .paywallAlreadyPresented);
      case PPaywallPresentationRequestStatusReason.holdout:
        return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.holdout,
          //TODO: Add experiment here
        );
      case PPaywallPresentationRequestStatusReason.noAudienceMatch:
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.noAudienceMatch);
      case PPaywallPresentationRequestStatusReason.placementNotFound:
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.placementNotFound);
      case PPaywallPresentationRequestStatusReason.noPaywallViewController:
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType
                .noPaywallViewController);
      case PPaywallPresentationRequestStatusReason.noPresenter:
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.noPresenter);
      case PPaywallPresentationRequestStatusReason.noConfig:
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType.noConfig);
      case PPaywallPresentationRequestStatusReason.subscriptionStatusTimeout:
        return PaywallPresentationRequestStatusReason._(
            type: PaywallPresentationRequestStatusReasonType
                .subscriptionStatusTimeout);
      default:
        throw ArgumentError(
            'Invalid PPaywallPresentationRequestStatusReason type');
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
  subscriptionStatusTimeout
}
