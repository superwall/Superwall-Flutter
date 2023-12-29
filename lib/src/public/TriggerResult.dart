import 'package:superwallkit_flutter/src/public/Experiment.dart';

/// The result of a paywall trigger.
///
/// Triggers can conditionally show paywalls. Contains the possible cases resulting from the trigger.
class TriggerResult {
  final _TriggerResultType _type;
  final Experiment? experiment; // For paywall and holdout cases
  final String? errorDetail; // For error case

  const TriggerResult._(this._type, {this.experiment, this.errorDetail});

  static const TriggerResult eventNotFound = TriggerResult._(_TriggerResultType.eventNotFound);
  static const TriggerResult noRuleMatch = TriggerResult._(_TriggerResultType.noRuleMatch);
  static TriggerResult paywall(Experiment experiment) => TriggerResult._(_TriggerResultType.paywall, experiment: experiment);
  static TriggerResult holdout(Experiment experiment) => TriggerResult._(_TriggerResultType.holdout, experiment: experiment);
  static TriggerResult error(String error) => TriggerResult._(_TriggerResultType.error, errorDetail: error);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> dataMap = {};
    if (experiment != null) dataMap['experiment'] = experiment?.toJson();
    if (errorDetail != null) dataMap['error'] = errorDetail;

    return {
      'type': _type.toJson(),
      'data': dataMap.isNotEmpty ? dataMap : null,
    };
  }
}

enum _TriggerResultType {
  eventNotFound,
  noRuleMatch,
  paywall,
  holdout,
  error,
}

extension _TriggerResultTypeExtension on _TriggerResultType {
  String toJson() {
    switch (this) {
      case _TriggerResultType.eventNotFound:
        return 'eventNotFound';
      case _TriggerResultType.noRuleMatch:
        return 'noRuleMatch';
      case _TriggerResultType.paywall:
        return 'paywall';
      case _TriggerResultType.holdout:
        return 'holdout';
      case _TriggerResultType.error:
        return 'error';
      default:
        throw ArgumentError('Invalid _TriggerResultType value');
    }
  }
}
