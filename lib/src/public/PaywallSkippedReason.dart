import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/Experiment.dart';

/// The reason the paywall presentation was skipped.
abstract class PaywallSkippedReason extends BridgeIdInstantiable {
  PaywallSkippedReason({required super.bridgeClass, super.bridgeId});

  static PaywallSkippedReason? createReasonFromBridgeId(BridgeId bridgeId) {
    switch (bridgeId.bridgeClass) {
      case PaywallSkippedReasonHoldout.bridgeClass:
        return PaywallSkippedReasonHoldout(bridgeId: bridgeId);
      case PaywallSkippedReasonNoAudienceMatch.bridgeClass:
        return PaywallSkippedReasonNoAudienceMatch(bridgeId: bridgeId);
      case PaywallSkippedReasonPlacementNotFound.bridgeClass:
        return PaywallSkippedReasonPlacementNotFound(bridgeId: bridgeId);
      default:
        return null;
    }
  }

  Future<String> get description async {
    final description =
        await bridgeId.communicator.invokeBridgeMethod('getDescription');
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
  PaywallSkippedReasonHoldout({super.bridgeId})
      : super(bridgeClass: bridgeClass);

  Future<Experiment> get experiment async {
    BridgeId experimentBridgeId =
        await bridgeId.communicator.invokeBridgeMethod('getExperimentBridgeId');
    Experiment experiment = Experiment(bridgeId: experimentBridgeId);
    return experiment;
  }
}

/// No rule was matched for this placement.
class PaywallSkippedReasonNoAudienceMatch extends PaywallSkippedReason {
  static const BridgeClass bridgeClass =
      'PaywallSkippedReasonNoAudienceMatchBridge';
  PaywallSkippedReasonNoAudienceMatch({super.bridgeId})
      : super(bridgeClass: bridgeClass);
}

/// This placement was not found on the dashboard.
///
/// Please make sure you have added the placement to a campaign on the dashboard and
/// double check its spelling.
class PaywallSkippedReasonPlacementNotFound extends PaywallSkippedReason {
  static const BridgeClass bridgeClass =
      'PaywallSkippedReasonPlacementNotFoundBridge';
  PaywallSkippedReasonPlacementNotFound({super.bridgeId})
      : super(bridgeClass: bridgeClass);
}
