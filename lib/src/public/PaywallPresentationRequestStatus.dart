import 'package:superwallkit_flutter/src/public/Experiment.dart';

// TODO
// /// The status of the paywall request
// enum PaywallPresentationRequestStatus {
//   presentation,
//   noPresentation,
//   timeout,
// }
//
// /// The reason to why the paywall couldn't present.
// class PaywallPresentationRequestStatusReason {
//   final PaywallPresentationRequestStatusReasonType type;
//   final Experiment? experiment; // For holdout case
//
//   const PaywallPresentationRequestStatusReason._(this.type, {this.experiment});
//
//   static const PaywallPresentationRequestStatusReason debuggerPresented = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.debuggerPresented);
//   static const PaywallPresentationRequestStatusReason paywallAlreadyPresented = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.paywallAlreadyPresented);
//   static const PaywallPresentationRequestStatusReason userIsSubscribed = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.userIsSubscribed);
//   static PaywallPresentationRequestStatusReason holdout(Experiment experiment) => PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.holdout, experiment: experiment);
//   static const PaywallPresentationRequestStatusReason noRuleMatch = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.noRuleMatch);
//   static const PaywallPresentationRequestStatusReason eventNotFound = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.eventNotFound);
//   static const PaywallPresentationRequestStatusReason noPaywallViewController = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.noPaywallViewController);
//   static const PaywallPresentationRequestStatusReason noPresenter = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.noPresenter);
//   static const PaywallPresentationRequestStatusReason noConfig = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.noConfig);
//   static const PaywallPresentationRequestStatusReason subscriptionStatusTimeout = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.subscriptionStatusTimeout);
// }
//
// enum PaywallPresentationRequestStatusReasonType {
//   debuggerPresented,
//   paywallAlreadyPresented,
//   userIsSubscribed,
//   holdout,
//   noRuleMatch,
//   eventNotFound,
//   noPaywallViewController,
//   noPresenter,
//   noConfig,
//   subscriptionStatusTimeout,
// }