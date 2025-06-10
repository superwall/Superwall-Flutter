import 'package:superwallkit_flutter/src/public/Experiment.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The result of presenting a paywall.
///
/// Contains the possible cases resulting from a paywall presentation attempt.
sealed class PresentationResult {
  PresentationResult._();

  /// Creates a PresentationResult from a PPresentationResult from the pigeon generated code
  static PresentationResult fromPigeon(PPresentationResult pResult) {
    if (pResult is PPlacementNotFoundPresentationResult) {
      return PresentationResult.placementNotFound();
    } else if (pResult is PNoAudienceMatchPresentationResult) {
      return PresentationResult.noAudienceMatch();
    } else if (pResult is PPaywallPresentationResult) {
      return PresentationResult.paywall(
        Experiment(
          id: pResult.experiment.id,
          groupId: pResult.experiment.groupId,
        ),
      );
    } else if (pResult is PHoldoutPresentationResult) {
      return PresentationResult.holdout(
        Experiment(
          id: pResult.experiment.id,
          groupId: pResult.experiment.groupId,
        ),
      );
    } else if (pResult is PPaywallNotAvailablePresentationResult) {
      return PresentationResult.paywallNotAvailable();
    } else {
      throw ArgumentError('Invalid PPresentationResult type');
    }
  }

  factory PresentationResult.placementNotFound() =
      PlacementNotFoundPresentationResult;
  factory PresentationResult.noAudienceMatch() =
      NoAudienceMatchPresentationResult;
  factory PresentationResult.paywall(Experiment experiment) =
      PaywallPresentationResult;
  factory PresentationResult.holdout(Experiment experiment) =
      HoldoutPresentationResult;
  factory PresentationResult.paywallNotAvailable() =
      PaywallNotAvailablePresentationResult;
}

/// Presentation result when the placement was not found.
class PlacementNotFoundPresentationResult extends PresentationResult {
  PlacementNotFoundPresentationResult() : super._();
}

/// Presentation result when there was no audience match.
class NoAudienceMatchPresentationResult extends PresentationResult {
  NoAudienceMatchPresentationResult() : super._();
}

/// Presentation result when a paywall was presented.
class PaywallPresentationResult extends PresentationResult {
  final Experiment experiment;

  PaywallPresentationResult(this.experiment) : super._();
}

/// Presentation result when the user was in a holdout group.
class HoldoutPresentationResult extends PresentationResult {
  final Experiment experiment;

  HoldoutPresentationResult(this.experiment) : super._();
}

/// Presentation result when the paywall was not available.
class PaywallNotAvailablePresentationResult extends PresentationResult {
  PaywallNotAvailablePresentationResult() : super._();
}
