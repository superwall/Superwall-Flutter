import 'dart:io';

import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'RCPurchaseController.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements SuperwallDelegate {
  final logging = Logging();

  @override
  void initState() {
    const useRevenueCat = true;

    super.initState();
    configureSuperwall(useRevenueCat);
  }

  // Configure Superwall
  Future<void> configureSuperwall(bool useRevenueCat) async {
    try {
      // MARK: Step 1 - Create your Purchase Controller
      /// Create an `RCPurchaseController()` wherever Superwall and RevenueCat are being initialized.
      final purchaseController = RCPurchaseController();

      // Get Superwall API Key
      final apiKey = Platform.isIOS
          ? 'pk_5f6d9ae96b889bc2c36ca0f2368de2c4c3d5f6119aacd3d2'
          : 'pk_d1f0959f70c761b1d55bb774a03e22b2b6ed290ce6561f85';

      final logging = Logging();
      logging.level = LogLevel.warn;
      logging.scopes = {LogScope.all};

      final options = SuperwallOptions();
      options.paywalls.shouldPreload = false;
      // options.logging = logging;

      // MARK: Step 2 - Configure Superwall
      /// Always configure Superwall first. Pass in the `purchaseController` you just created.
      Superwall.configure(apiKey,
          purchaseController: useRevenueCat ? purchaseController : null,
          options: options, completion: () {
        logging.info('Executing Superwall configure completion block');
      });

      Superwall.shared.setDelegate(this);

      // MARK: Step 3 – Configure RevenueCat and Sync Subscription Status
      /// Always configure RevenueCat after Superwall and keep Superwall's
      /// subscription status up-to-date with RevenueCat's.
      if (useRevenueCat) {
        await purchaseController.configureAndSyncSubscriptionStatus();
      }
    } catch (e) {
      // Handle any errors that occur during configuration
      logging.error('Failed to configure Superwall:', e);
    }
  }

  // Method to call when the button is tapped
  Future<void> onRegisterTapped() async {
    try {
      final handler = PaywallPresentationHandler();
      handler
        ..onPresent((paywallInfo) async {
          final name = await paywallInfo.name;
          logging.info('Handler (onPresent): $name');
        })
        ..onDismiss((paywallInfo) async {
          final name = await paywallInfo.name;
          logging.info('Handler (onDismiss): $name');
        })
        ..onError((error) {
          logging.error('Handler (onError):', error);
        })
        ..onSkip(handleSkipReason);

      Superwall.shared.registerEvent('flutter', handler: handler, feature: () {
        logging.info('Executing feature block');
        performFeatureBlockActions();
      });
      logging.info('Register method called successfully.');
    } catch (e) {
      // Handle any errors that occur during registration
      logging.error('Failed to call register method:', e);
    }
  }

  Future<void> performFeatureBlockActions() async {
    final paywallInfo = await Superwall.shared.getLatestPaywallInfo();

    if (paywallInfo != null) {
      final identifier = await paywallInfo.identifier;
      logging.info('Identifier: $identifier');

      final experiment = await paywallInfo.experiment;
      logging.info('Experiment: $experiment');

      final triggerSessionId = await paywallInfo.triggerSessionId;
      logging.info('Trigger Session ID: $triggerSessionId');

      final products = await paywallInfo.products;
      logging.info('Products: $products');

      final productIds = await paywallInfo.productIds;
      logging.info('Product IDs: $productIds');

      final name = await paywallInfo.name;
      logging.info('Name: $name');

      final url = await paywallInfo.url;
      logging.info('URL: $url');

      final presentedByEventWithName =
          await paywallInfo.presentedByEventWithName;
      logging.info('Presented By Event With Name: $presentedByEventWithName');

      final presentedByEventWithId = await paywallInfo.presentedByEventWithId;
      logging.info('Presented By Event With Id: $presentedByEventWithId');

      final presentedByEventAt = await paywallInfo.presentedByEventAt;
      logging.info('Presented By Event At: $presentedByEventAt');

      final presentedBy = await paywallInfo.presentedBy;
      logging.info('Presented By: $presentedBy');

      final presentationSourceType = await paywallInfo.presentationSourceType;
      logging.info('Presentation Source Type: $presentationSourceType');

      final responseLoadStartTime = await paywallInfo.responseLoadStartTime;
      logging.info('Response Load Start Time: $responseLoadStartTime');

      final responseLoadCompleteTime =
          await paywallInfo.responseLoadCompleteTime;
      logging.info('Response Load Complete Time: $responseLoadCompleteTime');

      final responseLoadFailTime = await paywallInfo.responseLoadFailTime;
      logging.info('Response Load Fail Time: $responseLoadFailTime');

      final responseLoadDuration = await paywallInfo.responseLoadDuration;
      logging.info('Response Load Duration: $responseLoadDuration');

      final webViewLoadStartTime = await paywallInfo.webViewLoadStartTime;
      logging.info('Web View Load Start Time: $webViewLoadStartTime');

      final webViewLoadCompleteTime = await paywallInfo.webViewLoadCompleteTime;
      logging.info('Web View Load Complete Time: $webViewLoadCompleteTime');

      final webViewLoadFailTime = await paywallInfo.webViewLoadFailTime;
      logging.info('Web View Load Fail Time: $webViewLoadFailTime');

      final webViewLoadDuration = await paywallInfo.webViewLoadDuration;
      logging.info('Web View Load Duration: $webViewLoadDuration');

      final productsLoadStartTime = await paywallInfo.productsLoadStartTime;
      logging.info('Products Load Start Time: $productsLoadStartTime');

      final productsLoadCompleteTime =
          await paywallInfo.productsLoadCompleteTime;
      logging.info('Products Load Complete Time: $productsLoadCompleteTime');

      final productsLoadFailTime = await paywallInfo.productsLoadFailTime;
      logging.info('Products Load Fail Time: $productsLoadFailTime');

      final productsLoadDuration = await paywallInfo.productsLoadDuration;
      logging.info('Products Load Duration: $productsLoadDuration');

      final paywalljsVersion = await paywallInfo.paywalljsVersion;
      logging.info('Paywall.js Version: $paywalljsVersion');

      final isFreeTrialAvailable = await paywallInfo.isFreeTrialAvailable;
      logging.info('Is Free Trial Available: $isFreeTrialAvailable');

      final featureGatingBehavior = await paywallInfo.featureGatingBehavior;
      logging.info('Feature Gating Behavior: $featureGatingBehavior');

      final closeReason = await paywallInfo.closeReason;
      logging.info('Close Reason: $closeReason');

      final localNotifications = await paywallInfo.localNotifications;
      logging.info('Local Notifications: $localNotifications');

      final computedPropertyRequests =
          await paywallInfo.computedPropertyRequests;
      logging.info('Computed Property Requests: $computedPropertyRequests');

      final surveys = await paywallInfo.surveys;
      logging.info('Surveys: $surveys');
    } else {
      logging.info('Paywall Info is null');
    }
  }

  Future<void> performAction() async {
    try {
      await Superwall.shared.identify('123456');

      final userId = await Superwall.shared.getUserId();
      logging.info(userId);

      await Superwall.shared.setUserAttributes({'someAttribute': 'someValue'});
      final attributes1 = await Superwall.shared.getUserAttributes();
      logging.info('$attributes1}');

      await Superwall.shared
          .setUserAttributes({'jack': 'lost', 'kate': 'antman'});
      final attributes2 = await Superwall.shared.getUserAttributes();
      logging.info('$attributes2}');

      await Superwall.shared.setUserAttributes({
        'jack': '123',
        'kate': {'tv': 'series'}
      });
      final attributes3 = await Superwall.shared.getUserAttributes();
      logging.info('$attributes3');

      await Superwall.shared.reset();

      final attributes4 = await Superwall.shared.getUserAttributes();
      logging.info('$attributes4');

      Superwall.shared.setLogLevel(LogLevel.error);
      final logLevel = await Superwall.shared.getLogLevel();
      logging.info('Log Level: $logLevel');
    } catch (e) {
      logging.error('Failed perform action:', e);
    }
  }

  Future<void> handleSkipReason(PaywallSkippedReason skipReason) async {
    final description = await skipReason.description;

    if (skipReason is PaywallSkippedReasonHoldout) {
      final experiment = await skipReason.experiment;
      final experimentId = await experiment.id;
      logging.info('Holdout with experiment: $experimentId');
      logging.info('Handler (onSkip): $description');
    } else if (skipReason is PaywallSkippedReasonNoRuleMatch) {
      logging.info('Handler (onSkip): $description');
    } else if (skipReason is PaywallSkippedReasonEventNotFound) {
      logging.info('Handler (onSkip): $description');
    } else if (skipReason is PaywallSkippedReasonUserIsSubscribed) {
      logging.info('Handler (onSkip): $description');
    } else {
      logging.info('Handler (onSkip): Unknown skip reason');
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter superapp'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Running'),
                ElevatedButton(
                  onPressed: onRegisterTapped,
                  child: const Text('Register event'),
                ),
                ElevatedButton(
                  onPressed: performAction,
                  child: const Text('Perform action'),
                ),
              ],
            ),
          ),
        ),
      );

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
    printSubscriptionStatus();
    logging.info('willPresentPaywall: $paywallInfo');
  }

  Future<void> printSubscriptionStatus() async {
    final status = await Superwall.shared.getSubscriptionStatus();
    final description = await status.description;

    logging.info('Status: $description');
  }
}
