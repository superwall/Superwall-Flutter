import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// An enum representing the subscription status of the user.
sealed class SubscriptionStatus {
  SubscriptionStatus();
  static final SubscriptionStatus inactive = SubscriptionStatusInactive();
  static final SubscriptionStatus unknown = SubscriptionStatusUnknown();

  static SubscriptionStatus createSubscriptionStatusFromPSubscriptionStatus(
      PSubscriptionStatus pSubscriptionStatus) {
    switch (pSubscriptionStatus) {
      case PActive():
        return SubscriptionStatusActive(
            entitlements: pSubscriptionStatus.entitlements
                .map((e) => Entitlement(id: e.id!))
                .toSet());
      case PInactive():
        return SubscriptionStatusInactive();
      case PUnknown():
        return SubscriptionStatusUnknown();
    }
  }

  PSubscriptionStatus toPSubscriptionStatus() {
    switch (this) {
      case SubscriptionStatusInactive():
        return PInactive();
      case SubscriptionStatusUnknown():
        return PUnknown();
      case SubscriptionStatusActive():
        return PActive(
            entitlements: (this as SubscriptionStatusActive)
                .entitlements
                .map((e) => PEntitlement(id: e.id))
                .toSet()
                .toList());
    }
  }
}

class SubscriptionStatusActive extends SubscriptionStatus {
  final Set<Entitlement> entitlements;

  SubscriptionStatusActive({required this.entitlements});
}

class SubscriptionStatusInactive extends SubscriptionStatus {
  SubscriptionStatusInactive();
}

class SubscriptionStatusUnknown extends SubscriptionStatus {
  SubscriptionStatusUnknown();
}
