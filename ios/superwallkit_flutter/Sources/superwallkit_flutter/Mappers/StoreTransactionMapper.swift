
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
      revocationDate: revocationDate?.isoString
    )
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
