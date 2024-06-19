import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:superwallkit_flutter_example/RCPurchaseController.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements SuperwallDelegate {
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
      String apiKey = Platform.isIOS
          ? "pk_5f6d9ae96b889bc2c36ca0f2368de2c4c3d5f6119aacd3d2"
          : "pk_d1f0959f70c761b1d55bb774a03e22b2b6ed290ce6561f85";

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
        print('Executing Superwall configure completion block');
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
      print('Failed to configure Superwall: $e');
    }
  }

  // Method to call when the button is tapped
  Future<void> onRegisterTapped() async {
    try {
      final handler = PaywallPresentationHandler();
      handler
        ..onPresent((paywallInfo) async {
          final name = await paywallInfo.name;
          print('Handler (onPresent): $name');
        })
        ..onDismiss((paywallInfo) async {
          final name = await paywallInfo.name;
          print('Handler (onDismiss): $name');
        })
        ..onError((error) {
          print('Handler (onError): $error');
        })
        ..onSkip(handleSkipReason);

      Superwall.shared.registerEvent('flutter', handler: handler, feature: () {
        print('Executing feature block');
        performFeatureBlockActions();
      });
      print('Register method called successfully.');
    } catch (e) {
      // Handle any errors that occur during registration
      print('Failed to call register method: $e');
    }
  }

  Future<void> performFeatureBlockActions() async {
    final paywallInfo = await Superwall.shared.getLatestPaywallInfo();

    if (paywallInfo != null) {
      final identifier = await paywallInfo.identifier;
      print('Identifier: $identifier');

      final experiment = await paywallInfo.experiment;
      print('Experiment: $experiment');

      final triggerSessionId = await paywallInfo.triggerSessionId;
      print('Trigger Session ID: $triggerSessionId');

      final products = await paywallInfo.products;
      print('Products: $products');

      final productIds = await paywallInfo.productIds;
      print('Product IDs: $productIds');

      final name = await paywallInfo.name;
      print('Name: $name');

      final url = await paywallInfo.url;
      print('URL: $url');

      final presentedByEventWithName =
          await paywallInfo.presentedByEventWithName;
      print('Presented By Event With Name: $presentedByEventWithName');

      final presentedByEventWithId = await paywallInfo.presentedByEventWithId;
      print('Presented By Event With Id: $presentedByEventWithId');

      final presentedByEventAt = await paywallInfo.presentedByEventAt;
      print('Presented By Event At: $presentedByEventAt');

      final presentedBy = await paywallInfo.presentedBy;
      print('Presented By: $presentedBy');

      final presentationSourceType = await paywallInfo.presentationSourceType;
      print('Presentation Source Type: $presentationSourceType');

      final responseLoadStartTime = await paywallInfo.responseLoadStartTime;
      print('Response Load Start Time: $responseLoadStartTime');

      final responseLoadCompleteTime =
          await paywallInfo.responseLoadCompleteTime;
      print('Response Load Complete Time: $responseLoadCompleteTime');

      final responseLoadFailTime = await paywallInfo.responseLoadFailTime;
      print('Response Load Fail Time: $responseLoadFailTime');

      final responseLoadDuration = await paywallInfo.responseLoadDuration;
      print('Response Load Duration: $responseLoadDuration');

      final webViewLoadStartTime = await paywallInfo.webViewLoadStartTime;
      print('Web View Load Start Time: $webViewLoadStartTime');

      final webViewLoadCompleteTime = await paywallInfo.webViewLoadCompleteTime;
      print('Web View Load Complete Time: $webViewLoadCompleteTime');

      final webViewLoadFailTime = await paywallInfo.webViewLoadFailTime;
      print('Web View Load Fail Time: $webViewLoadFailTime');

      final webViewLoadDuration = await paywallInfo.webViewLoadDuration;
      print('Web View Load Duration: $webViewLoadDuration');

      final productsLoadStartTime = await paywallInfo.productsLoadStartTime;
      print('Products Load Start Time: $productsLoadStartTime');

      final productsLoadCompleteTime =
          await paywallInfo.productsLoadCompleteTime;
      print('Products Load Complete Time: $productsLoadCompleteTime');

      final productsLoadFailTime = await paywallInfo.productsLoadFailTime;
      print('Products Load Fail Time: $productsLoadFailTime');

      final productsLoadDuration = await paywallInfo.productsLoadDuration;
      print('Products Load Duration: $productsLoadDuration');

      final paywalljsVersion = await paywallInfo.paywalljsVersion;
      print('Paywall.js Version: $paywalljsVersion');

      final isFreeTrialAvailable = await paywallInfo.isFreeTrialAvailable;
      print('Is Free Trial Available: $isFreeTrialAvailable');

      final featureGatingBehavior = await paywallInfo.featureGatingBehavior;
      print('Feature Gating Behavior: $featureGatingBehavior');

      final closeReason = await paywallInfo.closeReason;
      print('Close Reason: $closeReason');

      final localNotifications = await paywallInfo.localNotifications;
      print('Local Notifications: $localNotifications');

      final computedPropertyRequests =
          await paywallInfo.computedPropertyRequests;
      print('Computed Property Requests: $computedPropertyRequests');

      final surveys = await paywallInfo.surveys;
      print('Surveys: $surveys');
    } else {
      print('Paywall Info is null');
    }
  }

  Future<void> performAction() async {
    try {
      await Superwall.shared.identify('123456');

      final userId = await Superwall.shared.getUserId();
      print(userId);

      await Superwall.shared.setUserAttributes({'someAttribute': 'someValue'});
      final attributes1 = await Superwall.shared.getUserAttributes();
      print(attributes1);

      await Superwall.shared
          .setUserAttributes({'jack': 'lost', 'kate': 'antman'});
      final attributes2 = await Superwall.shared.getUserAttributes();
      print(attributes2);

      await Superwall.shared.setUserAttributes({
        'jack': '123',
        'kate': {'tv': 'series'}
      });
      final attributes3 = await Superwall.shared.getUserAttributes();
      print(attributes3);

      await Superwall.shared.reset();

      final attributes4 = await Superwall.shared.getUserAttributes();
      print(attributes4);

      Superwall.shared.setLogLevel(LogLevel.error);
      final logLevel = await Superwall.shared.getLogLevel();
      print('Log Level: $logLevel');
    } catch (e) {
      print('Failed perform action: $e');
    }
  }

  Future<void> handleSkipReason(PaywallSkippedReason skipReason) async {
    final description = await skipReason.description;

    if (skipReason is PaywallSkippedReasonHoldout) {
      final experiment = await skipReason.experiment;
      final experimentId = await experiment.id;
      print('Holdout with experiment: $experimentId');
      print('Handler (onSkip): $description');
    } else if (skipReason is PaywallSkippedReasonNoRuleMatch) {
      print('Handler (onSkip): $description');
    } else if (skipReason is PaywallSkippedReasonEventNotFound) {
      print('Handler (onSkip): $description');
    } else if (skipReason is PaywallSkippedReasonUserIsSubscribed) {
      print('Handler (onSkip): $description');
    } else {
      print('Handler (onSkip): Unknown skip reason');
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
    print('didDismissPaywall: $paywallInfo');
  }

  @override
  void didPresentPaywall(PaywallInfo paywallInfo) {
    print('didPresentPaywall: $paywallInfo');
  }

  @override
  void handleCustomPaywallAction(String name) {
    print('handleCustomPaywallAction: $name');
  }

  @override
  void handleLog(String level, String scope, String? message,
      Map<dynamic, dynamic>? info, String? error) {
    // print("handleLog: $level, $scope, $message, $info, $error");
  }

  @override
  void handleSuperwallEvent(SuperwallEventInfo eventInfo) async {
    // This delegate function is noisy. Uncomment to debug.
    return;

    print('handleSuperwallEvent: $eventInfo');

    switch (eventInfo.event.type) {
      case EventType.appOpen:
        print('appOpen event');
      case EventType.deviceAttributes:
        print('deviceAttributes event: ${eventInfo.event.deviceAttributes} ');
      case EventType.paywallOpen:
        final paywallInfo = eventInfo.event.paywallInfo;
        print('paywallOpen event: $paywallInfo ');

        if (paywallInfo != null) {
          final identifier = await paywallInfo.identifier;
          print('paywallInfo.identifier: $identifier ');

          final productIds = await paywallInfo.productIds;
          print('paywallInfo.productIds: $productIds ');
        }
      default:
        break;
    }
  }

  @override
  void paywallWillOpenDeepLink(Uri url) {
    print('paywallWillOpenDeepLink: $url');
  }

  @override
  void paywallWillOpenURL(Uri url) {
    print('paywallWillOpenURL: $url');
  }

  @override
  void subscriptionStatusDidChange(SubscriptionStatus newValue) {
    print('subscriptionStatusDidChange: $newValue');
  }

  @override
  void willDismissPaywall(PaywallInfo paywallInfo) {
    print('willDismissPaywall: $paywallInfo');
  }

  @override
  void willPresentPaywall(PaywallInfo paywallInfo) {
    printSubscriptionStatus();
    print('willPresentPaywall: $paywallInfo');
  }

  Future<void> printSubscriptionStatus() async {
    final status = await Superwall.shared.getSubscriptionStatus();
    final description = await status.description;

    print('Status: $description');
  }
}
