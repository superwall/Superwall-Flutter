import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';

/// A proxy class that bridges between the Flutter onBackPressed callback
/// and the generated POnBackPressedGenerated interface.
class OnBackPressedProxy implements POnBackPressedGenerated {
  final void Function(PaywallInfo?) handler;

  OnBackPressedProxy(this.handler);

  static void register(void Function(PaywallInfo?) handler, {String? hostId}) {
    final proxy = OnBackPressedProxy(handler);
    POnBackPressedGenerated.setUp(proxy, messageChannelSuffix: hostId ?? '');
  }

  @override
  void onBackPressed(PPaywallInfo? paywallInfo) {
    final info =
        paywallInfo != null ? PaywallInfo.fromPigeon(paywallInfo) : null;
    handler(info);
  }
}
