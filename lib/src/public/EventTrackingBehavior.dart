import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// Which events the SDK sends to Superwall's servers.
///
/// Set it when configuring via `SuperwallOptions.eventTrackingBehavior`, or
/// at runtime via `Superwall.shared.setEventTrackingBehavior()`.
enum EventTrackingBehavior {
  /// All events are tracked. This is the default.
  all,

  /// Only the events Superwall needs to work are tracked. Events and
  /// properties that Superwall doesn't track itself, such as your own
  /// placements and user attributes, aren't sent.
  superwallOnly,

  /// No events are tracked.
  none;

  static EventTrackingBehavior fromPigeon(PEventTrackingBehavior pigeon) {
    switch (pigeon) {
      case PEventTrackingBehavior.all:
        return EventTrackingBehavior.all;
      case PEventTrackingBehavior.superwallOnly:
        return EventTrackingBehavior.superwallOnly;
      case PEventTrackingBehavior.none:
        return EventTrackingBehavior.none;
    }
  }

  PEventTrackingBehavior toPigeon() {
    switch (this) {
      case EventTrackingBehavior.all:
        return PEventTrackingBehavior.all;
      case EventTrackingBehavior.superwallOnly:
        return PEventTrackingBehavior.superwallOnly;
      case EventTrackingBehavior.none:
        return PEventTrackingBehavior.none;
    }
  }
}

extension EventTrackingBehaviorJson on EventTrackingBehavior {
  String toJson() {
    switch (this) {
      case EventTrackingBehavior.all:
        return 'all';
      case EventTrackingBehavior.superwallOnly:
        return 'superwallOnly';
      case EventTrackingBehavior.none:
        return 'none';
    }
  }
}
