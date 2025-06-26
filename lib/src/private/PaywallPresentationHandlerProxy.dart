import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// A proxy class that bridges between the Flutter PaywallPresentationHandler
/// and the generated PPaywallPresentationHandlerGenerated interface.
class PaywallPresentationHandlerProxy
    implements PPaywallPresentationHandlerGenerated {
  final PaywallPresentationHandler handler;

  PaywallPresentationHandlerProxy(this.handler);

  static void register(PaywallPresentationHandler handler, {String? hostId}) {
    final proxy = PaywallPresentationHandlerProxy(handler);
    PPaywallPresentationHandlerGenerated.setUp(proxy,
        messageChannelSuffix: hostId ?? '');
  }

  @override
  void onPresent(PPaywallInfo paywallInfo) {
    if (handler.onPresentHandler != null) {
      handler.onPresentHandler!(PaywallInfo.fromPigeon(paywallInfo)!);
    }
  }

  @override
  void onDismiss(PPaywallInfo paywallInfo, PPaywallResult paywallResult) {
    if (handler.onDismissHandler != null) {
      handler.onDismissHandler!(PaywallInfo.fromPigeon(paywallInfo)!,
          PaywallResult.fromPigeon(paywallResult)!);
    }
  }

  @override
  void onError(String error) {
    if (handler.onErrorHandler != null) {
      handler.onErrorHandler!(error);
    }
  }

  @override
  void onSkip(PPaywallSkippedReason reason) {
    if (handler.onSkipHandler != null) {
      handler.onSkipHandler!(PaywallSkippedReason.fromPigeon(reason)!);
    }
  }
}
