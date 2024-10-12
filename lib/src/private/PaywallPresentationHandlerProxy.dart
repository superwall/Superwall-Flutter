import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/src/public/PaywallPresentationHandler.dart';
import 'package:superwallkit_flutter/src/public/PaywallSkippedReason.dart';

class PaywallPresentationHandlerProxy extends BridgeIdInstantiable {
  static const BridgeClass bridgeClass = 'PaywallPresentationHandlerProxyBridge';
  PaywallPresentationHandlerProxy({required this.handler, super.bridgeId }): super(bridgeClass: bridgeClass);

  PaywallPresentationHandler handler;

  // Handle method calls from native
  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPresent':
        final bridgeId = call.bridgeId('paywallInfoBridgeId');
        final paywallInfo = PaywallInfo(bridgeId: bridgeId);

        handler.onPresentHandler?.call(paywallInfo);
      case 'onDismiss':
        final bridgeId = call.bridgeId('paywallInfoBridgeId');
        final paywallInfo = PaywallInfo(bridgeId: bridgeId);

        handler.onDismissHandler?.call(paywallInfo);
      case 'onError':
        final errorString = call.argument('errorString');
        handler.onErrorHandler?.call(errorString);
      case 'onSkip':
        final bridgeId = call.bridgeId('paywallSkippedReasonBridgeId');
        final paywallSkipReason = PaywallSkippedReason.createReasonFromBridgeId(bridgeId);
        if (paywallSkipReason == null) { return; }

        handler.onSkipHandler?.call(paywallSkipReason);
      default:
        throw UnimplementedError('Method ${call.method} not implemented.');
    }
  }
}