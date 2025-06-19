// Sealed class for delegate events
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

sealed class TestDelegateEvent {}

class DidDismissPaywallEvent extends TestDelegateEvent {
  final PaywallInfo paywallInfo;
  DidDismissPaywallEvent(this.paywallInfo);
}

class DidPresentPaywallEvent extends TestDelegateEvent {
  final PaywallInfo paywallInfo;
  DidPresentPaywallEvent(this.paywallInfo);
}

class HandleCustomPaywallActionEvent extends TestDelegateEvent {
  final String name;
  HandleCustomPaywallActionEvent(this.name);
}

class HandleLogEvent extends TestDelegateEvent {
  final String level;
  final String scope;
  final String? message;
  final Map? info;
  final String? error;
  HandleLogEvent(this.level, this.scope, this.message, this.info, this.error);
}

class HandleSuperwallEventEvent extends TestDelegateEvent {
  final SuperwallEventInfo eventInfo;
  HandleSuperwallEventEvent(this.eventInfo);
}

class PaywallWillOpenDeepLinkEvent extends TestDelegateEvent {
  final Uri url;
  PaywallWillOpenDeepLinkEvent(this.url);
}

class PaywallWillOpenURLEvent extends TestDelegateEvent {
  final Uri url;
  PaywallWillOpenURLEvent(this.url);
}

class SubscriptionStatusDidChangeEvent extends TestDelegateEvent {
  final SubscriptionStatus newValue;
  SubscriptionStatusDidChangeEvent(this.newValue);
}

class WillDismissPaywallEvent extends TestDelegateEvent {
  final PaywallInfo paywallInfo;
  WillDismissPaywallEvent(this.paywallInfo);
}

class WillPresentPaywallEvent extends TestDelegateEvent {
  final PaywallInfo paywallInfo;
  WillPresentPaywallEvent(this.paywallInfo);
}

class HandleSuperwallDeepLinkEvent extends TestDelegateEvent {
  final Uri fullURL;
  List<String> pathComponents;
  Map<String, String> queryParameters;

  HandleSuperwallDeepLinkEvent(
      this.fullURL, this.pathComponents, this.queryParameters);
}
