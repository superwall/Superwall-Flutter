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

  /// Creates an Experiment from a PExperiment from the pigeon generated code
  static Experiment? fromPigeon(PExperiment? pExperiment) {
    if (pExperiment == null) return null;
    return Experiment(
      id: pExperiment.id,
      groupId: pExperiment.groupId,
    );
  }

  /// Converts this Experiment to a PExperiment for the pigeon generated code
  PExperiment toPigeon() {
    return PExperiment(
      id: id,
      groupId: groupId,
      variant: PVariant(
        id: "", // This is needed for the PExperiment constructor but not used
        type: PVariantType.treatment, // Default value, not used
      ),
    );
  }
}
