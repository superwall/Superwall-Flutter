import '../generated/superwallhost.g.dart';

/// The reason the paywall presentation was skipped.
sealed class PaywallSkippedReason {
  const PaywallSkippedReason();

  static PaywallSkippedReason? fromPPaywallSkippedReason(
      PPaywallSkippedReason reason) {
    switch (reason) {
      case PPaywallSkippedReason.holdout:
        return const PaywallSkippedReasonHoldout();
      case PPaywallSkippedReason.noAudienceMatch:
        return const PaywallSkippedReasonNoAudienceMatch();
      case PPaywallSkippedReason.placementNotFound:
        return const PaywallSkippedReasonPlacementNotFound();
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
  const PaywallSkippedReasonHoldout();
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
