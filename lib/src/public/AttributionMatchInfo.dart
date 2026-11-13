import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The result of matching an install to the ad click that led to it, carried
/// by the `attributionMatch` event.
class AttributionMatchInfo {
  /// The provider that made the match, such as `mmp` or `apple_search_ads`.
  final String provider;

  /// Whether the install was matched to an ad click.
  final bool matched;

  /// The source the install was attributed to, if there is one.
  final String? source;

  /// How confident the match is: `high`, `medium` or `low`.
  final String? confidence;

  /// The score of the match, if there is one.
  final double? matchScore;

  /// Why the install was or wasn't matched, if a reason was given.
  final String? reason;

  AttributionMatchInfo({
    required this.provider,
    required this.matched,
    this.source,
    this.confidence,
    this.matchScore,
    this.reason,
  });

  factory AttributionMatchInfo.fromPigeon(PAttributionMatchInfo pigeon) {
    return AttributionMatchInfo(
      provider: pigeon.provider,
      matched: pigeon.matched,
      source: pigeon.source,
      confidence: pigeon.confidence,
      matchScore: pigeon.matchScore,
      reason: pigeon.reason,
    );
  }
}
