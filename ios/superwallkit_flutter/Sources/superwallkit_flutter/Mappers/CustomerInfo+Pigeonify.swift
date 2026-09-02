import Foundation
import SuperwallKit

extension CustomerInfo {
  func pigeonify() -> PCustomerInfo {
    return PCustomerInfo(
      subscriptions: subscriptions.map { $0.pigeonify() },
      nonSubscriptions: nonSubscriptions.map { $0.pigeonify() },
      entitlements: entitlements.map { $0.pigeonify() },
      userId: userId
    )
  }
}

extension SubscriptionTransaction {
  func pigeonify() -> PSubscriptionTransaction {
    return PSubscriptionTransaction(
      transactionId: transactionId,
      productId: productId,
      purchaseDate: Int64(purchaseDate.timeIntervalSince1970 * 1000),
      willRenew: willRenew,
      isRevoked: isRevoked,
      isInGracePeriod: isInGracePeriod,
      isInBillingRetryPeriod: isInBillingRetryPeriod,
      isActive: isActive,
      expirationDate: expirationDate.map { Int64($0.timeIntervalSince1970 * 1000) },
      offerType: offerType?.pigeonify(),
      subscriptionGroupId: subscriptionGroupId,
      store: store.pigeonify()
    )
  }
}

extension NonSubscriptionTransaction {
  func pigeonify() -> PNonSubscriptionTransaction {
    return PNonSubscriptionTransaction(
      transactionId: transactionId,
      productId: productId,
      purchaseDate: Int64(purchaseDate.timeIntervalSince1970 * 1000),
      isConsumable: isConsumable,
      isRevoked: isRevoked,
      store: store.pigeonify()
    )
  }
}

extension Entitlement {
  func pigeonify() -> PEntitlement {
    return PEntitlement(
      id: id,
      type: type.pigeonify(),
      isActive: isActive,
      productIds: Array(productIds),
      latestProductId: latestProductId,
      store: store?.pigeonify(),
      startsAt: startsAt.map { Int64($0.timeIntervalSince1970 * 1000) },
      renewedAt: renewedAt.map { Int64($0.timeIntervalSince1970 * 1000) },
      expiresAt: expiresAt.map { Int64($0.timeIntervalSince1970 * 1000) },
      isLifetime: isLifetime,
      willRenew: willRenew,
      state: state?.pigeonify(),
      offerType: offerType?.pigeonify()
    )
  }
}

extension EntitlementType {
  func pigeonify() -> PEntitlementType {
    switch self {
    case .serviceLevel:
      return PEntitlementType.serviceLevel
    }
  }

  static func fromPigeon(_ pigeon: PEntitlementType) -> EntitlementType {
    switch pigeon {
    case .serviceLevel:
      return .serviceLevel
    }
  }
}

extension ProductStore {
  func pigeonify() -> PProductStore {
    switch self {
    case .appStore:
      return PProductStore.appStore
    case .stripe:
      return PProductStore.stripe
    case .paddle:
      return PProductStore.paddle
    case .playStore:
      return PProductStore.playStore
    case .superwall:
      return PProductStore.superwall
    case .other:
      return PProductStore.other
    @unknown default:
      return PProductStore.other
    }
  }

  static func fromPigeon(_ pigeon: PProductStore) -> ProductStore {
    switch pigeon {
    case .appStore:
      return .appStore
    case .stripe:
      return .stripe
    case .paddle:
      return .paddle
    case .playStore:
      return .playStore
    case .superwall:
      return .superwall
    case .other:
      return .other
    }
  }
}

extension LatestSubscription.State {
  func pigeonify() -> PLatestSubscriptionState {
    switch self {
    case .inGracePeriod:
      return PLatestSubscriptionState.inGracePeriod
    case .subscribed:
      return PLatestSubscriptionState.subscribed
    case .expired:
      return PLatestSubscriptionState.expired
    case .inBillingRetryPeriod:
      return PLatestSubscriptionState.inBillingRetryPeriod
    case .revoked:
      return PLatestSubscriptionState.revoked
    }
  }

  static func fromPigeon(_ pigeon: PLatestSubscriptionState) -> LatestSubscription.State {
    switch pigeon {
    case .inGracePeriod:
      return .inGracePeriod
    case .subscribed:
      return .subscribed
    case .expired:
      return .expired
    case .inBillingRetryPeriod:
      return .inBillingRetryPeriod
    case .revoked:
      return .revoked
    }
  }
}

typealias LatestSubscriptionState = LatestSubscription.State
typealias LatestSubscriptionOfferType = LatestSubscription.OfferType

extension LatestSubscription.OfferType {
  func pigeonify() -> PLatestSubscriptionOfferType {
    switch self {
    case .trial:
      return PLatestSubscriptionOfferType.trial
    case .code:
      return PLatestSubscriptionOfferType.code
    case .promotional:
      return PLatestSubscriptionOfferType.promotional
    case .winback:
      return PLatestSubscriptionOfferType.winback
    }
  }

  static func fromPigeon(_ pigeon: PLatestSubscriptionOfferType) -> LatestSubscription.OfferType {
    switch pigeon {
    case .trial:
      return .trial
    case .code:
      return .code
    case .promotional:
      return .promotional
    case .winback:
      return .winback
    }
  }
}
