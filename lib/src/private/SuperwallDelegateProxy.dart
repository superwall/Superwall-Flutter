import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/src/public/SubscriptionStatus.dart';
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
        final json = call.argument("paywallInfo");
        final paywallInfo = PaywallInfo.fromJson(json);
        delegate.willPresentPaywall(paywallInfo);
        break;
      case 'didPresentPaywall':
        final json = call.argument("paywallInfo");
        final paywallInfo = PaywallInfo.fromJson(json);
        delegate.didPresentPaywall(paywallInfo);
        break;
      case 'willDismissPaywall':
        final json = call.argument("paywallInfo");
        final paywallInfo = PaywallInfo.fromJson(json);
        delegate.willDismissPaywall(paywallInfo);
        break;
      case 'didDismissPaywall':
        final json = call.argument("paywallInfo");
        final paywallInfo = PaywallInfo.fromJson(json);
        delegate.didDismissPaywall(paywallInfo);
        break;
      case 'handleCustomPaywallAction':
        final name = call.argument("name");
        delegate.handleCustomPaywallAction(name);
        break;
      case 'subscriptionStatusDidChange':
        final json = call.argument("newValue");
        final status = SubscriptionStatus.fromJson(json);
        delegate.subscriptionStatusDidChange(status);
        break;
      case 'paywallWillOpenURL':
        final url = call.argument("url");
        delegate.paywallWillOpenURL(Uri.parse(url));
        break;
      case 'paywallWillOpenDeepLink':
        final url = call.argument("url");
        delegate.paywallWillOpenDeepLink(Uri.parse(url));
        break;
      default:
        throw ArgumentError('Method not implemented');
    }
  }

}