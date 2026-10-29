import Foundation
import SuperwallKit

extension PAdConsent {
  func toSdk() -> AdConsent {
    return AdConsent(
      adUserData: adUserData.toSdk(),
      adPersonalization: adPersonalization.toSdk()
    )
  }
}

extension PAdConsentStatus {
  func toSdk() -> AdConsentStatus {
    switch self {
    case .granted:
      return .granted
    case .denied:
      return .denied
    }
  }
}

extension AdConsent {
  func pigeonify() -> PAdConsent {
    return PAdConsent(
      adUserData: adUserData.pigeonify(),
      adPersonalization: adPersonalization.pigeonify()
    )
  }
}

extension AdConsentStatus {
  func pigeonify() -> PAdConsentStatus {
    switch self {
    case .granted:
      return .granted
    case .denied:
      return .denied
    @unknown default:
      return .granted
    }
  }
}
