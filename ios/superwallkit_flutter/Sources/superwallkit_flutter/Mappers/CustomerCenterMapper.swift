import Foundation
import SuperwallKit

// Converts between the Pigeon Customer Center models and the iOS SDK's.

extension PCustomerCenterConfiguration {
  func toSdk() -> CustomerCenterConfiguration {
    return CustomerCenterConfiguration(
      managementScreen: managementScreen.toSdk(),
      noPurchasesScreen: noPurchasesScreen.toSdk(),
      support: support.toSdk(),
      appearance: CustomerCenterConfiguration.Appearance(
        accent: accent.map {
          CustomerCenterConfiguration.Appearance.ColorPair(light: $0.light, dark: $0.dark)
        }
      ),
      showsAccountDetails: showsAccountDetails,
      warnsAboutDuplicateSubscriptions: warnsAboutDuplicateSubscriptions
    )
  }
}

extension PCustomerCenterScreen {
  func toSdk() -> CustomerCenterConfiguration.Screen {
    return CustomerCenterConfiguration.Screen(
      title: title,
      subtitle: subtitle,
      paths: paths.compactMap { $0.toSdk() }
    )
  }
}

extension PCustomerCenterPath {
  /// `nil` when the path's type can't be represented on iOS, such as a URL path whose URL
  /// doesn't parse.
  func toSdk() -> CustomerCenterConfiguration.Path? {
    guard let sdkType = customerCenterPathType(from: type) else {
      return nil
    }
    return CustomerCenterConfiguration.Path(
      id: id,
      type: sdkType,
      title: title,
      survey: survey?.toSdk()
    )
  }
}

private func customerCenterPathType(
  from type: PCustomerCenterPathType
) -> CustomerCenterConfiguration.PathType? {
  switch type {
  case is PCustomerCenterRestorePathType:
    return .restore
  case is PCustomerCenterManageSubscriptionPathType:
    return .manageSubscription
  case let refund as PCustomerCenterRefundPathType:
    // Flutter sends milliseconds; iOS takes seconds.
    return .refund(window: refund.windowMillis.map { TimeInterval($0) / 1000 })
  case let changePlan as PCustomerCenterChangePlanPathType:
    return .changePlan(productIds: changePlan.productIds)
  case is PCustomerCenterContactSupportPathType:
    return .contactSupport
  case let urlPath as PCustomerCenterUrlPathType:
    guard let url = URL(string: urlPath.url) else {
      return nil
    }
    return .url(url, openMethod: urlPath.openMethod.toSdk())
  case let custom as PCustomerCenterCustomPathType:
    return .custom(identifier: custom.identifier)
  default:
    return nil
  }
}

extension PCustomerCenterOpenMethod {
  func toSdk() -> CustomerCenterConfiguration.OpenMethod {
    switch self {
    case .inApp:
      return .inApp
    case .external:
      return .external
    }
  }
}

extension PCustomerCenterSurvey {
  func toSdk() -> CustomerCenterConfiguration.FeedbackSurvey {
    return CustomerCenterConfiguration.FeedbackSurvey(
      id: id,
      title: title,
      options: options.map {
        CustomerCenterConfiguration.FeedbackSurvey.Option(id: $0.id, title: $0.title)
      }
    )
  }
}

extension PCustomerCenterSupport {
  func toSdk() -> CustomerCenterConfiguration.Support {
    return CustomerCenterConfiguration.Support(
      email: email,
      latestAppVersion: latestAppVersion,
      warnsAboutUpdates: warnsAboutUpdates,
      checksAppStoreForUpdates: checksAppStoreForUpdates,
      webManagementURL: webManagementUrl.flatMap { URL(string: $0) }
    )
  }
}

extension CustomerCenterAction {
  func pigeonify() -> PCustomerCenterAction {
    switch self {
    case .restore:
      return PCustomerCenterRestoreAction()
    case .manageSubscription:
      return PCustomerCenterManageSubscriptionAction()
    case .refund:
      return PCustomerCenterRefundAction()
    case .changePlan:
      return PCustomerCenterChangePlanAction()
    case .contactSupport:
      return PCustomerCenterContactSupportAction()
    case .url(let url):
      return PCustomerCenterUrlAction(url: url.absoluteString)
    case .custom(let identifier):
      return PCustomerCenterCustomAction(identifier: identifier)
    }
  }
}

extension CustomerCenterRefundStatus {
  func pigeonify() -> PCustomerCenterRefundStatus {
    switch self {
    case .success:
      return .success
    case .userCancelled:
      return .userCancelled
    case .error:
      return .error
    @unknown default:
      return .error
    }
  }
}

extension CustomerCenterPurchase {
  func pigeonify() -> PCustomerCenterPurchase {
    return PCustomerCenterPurchase(
      productId: productId,
      store: store.pigeonify(),
      entitlements: entitlements.map { $0.pigeonify() },
      subscription: subscription?.pigeonify(),
      nonSubscription: nonSubscription?.pigeonify()
    )
  }
}
