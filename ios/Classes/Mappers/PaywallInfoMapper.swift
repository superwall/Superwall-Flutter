import Foundation
import SuperwallKit

extension PaywallInfo {
  func pigeonify() -> PPaywallInfo {
    var productArray: [PProduct]? = nil
    if !products.isEmpty {
      productArray = products.map { product in
        PProduct(
          id: product.id,
          name: product.name,
          entitlements: product.entitlements.map { $0.pigeonify() }
        )
      }
    }

    return PPaywallInfo(
      identifier: identifier,
      name: name,
      experiment: experiment.map {
        PExperiment(
          id: $0.id,
          groupId: $0.groupId,
          variant: PVariant(
            id: $0.variant.id,
            type: $0.variant.type == .treatment ? .treatment : .holdout,
            paywallId: $0.variant.paywallId
          )
        )
      },
      productIds: Array(productIds),
      products: productArray,
      url: url.absoluteString,
      presentedByPlacementWithName: presentedByPlacementWithName,
      presentedByPlacementWithId: presentedByPlacementWithId,
      presentedByPlacementAt: presentedByPlacementAt,
      presentedBy: presentedBy,
      presentationSourceType: presentationSourceType,
      responseLoadStartTime: responseLoadStartTime,
      responseLoadCompleteTime: responseLoadCompleteTime,
      responseLoadFailTime: responseLoadFailTime,
      responseLoadDuration: responseLoadDuration,
      webViewLoadStartTime: webViewLoadStartTime,
      webViewLoadCompleteTime: webViewLoadCompleteTime,
      webViewLoadFailTime: webViewLoadFailTime,
      webViewLoadDuration: webViewLoadDuration,
      productsLoadStartTime: productsLoadStartTime,
      productsLoadCompleteTime: productsLoadCompleteTime,
      productsLoadFailTime: productsLoadFailTime,
      productsLoadDuration: productsLoadDuration,
      paywalljsVersion: paywalljsVersion,
      isFreeTrialAvailable: isFreeTrialAvailable,
      featureGatingBehavior: featureGatingBehavior == .gated ? .gated : .nonGated,
      closeReason: closeReason.pigeonify(),
      localNotifications: localNotifications.map { $0.pigeonify() },
      computedPropertyRequests: computedPropertyRequests.map {
        $0.pigeonify()
      },
      surveys: surveys.map { $0.pigeonify() }
    )
  }
}

extension PaywallCloseReason {
  func pigeonify() -> PPaywallCloseReason {
    switch self {
    case .systemLogic:
      return .systemLogic
    case .forNextPaywall:
      return .forNextPaywall
    case .webViewFailedToLoad:
      return .webViewFailedToLoad
    case .manualClose:
      return .manualClose
    case .none:
      return .none
    @unknown default:
      return .none
    }
  }
}

extension LocalNotification {
  func pigeonify() -> PLocalNotification {
    let type: PLocalNotificationType
    switch self.type {
    case .trialStarted:
      type = .trialStarted
    }

    return PLocalNotification(
      id: self.id,
      type: type,
      title: title,
      subtitle: subtitle,
      body: body,
      delay: Int64(delay)
    )
  }
}

extension ComputedPropertyRequest {
  func pigeonify() -> PComputedPropertyRequest {
    let type: PComputedPropertyRequestType

    switch self.type {
    case .minutesSince:
      type = .minutesSince
    case .hoursSince:
      type = .hoursSince
    case .daysSince:
      type = .daysSince
    case .monthsSince:
      type = .monthsSince
    case .yearsSince:
      type = .yearsSince
    case .placementsInHour:
      type = .placementsInHour
    case .placementsInDay:
      type = .placementsInDay
    case .placementsInWeek:
      type = .placementsInWeek
    case .placementsInMonth:
      type = .placementsInMonth
    case .placementsSinceInstall:
      type = .placementsSinceInstall
    }

    return PComputedPropertyRequest(
      type: type,
      eventName: placementName
    )
  }
}

extension Survey {
  func pigeonify() -> PSurvey {
    let condition: PSurveyShowCondition
    switch presentationCondition {
    case .onManualClose:
      condition = .onManualClose
    case .onPurchase:
      condition = .onPurchase
    @unknown default:
      condition = .onManualClose
    }

    return PSurvey(
      id: id,
      assignmentKey: assignmentKey,
      title: title,
      message: message,
      options: options.map { PSurveyOption(id: $0.id, text: $0.title) },
      presentationCondition: condition,
      presentationProbability: presentationProbability,
      includeOtherOption: includeOtherOption,
      includeCloseOption: includeCloseOption
    )
  }
}
