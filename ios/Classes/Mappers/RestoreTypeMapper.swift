import Foundation
import SuperwallKit

extension RestoreType {
  func pigeonify() -> PRestoreType {
    switch self {
    case .viaPurchase(let storeTransaction):
      return PViaPurchase(storeTransaction: storeTransaction?.pigeonify())
    case .viaRestore:
      return PViaRestore()
    }
  }
}
