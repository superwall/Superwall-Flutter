import 'package:superwallkit_flutter/src/public/Variant.dart';

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
  /// The id of the experiment.
  final String id;

  /// The id of the experiment group.
  final String groupId;

  /// Information about the experiment variant.
  final Variant variant;

  Experiment({
    required this.id,
    required this.groupId,
    required this.variant,
  });

  factory Experiment.fromJson(Map<dynamic, dynamic> json) => Experiment(
    id: json['id'],
    groupId: json['groupId'],
    variant: Variant.fromJson(json['variant']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'groupId': groupId,
    'variant': variant.toJson(),
  };
}