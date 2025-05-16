import Foundation
import SuperwallKit

extension SurveyOption {
  func pigeonify() -> PSurveyOption {
    return PSurveyOption(id: id, text: title)
  }
}
