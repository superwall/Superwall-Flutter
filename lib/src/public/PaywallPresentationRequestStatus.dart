import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// The status of the paywall request
class PaywallPresentationRequestStatus {
  final PaywallPresentationRequestStatusType type;

  PaywallPresentationRequestStatus._(this.type);

  factory PaywallPresentationRequestStatus.fromJson(Map<String, dynamic> json) {
    switch (json['status']) {
      case 'presentation':
        return PaywallPresentationRequestStatus._(PaywallPresentationRequestStatusType.presentation);
      case 'noPresentation':
        return PaywallPresentationRequestStatus._(PaywallPresentationRequestStatusType.noPresentation);
      case 'timeout':
        return PaywallPresentationRequestStatus._(PaywallPresentationRequestStatusType.timeout);
      default:
        throw ArgumentError('Invalid PaywallPresentationRequestStatus type');
    }
  }
}

enum PaywallPresentationRequestStatusType { presentation, noPresentation, timeout }

/// The reason to why the paywall couldn't present.
class PaywallPresentationRequestStatusReason {
  final PaywallPresentationRequestStatusReasonType type;
  final Experiment? experiment;

  PaywallPresentationRequestStatusReason._({required this.type, this.experiment});

  factory PaywallPresentationRequestStatusReason.fromJson(Map<String, dynamic> json) {
    switch (json['reason']) {
      case 'debuggerPresented':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.debuggerPresented);
      case 'paywallAlreadyPresented':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.paywallAlreadyPresented);
      case 'userIsSubscribed':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.userIsSubscribed);
      case 'holdout':
        return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.holdout,
          experiment: Experiment(bridgeId: json['experimentBridgeId']),
        );
      case 'noRuleMatch':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.noRuleMatch);
      case 'eventNotFound':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.eventNotFound);
      case 'noPaywallViewController':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.noPaywallViewController);
      case 'noPresenter':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.noPresenter);
      case 'noConfig':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.noConfig);
      case 'subscriptionStatusTimeout':
        return PaywallPresentationRequestStatusReason._(type: PaywallPresentationRequestStatusReasonType.subscriptionStatusTimeout);
      default:
        throw ArgumentError('Invalid PaywallPresentationRequestStatusReason type');
    }
  }
}

enum PaywallPresentationRequestStatusReasonType {
  debuggerPresented,
  paywallAlreadyPresented,
  userIsSubscribed,
  holdout,
  noRuleMatch,
  eventNotFound,
  noPaywallViewController,
  noPresenter,
  noConfig,
  subscriptionStatusTimeout
}