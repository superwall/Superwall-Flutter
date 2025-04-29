import 'package:superwallkit_flutter/src/public/Experiment.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The result of a paywall trigger.
///
/// Triggers can conditionally show paywalls. Contains the possible cases resulting from the trigger.
class TriggerResult {
  final TriggerResultType type;
  final Experiment? experiment;
  final String? error;

  TriggerResult._({required this.type, this.experiment, this.error});

  factory TriggerResult.placementNotFound() =>
      TriggerResult._(type: TriggerResultType.placementNotFound);
  factory TriggerResult.noAudienceMatch() =>
      TriggerResult._(type: TriggerResultType.noAudienceMatch);
  factory TriggerResult.paywall(Experiment experiment) =>
      TriggerResult._(type: TriggerResultType.paywall, experiment: experiment);
  factory TriggerResult.holdout(Experiment experiment) =>
      TriggerResult._(type: TriggerResultType.holdout, experiment: experiment);
  factory TriggerResult.error(String error) =>
      TriggerResult._(type: TriggerResultType.error, error: error);

  factory TriggerResult.fromPTriggerResult(PTriggerResult result) {
    if (result is PPlacementNotFoundTriggerResult) {
      return TriggerResult.placementNotFound();
    } else if (result is PNoAudienceMatchTriggerResult) {
      return TriggerResult.noAudienceMatch();
    } else if (result is PPaywallTriggerResult) {
      return TriggerResult.paywall(
        Experiment(
          id: result.experiment.id,
          groupId: result.experiment.groupId,
        ),
      );
    } else if (result is PHoldoutTriggerResult) {
      return TriggerResult.holdout(
        Experiment(
          id: result.experiment.id,
          groupId: result.experiment.groupId,
        ),
      );
    } else if (result is PErrorTriggerResult) {
      return TriggerResult.error(result.error);
    } else {
      throw ArgumentError('Invalid PTriggerResult type');
    }
  }
}

enum TriggerResultType {
  placementNotFound,
  noAudienceMatch,
  paywall,
  holdout,
  error
}
