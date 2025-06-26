import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class MySuperwallDelegate extends SuperwallDelegate {
  final logging = Logging();

  @override
  void didRedeemLink(RedemptionResult result) {
    logging.info('didRedeemLink: $result');
    super.didRedeemLink(result);
  }

  @override
  void willRedeemLink() {
    logging.info('willRedeemLink');
    super.willRedeemLink();
  }

  @override
  void didDismissPaywall(PaywallInfo paywallInfo) {
    logging.info('didDismissPaywall: $paywallInfo');
  }

  @override
  void didPresentPaywall(PaywallInfo paywallInfo) {
    logging.info('didPresentPaywall: $paywallInfo');
  }

  @override
  void handleCustomPaywallAction(String name) {
    logging.info('handleCustomPaywallAction: $name');
  }

  @override
  void handleLog(String level, String scope, String? message,
      Map<dynamic, dynamic>? info, String? error) {
    print('handleLog: $level, $scope, $message, $info, $error');
    // logging.info("handleLog: $level, $scope, $message, $info, $error");
  }

  @override
  Future<void> handleSuperwallEvent(SuperwallEventInfo eventInfo) async {
    // This delegate function is noisy. Uncomment to debug.
    //logging.info('handleSuperwallEvent: $eventInfo');
    //switch (eventInfo.event.type) {
    //  case EventType.appOpen:
    //    logging.info('appOpen event');
    //  case EventType.deviceAttributes:
    //    logging.info('deviceAttributes event: ${eventInfo.event.deviceAttributes} ');
    //  case EventType.paywallOpen:
    //    final paywallInfo = eventInfo.event.paywallInfo;
    //    logging.info('paywallOpen event: $paywallInfo ');
    //
    //    if (paywallInfo != null) {
    //      final identifier = await paywallInfo.identifier;
    //      logging.info('paywallInfo.identifier: $identifier ');
    //
    //      final productIds = await paywallInfo.productIds;
    //      logging.info('paywallInfo.productIds: $productIds ');
    //    }
    //  default:
    //    break;
    //}
  }

  @override
  void paywallWillOpenDeepLink(Uri url) {
    logging.info('paywallWillOpenDeepLink: $url');
  }

  @override
  void paywallWillOpenURL(Uri url) {
    logging.info('paywallWillOpenURL: $url');
  }

  @override
  void subscriptionStatusDidChange(SubscriptionStatus newValue) {
    logging.info('subscriptionStatusDidChange: $newValue');
  }

  @override
  void willDismissPaywall(PaywallInfo paywallInfo) {
    logging.info('willDismissPaywall: $paywallInfo');
  }

  @override
  void willPresentPaywall(PaywallInfo paywallInfo) {
    logging.info('willPresentPaywall: $paywallInfo');
  }

  @override
  void handleSuperwallDeepLink(Uri fullURL, List<String> pathComponents,
      Map<String, String> queryParameters) {
    logging.info('handleSuperwallDeepLink: $fullURL');
  }
}
