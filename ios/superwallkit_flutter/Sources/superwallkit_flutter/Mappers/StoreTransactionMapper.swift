
import Foundation
import SuperwallKit

extension StoreTransaction {
  func pigeonify() -> PStoreTransaction {
    return PStoreTransaction(
      configRequestId: configRequestId,
      appSessionId: appSessionId,
      transactionDate: transactionDate?.isoString,
      originalTransactionIdentifier: originalTransactionIdentifier,
      storeTransactionId: storeTransactionId,
      originalTransactionDate: originalTransactionDate?.isoString,
      webOrderLineItemID: webOrderLineItemID,
      appBundleId: appBundleId,
      subscriptionGroupId: subscriptionGroupId,
      isUpgraded: isUpgraded,
      expirationDate: expirationDate?.isoString,
      offerId: offerId,
      revocationDate: revocationDate?.isoString,
      state: state.pigeonify(),
      payment: PStorePayment(
        productIdentifier: payment.productIdentifier,
        quantity: Int64(payment.quantity),
        discountIdentifier: payment.discountIdentifier
      ),
      appAccountToken: appAccountToken?.uuidString
    )
  }
}

extension StoreTransactionState {
  func pigeonify() -> PStoreTransactionState {
    switch self {
    case .purchasing:
      return .purchasing
    case .purchased:
      return .purchased
    case .failed:
      return .failed
    case .restored:
      return .restored
    case .deferred:
      return .deferred
    }
  }
}

extension Date {
  static let isoFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter
  }()

  var isoString: String {
    return Self.isoFormatter.string(from: self)
  }
}
