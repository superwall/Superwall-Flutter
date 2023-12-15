import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/public/SuperwallDelegate.dart';

class SuperwallDelegateProxy {
  MethodChannel channel;
  SuperwallDelegate delegate;

  SuperwallDelegateProxy({required this.channel, required this.delegate}) {
    channel.setMethodCallHandler(_handleMethodCall);
  }

  // Handle method calls from native
  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'willPresentPaywall':
        // TODO
        delegate.willPresentPaywall("test");
        break;
      case 'handleCustomPaywallAction':
        final name = call.arguments['name'];
        delegate.handleCustomPaywallAction(name);
        break;
    }
  }
}
