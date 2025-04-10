import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:superwallkit_flutter_example/delegate/TestDelegateEvent.dart';

class TestDelegate extends SuperwallDelegate {
  final List<TestDelegateEvent> _events = [];

  List<TestDelegateEvent> get events => _events;
  List<TestDelegateEvent> get eventsWithoutLog => _events
      .where((event) =>
          event is! HandleLogEvent && event is! HandleSuperwallEventEvent)
      .toList();

  @override
  void didDismissPaywall(PaywallInfo paywallInfo) {
    events.add(DidDismissPaywallEvent(paywallInfo));
  }

  @override
  void didPresentPaywall(PaywallInfo paywallInfo) {
    events.add(DidPresentPaywallEvent(paywallInfo));
  }

  @override
  void handleCustomPaywallAction(String name) {
    events.add(HandleCustomPaywallActionEvent(name));
  }

  @override
  void handleLog(
      String level, String scope, String? message, Map? info, String? error) {
    events.add(HandleLogEvent(level, scope, message, info, error));
  }

  @override
  void handleSuperwallEvent(SuperwallEventInfo eventInfo) {
    events.add(HandleSuperwallEventEvent(eventInfo));
  }

  @override
  void paywallWillOpenDeepLink(Uri url) {
    events.add(PaywallWillOpenDeepLinkEvent(url));
  }

  @override
  void paywallWillOpenURL(Uri url) {
    events.add(PaywallWillOpenURLEvent(url));
  }

  @override
  void subscriptionStatusDidChange(SubscriptionStatus newValue) {
    events.add(SubscriptionStatusDidChangeEvent(newValue));
  }

  @override
  void willDismissPaywall(PaywallInfo paywallInfo) {
    events.add(WillDismissPaywallEvent(paywallInfo));
  }

  @override
  void willPresentPaywall(PaywallInfo paywallInfo) {
    events.add(WillPresentPaywallEvent(paywallInfo));
  }
}
