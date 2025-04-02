import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// A campaign experiment that was assigned to a user.
///
/// An experiment is part of a [Campaign Rule](https://docs.superwall.com/docs/campaign-rules)
/// defined in the Superwall dashboard. When a rule is matched, the user is
/// assigned to an experiment, which is a set of paywall variants determined
/// by probabilities. An experiment will result in a user seeing a paywall unless
/// they are in a holdout group.
///
/// To learn more, read [our docs](https://docs.superwall.com/docs/home#how-it-work
class Experiment {
  final String id;
  final String groupId;

  Experiment({
    required this.id,
    required this.groupId,
  });

  factory Experiment.fromPExperiment(PExperiment pExperiment) {
    return Experiment(
      id: pExperiment.id,
      groupId: pExperiment.groupId,
    );
  }
}
