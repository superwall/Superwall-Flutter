/*import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

/// An enum representing the subscription status of the user.
class ConfigurationStatus extends BridgeIdInstantiable {
  ConfigurationStatus({required BridgeClass bridgeClass, BridgeId? bridgeId})
      : super(bridgeClass: bridgeClass, bridgeId: bridgeId);

  static final ConfigurationStatus pending = ConfigurationStatusPending();
  static final ConfigurationStatus configured = ConfigurationStatusConfigured();
  static final ConfigurationStatus failed = ConfigurationStatusFailed();

  static ConfigurationStatus? createConfigurationStatusFromBridgeId(
      BridgeId bridgeId) {
    switch (bridgeId.bridgeClass) {
      case ConfigurationStatusPending.bridgeClass:
        return ConfigurationStatus.pending;
      case ConfigurationStatusConfigured.bridgeClass:
        return ConfigurationStatus.configured;
      case ConfigurationStatusFailed.bridgeClass:
        return ConfigurationStatus.failed;
      default:
        return null;
    }
  }

  Future<String> get description async {
    return await bridgeId.communicator.invokeBridgeMethod('getDescription');
  }
}

class ConfigurationStatusPending extends ConfigurationStatus {
  static const BridgeClass bridgeClass = "ConfigurationStatusPendingBridge";
  ConfigurationStatusPending({BridgeId? bridgeId})
      : super(bridgeClass: bridgeClass, bridgeId: bridgeId);
}

class ConfigurationStatusConfigured extends ConfigurationStatus {
  static const BridgeClass bridgeClass = "ConfigurationStatusConfiguredBridge";
  ConfigurationStatusConfigured({BridgeId? bridgeId})
      : super(bridgeClass: bridgeClass, bridgeId: bridgeId);
}

class ConfigurationStatusFailed extends ConfigurationStatus {
  static const BridgeClass bridgeClass = "ConfigurationStatusFailedBridge";
  ConfigurationStatusFailed({BridgeId? bridgeId})
      : super(bridgeClass: bridgeClass, bridgeId: bridgeId);
}
*/