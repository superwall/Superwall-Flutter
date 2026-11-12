import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// A proxy class that bridges between one embedded [PaywallView] and the
/// generated PPaywallViewCallbackGenerated interface.
///
/// Each platform view registers its own proxy under its unique host ID, and
/// the view unregisters it when the platform view is replaced or disposed.
class PaywallViewCallbackProxy implements PPaywallViewCallbackGenerated {
  final void Function() onLoadStartHandler;
  final void Function(PaywallInfo) onPresentHandler;
  final void Function(PaywallInfo, PaywallResult, bool) onFinishedHandler;
  final void Function(PaywallSkippedReason) onSkipHandler;
  final void Function(String) onErrorHandler;
  final void Function(PaywallLoadingState) onLoadingStateChangedHandler;
  final Future<CustomCallbackResult> Function(CustomCallback)? Function()
      customCallbackHandler;

  PaywallViewCallbackProxy({
    required this.onLoadStartHandler,
    required this.onPresentHandler,
    required this.onFinishedHandler,
    required this.onSkipHandler,
    required this.onErrorHandler,
    required this.onLoadingStateChangedHandler,
    required this.customCallbackHandler,
  });

  /// Registers this proxy for the platform view with the given [hostId].
  void register(String hostId) {
    PPaywallViewCallbackGenerated.setUp(this, messageChannelSuffix: hostId);
  }

  /// Removes the proxy registered for the platform view with the given
  /// [hostId].
  static void unregister(String hostId) {
    PPaywallViewCallbackGenerated.setUp(null, messageChannelSuffix: hostId);
  }

  @override
  void onLoadStart() {
    onLoadStartHandler();
  }

  @override
  void onPresent(PPaywallInfo paywallInfo) {
    onPresentHandler(PaywallInfo.fromPigeon(paywallInfo)!);
  }

  @override
  void onFinished(
      PPaywallInfo paywallInfo, PPaywallResult result, bool shouldDismiss) {
    onFinishedHandler(PaywallInfo.fromPigeon(paywallInfo)!,
        PaywallResult.fromPigeon(result)!, shouldDismiss);
  }

  @override
  void onSkip(PPaywallSkippedReason reason, PExperiment? experiment) {
    final skippedReason = PaywallSkippedReason.fromPigeon(reason, experiment);
    if (skippedReason != null) {
      onSkipHandler(skippedReason);
    }
  }

  @override
  void onError(String error) {
    onErrorHandler(error);
  }

  @override
  void onLoadingStateChanged(PPaywallLoadingState state) {
    onLoadingStateChangedHandler(PaywallLoadingState.fromPigeon(state));
  }

  @override
  Future<PCustomCallbackResult> onCustomCallback(
      PCustomCallback callback) async {
    final handler = customCallbackHandler();
    if (handler != null) {
      final result = await handler(CustomCallback.fromPigeon(callback));
      return result.toPigeon();
    }
    // Return failure if no handler is set
    return PCustomCallbackResult(
      status: PCustomCallbackResultStatus.failure,
      data: null,
    );
  }
}
