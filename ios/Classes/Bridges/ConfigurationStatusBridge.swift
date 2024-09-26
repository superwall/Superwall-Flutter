import Flutter
import SuperwallKit

// Abstract base class for subscription status enum
public class ConfigurationStatusBridge: BridgeInstance {
  var configurationStatus: ConfigurationStatus {
    assertionFailure("Subclasses must implement")
    return .pending
  }
}

public class ConfigurationStatusPendingBridge: ConfigurationStatusBridge {
  class override var bridgeClass: BridgeClass { "ConfigurationStatusPendingBridge" }
  override var configurationStatus: ConfigurationStatus { .pending }
}

public class ConfigurationStatusConfiguredBridge: ConfigurationStatusBridge {
  class override var bridgeClass: BridgeClass { "ConfigurationStatusConfiguredBridge" }
  override var configurationStatus: ConfigurationStatus { .configured }
}

public class ConfigurationStatusFailedBridge: ConfigurationStatusBridge {
  class override var bridgeClass: BridgeClass { "ConfigurationStatusFailedBridge" }
  override var configurationStatus: ConfigurationStatus { .failed }
}

extension ConfigurationStatus {
  func createBridgeId() -> BridgeId {
    switch self {
      case .pending:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: ConfigurationStatusPendingBridge.bridgeClass)
        return bridgeInstance.bridgeId
      case .configured:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: ConfigurationStatusConfiguredBridge.bridgeClass)
        return bridgeInstance.bridgeId
      case .failed:
        let bridgeInstance = BridgingCreator.shared.createBridgeInstance(bridgeClass: ConfigurationStatusFailedBridge.bridgeClass)
        return bridgeInstance.bridgeId
    }
  }
}