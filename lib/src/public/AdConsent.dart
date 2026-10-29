import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// Whether a user has granted or denied consent for an advertising purpose.
enum AdConsentStatus {
  /// The user has granted consent. This is the default.
  granted,

  /// The user has denied consent.
  denied;

  PAdConsentStatus toPigeon() {
    switch (this) {
      case AdConsentStatus.granted:
        return PAdConsentStatus.granted;
      case AdConsentStatus.denied:
        return PAdConsentStatus.denied;
    }
  }

  static AdConsentStatus fromPigeon(PAdConsentStatus status) {
    switch (status) {
      case PAdConsentStatus.granted:
        return AdConsentStatus.granted;
      case PAdConsentStatus.denied:
        return AdConsentStatus.denied;
    }
  }
}

/// A user's consent for how their data is used for advertising.
///
/// Superwall passes this on with the conversions it uploads to Google Ads and
/// Meta. Both values default to [AdConsentStatus.granted].
///
/// Set it with [SuperwallOptions.adConsent] or `Superwall.shared.setAdConsent()`.
class AdConsent {
  /// Consent to send user data to ad networks for advertising.
  final AdConsentStatus adUserData;

  /// Consent for them to use that data for personalized advertising.
  final AdConsentStatus adPersonalization;

  const AdConsent({
    this.adUserData = AdConsentStatus.granted,
    this.adPersonalization = AdConsentStatus.granted,
  });

  PAdConsent toPigeon() => PAdConsent(
        adUserData: adUserData.toPigeon(),
        adPersonalization: adPersonalization.toPigeon(),
      );

  factory AdConsent.fromPigeon(PAdConsent consent) => AdConsent(
        adUserData: AdConsentStatus.fromPigeon(consent.adUserData),
        adPersonalization:
            AdConsentStatus.fromPigeon(consent.adPersonalization),
      );

  @override
  bool operator ==(Object other) =>
      other is AdConsent &&
      other.adUserData == adUserData &&
      other.adPersonalization == adPersonalization;

  @override
  int get hashCode => Object.hash(adUserData, adPersonalization);

  @override
  String toString() =>
      'AdConsent(adUserData: ${adUserData.name}, adPersonalization: ${adPersonalization.name})';
}
