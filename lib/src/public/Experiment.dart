import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// A campaign experiment that was assigned to a user.
///
/// An experiment is part of a [Campaign Rule](https://docs.superwall.com/docs/campaign-rules)
/// defined in the Superwall dashboard. When a rule is matched, the user is
/// assigned to an experiment, which is a set of paywall variants determined
/// by probabilities. An experiment will result in a user seeing a paywall unless
/// they are in a holdout group.
///
/// To learn more, read [our docs](https://docs.superwall.com/docs/home#how-it-work
class Experiment extends BridgeIdInstantiable {
  static const BridgeClass bridgeClass = 'ExperimentBridge';
  Experiment({super.bridgeId}): super(bridgeClass: bridgeClass);

  Future<String> get id async {
    final id = await bridgeId.communicator.invokeBridgeMethod('getId');
    return id;
  }

  Future<String> get description async {
    final description = await bridgeId.communicator.invokeBridgeMethod('getDescription');
    return description;
  }
}