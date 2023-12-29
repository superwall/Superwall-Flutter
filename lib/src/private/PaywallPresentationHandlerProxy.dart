import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/src/public/PaywallPresentationHandler.dart';
import 'package:superwallkit_flutter/src/public/PaywallSkippedReason.dart';

class PaywallPresentationHandlerProxy {
  Bridge bridge;
  final MethodChannel channel;
  PaywallPresentationHandler paywallPresentationHandler;

  PaywallPresentationHandlerProxy({
    required this.bridge,
    required this.paywallPresentationHandler
  }): channel = MethodChannel(bridge) {
    bridge.associate(this);
    channel.setMethodCallHandler(_handleMethodCall);
  }

  // Handle method calls from native
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPresent':
        final json = call.argument("paywallInfo");
        final paywallInfo = PaywallInfo.fromJson(json);
        paywallPresentationHandler.onPresentHandler?.call(paywallInfo);
      case 'onDismiss':
        final json = call.argument("paywallInfo");
        final paywallInfo = PaywallInfo.fromJson(json);
        paywallPresentationHandler.onDismissHandler?.call(paywallInfo);
      case 'onError':
        final json = call.argument("error");
        final error = JsonString.fromJson(json);
        paywallPresentationHandler.onErrorHandler?.call(error);
      case 'onSkip':
        final json = call.argument("paywallSkippedReason");
        final paywallInfo = PaywallSkippedReason.fromJson(json);
        paywallPresentationHandler.onSkipHandler?.call(paywallInfo);
      default:
        throw UnimplementedError('Method ${call.method} not implemented.');
    }
  }
}