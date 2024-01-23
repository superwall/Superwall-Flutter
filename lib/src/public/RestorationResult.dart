import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

class RestorationResult extends BridgeIdInstantiable {
  RestorationResult({ required BridgeClass bridgeClass, BridgeId? bridgeId, Map<String, dynamic>? initializationArgs }): super(bridgeClass: bridgeClass, bridgeId: bridgeId, initializationArgs: initializationArgs);

  static RestorationResult restored = RestorationResultRestored();
  static RestorationResult failed(String error) => RestorationResultFailed(error: error);
}

class RestorationResultRestored extends RestorationResult {
  static const BridgeClass bridgeClass = "RestorationResultRestoredBridge";
  RestorationResultRestored({ BridgeId? bridgeId }): super(bridgeClass: bridgeClass, bridgeId: bridgeId);
}

class RestorationResultFailed extends RestorationResult {
  static const BridgeClass bridgeClass = "RestorationResultFailedBridge";
  RestorationResultFailed({ required String error, BridgeId? bridgeId }): super(bridgeClass: bridgeClass, bridgeId: bridgeId, initializationArgs: {"error": error});
}