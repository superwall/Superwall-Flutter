import '../generated/superwallhost.g.dart';
import 'Experiment.dart';

/// The reason the paywall presentation was skipped.
sealed class PaywallSkippedReason {
  const PaywallSkippedReason();

  /// [experiment] is the experiment of a [PPaywallSkippedReason.holdout].
  static PaywallSkippedReason? fromPigeon(PPaywallSkippedReason reason,
      [PExperiment? experiment]) {
    switch (reason) {
      case PPaywallSkippedReason.holdout:
        return PaywallSkippedReasonHoldout(Experiment.fromPigeon(experiment));
      case PPaywallSkippedReason.noAudienceMatch:
        return const PaywallSkippedReasonNoAudienceMatch();
      case PPaywallSkippedReason.placementNotFound:
        return const PaywallSkippedReasonPlacementNotFound();
      case PPaywallSkippedReason.userIsSubscribed:
        return const PaywallSkippedReasonUserIsSubscribed();
      default:
        return null;
    }
  }
}

/// The user was assigned to a holdout.
///
/// A holdout is a control group which you can analyse against
/// who don't receive any paywall when they match a rule.
///
/// It's useful for testing a paywall's inclusion vs its exclusion.
class PaywallSkippedReasonHoldout extends PaywallSkippedReason {
  /// The experiment the user is in a holdout of, when the native SDK
  /// provides it.
  final Experiment? experiment;

  const PaywallSkippedReasonHoldout([this.experiment]);
}

/// No rule was matched for this placement.
class PaywallSkippedReasonNoAudienceMatch extends PaywallSkippedReason {
  const PaywallSkippedReasonNoAudienceMatch();
}

/// This placement was not found on the dashboard.
///
/// Please make sure you have added the placement to a campaign on the dashboard and
/// double check its spelling.
class PaywallSkippedReasonPlacementNotFound extends PaywallSkippedReason {
  const PaywallSkippedReasonPlacementNotFound();
}

/// The user is already subscribed.
///
/// Android only.
class PaywallSkippedReasonUserIsSubscribed extends PaywallSkippedReason {
  const PaywallSkippedReasonUserIsSubscribed();
}
