import 'package:superwallkit_flutter/src/public/Experiment.dart';

/// The result of a paywall trigger.
///
/// Triggers can conditionally show paywalls. Contains the possible cases resulting from the trigger.
class TriggerResult {
  // TODO
  // final _TriggerResultType _type;
  // final Experiment? experiment; // For paywall and holdout cases
  // final String? errorDetail; // For error case
  //
  // const TriggerResult._(this._type, {this.experiment, this.errorDetail});
  //
  // static const TriggerResult eventNotFound = TriggerResult._(_TriggerResultType.eventNotFound);
  // static const TriggerResult noRuleMatch = TriggerResult._(_TriggerResultType.noRuleMatch);
  // static TriggerResult paywall(Experiment experiment) => TriggerResult._(_TriggerResultType.paywall, experiment: experiment);
  // static TriggerResult holdout(Experiment experiment) => TriggerResult._(_TriggerResultType.holdout, experiment: experiment);
  // static TriggerResult error(String error) => TriggerResult._(_TriggerResultType.error, errorDetail: error);
}

// enum _TriggerResultType {
//   eventNotFound,
//   noRuleMatch,
//   paywall,
//   holdout,
//   error,
// }