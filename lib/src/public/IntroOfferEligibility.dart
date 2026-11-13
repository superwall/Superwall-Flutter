import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// How intro offer eligibility is decided for a paywall.
///
/// iOS only.
enum IntroOfferEligibility {
  /// The paywall always treats the user as eligible for an intro offer.
  eligible,

  /// The paywall always treats the user as ineligible for an intro offer.
  ineligible,

  /// Eligibility is worked out from the user's purchase history.
  automatic;

  static IntroOfferEligibility fromPigeon(PIntroOfferEligibility pigeon) {
    switch (pigeon) {
      case PIntroOfferEligibility.eligible:
        return IntroOfferEligibility.eligible;
      case PIntroOfferEligibility.ineligible:
        return IntroOfferEligibility.ineligible;
      case PIntroOfferEligibility.automatic:
        return IntroOfferEligibility.automatic;
    }
  }

  PIntroOfferEligibility toPigeon() {
    switch (this) {
      case IntroOfferEligibility.eligible:
        return PIntroOfferEligibility.eligible;
      case IntroOfferEligibility.ineligible:
        return PIntroOfferEligibility.ineligible;
      case IntroOfferEligibility.automatic:
        return PIntroOfferEligibility.automatic;
    }
  }
}
