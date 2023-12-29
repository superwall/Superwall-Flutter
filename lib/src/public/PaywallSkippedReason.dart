import 'package:superwallkit_flutter/src/public/Experiment.dart';

/// The reason the paywall presentation was skipped.
class PaywallSkippedReason {
  final _PaywallSkippedReasonType _type;
  final Experiment? experiment;

  const PaywallSkippedReason._private(this._type, {this.experiment});

  static PaywallSkippedReason holdout(Experiment experiment) => PaywallSkippedReason._private(_PaywallSkippedReasonType.holdout, experiment: experiment);
  static const PaywallSkippedReason noRuleMatch = PaywallSkippedReason._private(_PaywallSkippedReasonType.noRuleMatch);
  static const PaywallSkippedReason eventNotFound = PaywallSkippedReason._private(_PaywallSkippedReasonType.eventNotFound);
  static const PaywallSkippedReason userIsSubscribed = PaywallSkippedReason._private(_PaywallSkippedReasonType.userIsSubscribed);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {'type': _type.toString()};
    if (_type == _PaywallSkippedReasonType.holdout) {
      data['experiment'] = experiment?.toJson();
    }
    return data;
  }

  static PaywallSkippedReason fromJson(Map<dynamic, dynamic> json) {
    final typeStr = json['type'] as String;
    switch (typeStr) {
      case 'holdout':
        final experimentJson = json['experiment'] as Map<String, dynamic>?;
        if (experimentJson != null) {
          final experiment = Experiment.fromJson(experimentJson);
          return PaywallSkippedReason.holdout(experiment);
        }
        throw const FormatException('Experiment data missing for holdout type');

      case 'noRuleMatch':
        return PaywallSkippedReason.noRuleMatch;

      case 'eventNotFound':
        return PaywallSkippedReason.eventNotFound;

      case 'userIsSubscribed':
        return PaywallSkippedReason.userIsSubscribed;

      default:
        throw const FormatException('Unknown PaywallSkippedReason type');
    }
  }
}

enum _PaywallSkippedReasonType {
  holdout,
  noRuleMatch,
  eventNotFound,
  userIsSubscribed
}
