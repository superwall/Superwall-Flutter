import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

class RestorationResult {
  BridgeId bridgeId;

  RestorationResult._privateConstructor(this.bridgeId) {
    bridgeId.associate(this);
  }

  static RestorationResult restored = RestorationResult._privateConstructor(BridgingCreator.createRestorationResultRestoredBridge());
  static RestorationResult failed(String error) => RestorationResult._privateConstructor(BridgingCreator.createRestorationResultFailedBridge(error));
}