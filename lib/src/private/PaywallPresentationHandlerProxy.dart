import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/src/public/PaywallPresentationHandler.dart';
import 'package:superwallkit_flutter/src/public/PaywallSkippedReason.dart';

class PaywallPresentationHandlerProxy {
  BridgeId bridgeId;
  PaywallPresentationHandler paywallPresentationHandler;

  PaywallPresentationHandlerProxy({
    required this.bridgeId,
    required this.paywallPresentationHandler
  }) {
    bridgeId.associate(this);
    bridgeId.communicator.setMethodCallHandler(_handleMethodCall);
  }

  // Handle method calls from native
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPresent':
        final bridgeId = call.bridgeId("paywallInfoBridgeId");
        final paywallInfo = PaywallInfo(bridgeId: bridgeId);

        paywallPresentationHandler.onPresentHandler?.call(paywallInfo);
      case 'onDismiss':
        final bridgeId = call.bridgeId("paywallInfoBridgeId");
        final paywallInfo = PaywallInfo(bridgeId: bridgeId);

        paywallPresentationHandler.onDismissHandler?.call(paywallInfo);
      case 'onError':
        final errorString = call.argument("errorString");
        paywallPresentationHandler.onErrorHandler?.call(errorString);
      case 'onSkip':
        final bridgeId = call.bridgeId("paywallSkippedReasonBridgeId");
        final paywallSkipReason = PaywallSkippedReason.createReasonFromBridgeId(bridgeId);
        if (paywallSkipReason == null) { return; }

        paywallPresentationHandler.onSkipHandler?.call(paywallSkipReason);
      default:
        throw UnimplementedError('Method ${call.method} not implemented.');
    }
  }
}