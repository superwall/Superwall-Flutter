import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// The status of the paywall request
class PaywallPresentationRequestStatus {
  final PaywallPresentationRequestStatusType type;

  PaywallPresentationRequestStatus._(this.type);

  factory PaywallPresentationRequestStatus.fromPigeon(
      PPaywallPresentationRequestStatusType status) {
    switch (status) {
      case PPaywallPresentationRequestStatusType.timeout:
        return PaywallPresentationRequestStatus._(
            PaywallPresentationRequestStatusType.timeout);
      case PPaywallPresentationRequestStatusType.presentation:
        return PaywallPresentationRequestStatus._(
            PaywallPresentationRequestStatusType.presentation);
      case PPaywallPresentationRequestStatusType.noPresentation:
        return PaywallPresentationRequestStatus._(
            PaywallPresentationRequestStatusType.noPresentation);
    }
  }
}

enum PaywallPresentationRequestStatusType {
  presentation,
  noPresentation,
  timeout,
}

/// The reason to why the paywall couldn't present.
class PaywallPresentationRequestStatusReason {
  final PaywallPresentationRequestStatusReasonType type;
  final Experiment? experiment;

  PaywallPresentationRequestStatusReason._(
      {required this.type, this.experiment});

  factory PaywallPresentationRequestStatusReason.fromPigeon(
      PPaywallPresentationRequestStatusReason reason) {
    if (reason is PStatusReasonDebuggerPresented) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.debuggerPresented);
    } else if (reason is PStatusReasonPaywallAlreadyPresented) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType
              .paywallAlreadyPresented);
    } else if (reason is PStatusReasonHoldout) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.holdout,
          experiment: Experiment.fromPigeon(reason.experiment));
    } else if (reason is PStatusReasonNoAudienceMatch) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.noAudienceMatch);
    } else if (reason is PStatusReasonPlacementNotFound) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.placementNotFound);
    } else if (reason is PStatusReasonNoPaywallVc) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType
              .noPaywallViewController);
    } else if (reason is PStatusReasonNoPresenter) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.noPresenter);
    } else if (reason is PStatusReasonNoConfig) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType.noConfig);
    } else if (reason is PStatusReasonSubsStatusTimeout) {
      return PaywallPresentationRequestStatusReason._(
          type: PaywallPresentationRequestStatusReasonType
              .subscriptionStatusTimeout);
    } else {
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
