import 'package:superwallkit_flutter/src/public/Experiment.dart';

/// The status of the paywall request
enum PaywallPresentationRequestStatus {
  presentation,
  noPresentation,
  timeout,
}

extension PaywallPresentationRequestStatusExtension on PaywallPresentationRequestStatus {
  String toJson() {
    switch (this) {
      case PaywallPresentationRequestStatus.presentation:
        return 'presentation';
      case PaywallPresentationRequestStatus.noPresentation:
        return 'no_presentation';
      case PaywallPresentationRequestStatus.timeout:
        return 'timeout';
      default:
        throw ArgumentError('Invalid PaywallPresentationRequestStatus value');
    }
  }

  static PaywallPresentationRequestStatus fromJson(String json) {
    switch (json) {
      case 'presentation':
        return PaywallPresentationRequestStatus.presentation;
      case 'no_presentation':
        return PaywallPresentationRequestStatus.noPresentation;
      case 'timeout':
        return PaywallPresentationRequestStatus.timeout;
      default:
        throw ArgumentError('Invalid PaywallPresentationRequestStatus value: $json');
    }
  }
}

/// The reason to why the paywall couldn't present.
class PaywallPresentationRequestStatusReason {
  final PaywallPresentationRequestStatusReasonType type;
  final Experiment? experiment; // For holdout case

  const PaywallPresentationRequestStatusReason._(this.type, {this.experiment});

  static const PaywallPresentationRequestStatusReason debuggerPresented = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.debuggerPresented);
  static const PaywallPresentationRequestStatusReason paywallAlreadyPresented = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.paywallAlreadyPresented);
  static const PaywallPresentationRequestStatusReason userIsSubscribed = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.userIsSubscribed);
  static PaywallPresentationRequestStatusReason holdout(Experiment experiment) => PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.holdout, experiment: experiment);
  static const PaywallPresentationRequestStatusReason noRuleMatch = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.noRuleMatch);
  static const PaywallPresentationRequestStatusReason eventNotFound = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.eventNotFound);
  static const PaywallPresentationRequestStatusReason noPaywallViewController = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.noPaywallViewController);
  static const PaywallPresentationRequestStatusReason noPresenter = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.noPresenter);
  static const PaywallPresentationRequestStatusReason noConfig = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.noConfig);
  static const PaywallPresentationRequestStatusReason subscriptionStatusTimeout = PaywallPresentationRequestStatusReason._(PaywallPresentationRequestStatusReasonType.subscriptionStatusTimeout);

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'experiment': experiment?.toJson(), // null for other cases
    };
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
  subscriptionStatusTimeout,
}

extension PaywallPresentationRequestStatusReasonTypeExtension on PaywallPresentationRequestStatusReasonType {
  String toJson() {
    switch (this) {
      case PaywallPresentationRequestStatusReasonType.debuggerPresented:
        return 'debuggerPresented';
      case PaywallPresentationRequestStatusReasonType.paywallAlreadyPresented:
        return 'paywallAlreadyPresented';
      case PaywallPresentationRequestStatusReasonType.userIsSubscribed:
        return 'userIsSubscribed';
      case PaywallPresentationRequestStatusReasonType.holdout:
        return 'holdout';
      case PaywallPresentationRequestStatusReasonType.noRuleMatch:
        return 'noRuleMatch';
      case PaywallPresentationRequestStatusReasonType.eventNotFound:
        return 'eventNotFound';
      case PaywallPresentationRequestStatusReasonType.noPaywallViewController:
        return 'noPaywallViewController';
      case PaywallPresentationRequestStatusReasonType.noPresenter:
        return 'noPresenter';
      case PaywallPresentationRequestStatusReasonType.noConfig:
        return 'noConfig';
      case PaywallPresentationRequestStatusReasonType.subscriptionStatusTimeout:
        return 'subscriptionStatusTimeout';
      default:
        throw ArgumentError('Invalid PaywallPresentationRequestStatusReasonType value');
    }
  }
}