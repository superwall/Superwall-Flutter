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
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    bool useRevenueCat = true;

    super.initState();
    configureSuperwall(useRevenueCat);
    initPlatformState();
  }

  // Configure Superwall
  Future<void> configureSuperwall(bool useRevenueCat) async {
    try {
      // MARK: Step 1 - Create your Purchase Controller
      /// Create an `RCPurchaseController()` wherever Superwall and RevenueCat are being initialized.
      RCPurchaseController purchaseController = RCPurchaseController();

      // Get Superwall API Key
      String apiKey = Platform.isIOS ? "pk_5f6d9ae96b889bc2c36ca0f2368de2c4c3d5f6119aacd3d2" : "pk_d1f0959f70c761b1d55bb774a03e22b2b6ed290ce6561f85";

      Logging logging = Logging();
      logging.level = LogLevel.warn;
      logging.scopes = { LogScope.all };

      SuperwallOptions options = SuperwallOptions();
      options.logging = logging;

      // MARK: Step 2 - Configure Superwall
      /// Always configure Superwall first. Pass in the `purchaseController` you just created.
      Superwall.configure(
          apiKey,
          purchaseController: useRevenueCat ? purchaseController : null,
          options: options,
          completion: () {
            print("Executing Superwall configure completion block");
          }
      );

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // Method to call when the button is tapped
  Future<void> onRegisterTapped() async {
    try {
      PaywallPresentationHandler handler = PaywallPresentationHandler();
      handler.onPresent((paywallInfo) async {
        String name = await paywallInfo.name;
        print("Handler (onPresent): $name");
      });
      handler.onDismiss((paywallInfo) async {
        String name = await paywallInfo.name;
        print("Handler (onDismiss): $name");
      });
      handler.onError((error) {
        print("Handler (onError): ${error}");
      });
      handler.onSkip((skipReason) {
        handleSkipReason(skipReason);
      });

      Superwall.shared.registerEvent(
        'flutter',
        params: null,
        handler: handler,
        feature: () {
          print("Executing feature block");
          performFeatureBlockActions();
        }
      );
      print('Register method called successfully.');
    } catch (e) {
      // Handle any errors that occur during registration
      print('Failed to call register method: $e');
    }
  }

  Future<void> performFeatureBlockActions() async {
    PaywallInfo? paywallInfo = await Superwall.shared.getLatestPaywallInfo();

    if (paywallInfo != null) {
      String? identifier = await paywallInfo.identifier;
      print("Identifier: $identifier");

      Experiment? experiment = await paywallInfo.experiment;
      print("Experiment: $experiment");

      String? triggerSessionId = await paywallInfo.triggerSessionId;
      print("Trigger Session ID: $triggerSessionId");

      List<Product> products = await paywallInfo.products;
      print("Products: $products");

      List<String> productIds = await paywallInfo.productIds;
      print("Product IDs: $productIds");

      String name = await paywallInfo.name;
      print("Name: $name");

      String url = await paywallInfo.url;
      print("URL: $url");

      String? presentedByEventWithName = await paywallInfo.presentedByEventWithName;
      print("Presented By Event With Name: $presentedByEventWithName");

      String? presentedByEventWithId = await paywallInfo.presentedByEventWithId;
      print("Presented By Event With Id: $presentedByEventWithId");

      String? presentedByEventAt = await paywallInfo.presentedByEventAt;
      print("Presented By Event At: $presentedByEventAt");

      String presentedBy = await paywallInfo.presentedBy;
      print("Presented By: $presentedBy");

      String? presentationSourceType = await paywallInfo.presentationSourceType;
      print("Presentation Source Type: $presentationSourceType");

      String? responseLoadStartTime = await paywallInfo.responseLoadStartTime;
      print("Response Load Start Time: $responseLoadStartTime");

      String? responseLoadCompleteTime = await paywallInfo.responseLoadCompleteTime;
      print("Response Load Complete Time: $responseLoadCompleteTime");

      String? responseLoadFailTime = await paywallInfo.responseLoadFailTime;
      print("Response Load Fail Time: $responseLoadFailTime");

      double? responseLoadDuration = await paywallInfo.responseLoadDuration;
      print("Response Load Duration: $responseLoadDuration");

      String? webViewLoadStartTime = await paywallInfo.webViewLoadStartTime;
      print("Web View Load Start Time: $webViewLoadStartTime");

      String? webViewLoadCompleteTime = await paywallInfo.webViewLoadCompleteTime;
      print("Web View Load Complete Time: $webViewLoadCompleteTime");

      String? webViewLoadFailTime = await paywallInfo.webViewLoadFailTime;
      print("Web View Load Fail Time: $webViewLoadFailTime");

      double? webViewLoadDuration = await paywallInfo.webViewLoadDuration;
      print("Web View Load Duration: $webViewLoadDuration");

      String? productsLoadStartTime = await paywallInfo.productsLoadStartTime;
      print("Products Load Start Time: $productsLoadStartTime");

      String? productsLoadCompleteTime = await paywallInfo.productsLoadCompleteTime;
      print("Products Load Complete Time: $productsLoadCompleteTime");

      String? productsLoadFailTime = await paywallInfo.productsLoadFailTime;
      print("Products Load Fail Time: $productsLoadFailTime");

      double? productsLoadDuration = await paywallInfo.productsLoadDuration;
      print("Products Load Duration: $productsLoadDuration");

      String? paywalljsVersion = await paywallInfo.paywalljsVersion;
      print("Paywall.js Version: $paywalljsVersion");

      bool isFreeTrialAvailable = await paywallInfo.isFreeTrialAvailable;
      print("Is Free Trial Available: $isFreeTrialAvailable");

      FeatureGatingBehavior featureGatingBehavior = await paywallInfo.featureGatingBehavior;
      print("Feature Gating Behavior: $featureGatingBehavior");

      PaywallCloseReason closeReason = await paywallInfo.closeReason;
      print("Close Reason: $closeReason");

      List<LocalNotification> localNotifications = await paywallInfo.localNotifications;
      print("Local Notifications: $localNotifications");

      List<ComputedPropertyRequest> computedPropertyRequests = await paywallInfo.computedPropertyRequests;
      print("Computed Property Requests: $computedPropertyRequests");

      List<Survey> surveys = await paywallInfo.surveys;
      print("Surveys: $surveys");
    } else {
      print("Paywall Info is null");
    }
  }

  Future<void> performAction() async {
    try {
      IdentityOptions options = IdentityOptions(restorePaywallAssignments: true);
      await Superwall.shared.identify("123456");

      String userId = await Superwall.shared.getUserId();
      print(userId);

      await Superwall.shared.setUserAttributes({"someAttribute": "someValue"});
      Map<String, dynamic> attributes1 = await Superwall.shared.getUserAttributes();
      print(attributes1);

      await Superwall.shared.setUserAttributes({"jack": "lost", "kate": "antman"});
      Map<String, dynamic> attributes2 = await Superwall.shared.getUserAttributes();
      print(attributes2);

      await Superwall.shared.setUserAttributes({"jack": "123", "kate": {"tv": "series"}});
      Map<String, dynamic> attributes3 = await Superwall.shared.getUserAttributes();
      print(attributes3);

      await Superwall.shared.reset();

      Map<String, dynamic> attributes4 = await Superwall.shared.getUserAttributes();
      print(attributes4);

      Superwall.shared.setLogLevel(LogLevel.error);
      LogLevel logLevel = await Superwall.shared.getLogLevel();
      print("Log Level: $logLevel");

    } catch (e) {
      print('Failed perform action: $e');
    }
  }

  void handleSkipReason(PaywallSkippedReason skipReason) async {
    final description = await skipReason.description;

    if (skipReason is PaywallSkippedReasonHoldout) {
      final experiment = await skipReason.experiment;
      final experimentId = await experiment.id;
      print("Holdout with experiment: ${experimentId}");
      print("Handler (onSkip): $description");
    } else if (skipReason is PaywallSkippedReasonNoRuleMatch) {
      print("Handler (onSkip): $description");
    } else if (skipReason is PaywallSkippedReasonEventNotFound) {
      print("Handler (onSkip): $description");
    } else if (skipReason is PaywallSkippedReasonUserIsSubscribed) {
      print("Handler (onSkip): $description");
    } else {
      print("Handler (onSkip): Unknown skip reason");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter superapp'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Running'),
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
  }

  @override
  void didDismissPaywall(PaywallInfo paywallInfo) {
    print("didDismissPaywall: $paywallInfo");
  }

  @override
  void didPresentPaywall(PaywallInfo paywallInfo) {
    print("didPresentPaywall: $paywallInfo");
  }

  @override
  void handleCustomPaywallAction(String name) {
    print("handleCustomPaywallAction: $name");
  }

  @override
  void handleLog(String level, String scope, String? message, Map<String, dynamic>? info, String error) {
    // TODO: implement handleLog
  }

  @override
  void handleSuperwallEvent(SuperwallEventInfo eventInfo) {
    print("handleSuperwallEvent: $eventInfo");
    print("[EVENTINFO] B");
  }

  @override
  void paywallWillOpenDeepLink(Uri url) {
    print("paywallWillOpenDeepLink: $url");
  }

  @override
  void paywallWillOpenURL(Uri url) {
    print("paywallWillOpenURL: $url");
  }

  @override
  void subscriptionStatusDidChange(SubscriptionStatus newValue) {
    print("subscriptionStatusDidChange: $newValue");
  }

  @override
  void willDismissPaywall(PaywallInfo paywallInfo) {
    print("willDismissPaywall: $paywallInfo");
  }

  @override
  void willPresentPaywall(PaywallInfo paywallInfo) {
    printSubscriptionStatus();
    print("willPresentPaywall: $paywallInfo");
  }

  void printSubscriptionStatus() async {
    final status = await Superwall.shared.getSubscriptionStatus();
    final description = await status.description;

    print("Status: $description");
  }
}
