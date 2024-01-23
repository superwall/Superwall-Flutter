import Flutter
import SuperwallKit

public class ExperimentBridge: BridgeInstance {
  class override var bridgeClass: BridgeClass { "ExperimentBridge" }

  let experiment: Experiment

  required init(bridgeId: BridgeId, initializationArgs: [String : Any]? = nil) {
    guard let experiment = initializationArgs?["experiment"] as? Experiment else {
      fatalError("Attempting to create `ExperimentBridge` without providing `experiment`.")
    }
    
    self.experiment = experiment
    super.init(bridgeId: bridgeId, initializationArgs: initializationArgs)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getId":
        let id = experiment.id
        result(id)
      case "getDescription":
        let description = experiment.description
        result(description)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

extension Experiment {
  func createBridgeId() -> BridgeId {
    return BridgingCreator.shared.createBridgeInstance(bridgeClass: ExperimentBridge.bridgeClass, initializationArgs: ["experiment": self]).bridgeId
  }
}
