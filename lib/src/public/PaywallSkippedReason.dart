import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/Experiment.dart';

/// The reason the paywall presentation was skipped.
abstract class PaywallSkippedReason {
  final BridgeId bridgeId;

  PaywallSkippedReason._privateConstructor(this.bridgeId) {
    bridgeId.associate(this);
  }

  static PaywallSkippedReason? createReasonFrom(BridgeId bridgeId) {
    // TODO: Improve this. Identifier should be implementation detail of BridgingCreator
    if (bridgeId.bridgeClass == "PaywallSkippedReasonHoldoutBridge") {
      return PaywallSkippedReasonHoldout._privateConstructor(bridgeId);
    } else if (bridgeId.bridgeClass == "PaywallSkippedReasonNoRuleMatchBridge") {
      return PaywallSkippedReasonNoRuleMatch._privateConstructor(bridgeId);
    } else if (bridgeId.bridgeClass == "PaywallSkippedReasonEventNotFoundBridge") {
      return PaywallSkippedReasonEventNotFound._privateConstructor(bridgeId);
    } else if (bridgeId.bridgeClass == "PaywallSkippedReasonUserIsSubscribedBridge") {
      return PaywallSkippedReasonUserIsSubscribed._privateConstructor(bridgeId);
    }

    return null;
  }

  Future<String> get description async {
    final description = await bridgeId.communicator.invokeBridgeMethod('getDescription');
    return description;
  }
}

class PaywallSkippedReasonHoldout extends PaywallSkippedReason {
  Future<Experiment> get experiment async {
    BridgeId experimentBridgeId = await bridgeId.communicator.invokeBridgeMethod('getExperimentBridgeId');
    Experiment experiment = Experiment(bridgeId: experimentBridgeId);
    return experiment;
  }

  PaywallSkippedReasonHoldout._privateConstructor(BridgeId bridgeId)
      : super._privateConstructor(bridgeId);
}

class PaywallSkippedReasonNoRuleMatch extends PaywallSkippedReason {
  PaywallSkippedReasonNoRuleMatch._privateConstructor(BridgeId bridgeId)
      : super._privateConstructor(bridgeId);
}

class PaywallSkippedReasonEventNotFound extends PaywallSkippedReason {
  PaywallSkippedReasonEventNotFound._privateConstructor(BridgeId bridgeId)
      : super._privateConstructor(bridgeId);
}

class PaywallSkippedReasonUserIsSubscribed extends PaywallSkippedReason {
  PaywallSkippedReasonUserIsSubscribed._privateConstructor(BridgeId bridgeId)
      : super._privateConstructor(bridgeId);
}