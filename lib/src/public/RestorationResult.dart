import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

class RestorationResult extends BridgeIdInstantiable {
  RestorationResult({required super.bridgeClass, super.bridgeId, super.initializationArgs});

  static RestorationResult restored = RestorationResultRestored();
  static RestorationResult failed(String error) => RestorationResultFailed(error: error);
}

class RestorationResultRestored extends RestorationResult {
  static const BridgeClass bridgeClass = 'RestorationResultRestoredBridge';
  RestorationResultRestored({super.bridgeId}): super(bridgeClass: bridgeClass);
}

class RestorationResultFailed extends RestorationResult {
  static const BridgeClass bridgeClass = 'RestorationResultFailedBridge';
  RestorationResultFailed({required String error, super.bridgeId}): super(bridgeClass: bridgeClass, initializationArgs: {'error': error});
}