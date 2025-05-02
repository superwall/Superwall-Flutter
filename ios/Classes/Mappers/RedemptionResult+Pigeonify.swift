import Foundation
import SuperwallKit

extension RedemptionResult {
  func pigeonify() -> PRedemptionResult {
    switch self {
    case .success(let code, let redemptionInfo):
      return PSuccessRedemptionResult(
        code: code,
        redemptionInfo: redemptionInfo.pigeonify()
      )
    case .error(let code, let error):
      let error = PErrorInfo(message: error.message)
      return PErrorRedemptionResult(code: code, error: error)
    case .expiredCode(let code, let info):
      let info = PExpiredCodeInfo(
        resent: info.resent,
        obfuscatedEmail: info.obfuscatedEmail
      )
      return PExpiredCodeRedemptionResult(code: code, info: info)
    case .invalidCode(let code):
      return PInvalidCodeRedemptionResult(code: code)
    case .expiredSubscription(let code, let redemptionInfo):
      return PExpiredSubscriptionCode(
        code: code,
        redemptionInfo: redemptionInfo.pigeonify()
      )
    }
  }
}

extension RedemptionResult.RedemptionInfo {
  func pigeonify() -> PRedemptionInfo {
    let ownership: POwnership
    switch self.ownership {
    case .appUser(let appUserId):
      ownership = PAppUserOwnership(appUserId: appUserId)
    case .device(let deviceId):
      ownership = PDeviceOwnership(deviceId: deviceId)
    }
    let storeIdentifiers: PStoreIdentifiers

    switch self.purchaserInfo.storeIdentifiers {
    case let .stripe(customerId, subscriptionIds):
      storeIdentifiers = PStripeStoreIdentifiers(customerId: customerId, subscriptionIds: subscriptionIds)
    case let .unknown(store, additionalInfo):
      storeIdentifiers = PUnknownStoreIdentifiers(store: store, additionalInfo: additionalInfo)
    }

    let purchaseInfo = PPurchaserInfo(
      appUserId: self.purchaserInfo.appUserId,
      email: self.purchaserInfo.email,
      storeIdentifiers: storeIdentifiers
    )

    var paywallRedemptionInfo: PRedemptionPaywallInfo?

    if let paywallInfo = self.paywallInfo {
      paywallRedemptionInfo = PRedemptionPaywallInfo(
        identifier: paywallInfo.identifier,
        placementName: paywallInfo.placementName,
        placementParams: paywallInfo.placementParams,
        variantId: paywallInfo.variantId,
        experimentId: paywallInfo.experimentId
      )
    }

    let entitlements = self.entitlements.map { PEntitlement(id: $0.id) }
    return PRedemptionInfo(
      ownership: ownership,
      purchaserInfo: purchaseInfo,
      paywallInfo: paywallRedemptionInfo,
      entitlements: entitlements
    )
  }
}
