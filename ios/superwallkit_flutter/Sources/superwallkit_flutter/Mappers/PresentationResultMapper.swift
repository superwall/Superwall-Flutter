//
//  PPresentationResult.swift
//  superwallkit_flutter
//
//  Created by Yusuf Tör on 11/06/2025.
//

import Foundation
import SuperwallKit

extension PresentationResult {
  func pigeonify() -> PPresentationResult {
    switch self {
    case .placementNotFound:
      return PPlacementNotFoundPresentationResult()
    case .noAudienceMatch:
      return PNoAudienceMatchPresentationResult()
    case .paywall(let experiment):
      return PPaywallPresentationResult(experiment: experiment.pigeonify())
    case .holdout(let experiment):
      return PHoldoutPresentationResult(experiment: experiment.pigeonify())
    case .paywallNotAvailable:
      return PPaywallNotAvailablePresentationResult()
    }
  }
}
