import Flutter
import SuperwallKit

extension Experiment {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["id"] = id
    dict["groupId"] = groupId
    dict["variant"] = variant.toJson()
    return dict
  }
}
