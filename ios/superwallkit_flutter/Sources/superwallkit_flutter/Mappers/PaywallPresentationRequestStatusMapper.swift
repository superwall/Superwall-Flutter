import Foundation
import SuperwallKit

extension PaywallPresentationRequestStatus {
  func pigeonify() -> PPaywallPresentationRequestStatusType {
    switch self {
    case .noPresentation:
      return .noPresentation
    case .presentation:
      return .presentation
    case .timeout:
      return .timeout
    }
  }
}
