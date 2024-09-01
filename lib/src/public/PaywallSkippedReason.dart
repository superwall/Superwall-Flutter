import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/Experiment.dart';

/// The reason the paywall presentation was skipped.
abstract class PaywallSkippedReason extends BridgeIdInstantiable {
  PaywallSkippedReason({required super.bridgeClass, super.bridgeId});

  static PaywallSkippedReason? createReasonFromBridgeId(BridgeId bridgeId) {
    switch (bridgeId.bridgeClass) {
      case PaywallSkippedReasonHoldout.bridgeClass:
        return PaywallSkippedReasonHoldout(bridgeId: bridgeId);
      case PaywallSkippedReasonNoRuleMatch.bridgeClass:
        return PaywallSkippedReasonNoRuleMatch(bridgeId: bridgeId);
      case PaywallSkippedReasonEventNotFound.bridgeClass:
        return PaywallSkippedReasonEventNotFound(bridgeId: bridgeId);
      case PaywallSkippedReasonUserIsSubscribed.bridgeClass:
        return PaywallSkippedReasonUserIsSubscribed(bridgeId: bridgeId);
      default:
        return null;
    }
  }

  Future<String> get description async {
    final description = await bridgeId.communicator.invokeBridgeMethod('getDescription');
    return description;
  }
}

/// The user was assigned to a holdout.
///
/// A holdout is a control group which you can analyse against
/// who don't receive any paywall when they match a rule.
///
/// It's useful for testing a paywall's inclusing vs its exclusion.
class PaywallSkippedReasonHoldout extends PaywallSkippedReason {
  static const BridgeClass bridgeClass = 'PaywallSkippedReasonHoldoutBridge';
  PaywallSkippedReasonHoldout({super.bridgeId}): super(bridgeClass: bridgeClass);

  Future<Experiment> get experiment async {
    BridgeId experimentBridgeId = await bridgeId.communicator.invokeBridgeMethod('getExperimentBridgeId');
    Experiment experiment = Experiment(bridgeId: experimentBridgeId);
    return experiment;
  }
}

/// No rule was matched for this event.
class PaywallSkippedReasonNoRuleMatch extends PaywallSkippedReason {
  static const BridgeClass bridgeClass = 'PaywallSkippedReasonNoRuleMatchBridge';
  PaywallSkippedReasonNoRuleMatch({super.bridgeId}): super(bridgeClass: bridgeClass);
}

/// This event was not found on the dashboard.
///
/// Please make sure you have added the event to a campaign on the dashboard and
/// double check its spelling.
class PaywallSkippedReasonEventNotFound extends PaywallSkippedReason {
  static const BridgeClass bridgeClass = 'PaywallSkippedReasonEventNotFoundBridge';
  PaywallSkippedReasonEventNotFound({ super.bridgeId }): super(bridgeClass: bridgeClass);
}

/// The user is subscribed.
///
/// This means ``Superwall/subscriptionStatus`` is set to `.active`. If you're
/// letting Superwall handle subscription-related logic, it will be based on the on-device
/// receipts. Otherwise it'll be based on the value you've set.
///
/// By default, paywalls do not show to users who are already subscribed. You can override this
/// behavior in the paywall editor.
class PaywallSkippedReasonUserIsSubscribed extends PaywallSkippedReason {
  static const BridgeClass bridgeClass = 'PaywallSkippedReasonUserIsSubscribedBridge';
  PaywallSkippedReasonUserIsSubscribed({ super.bridgeId }) : super(bridgeClass: bridgeClass);
}