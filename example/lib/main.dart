import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'MySuperwallDelegate.dart';
import 'RCPurchaseController.dart';
import 'home.dart';
import 'launchedFeature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final logging = Logging();
  StreamSubscription<SubscriptionStatus>? _subscription;
  final appLinks = AppLinks();
  @override
  void initState() {
    const useRevenueCat = true;

    super.initState();
    configureSuperwall(useRevenueCat);
  }

  void listenForPurchases() {
/*    _subscription = Superwall.shared.subscriptionStatus.listen((status) {
      logging.info('subscriptionStatusDidChange listener: $status');
    });*/
  }

  void _handleIncomingLinks() {
    appLinks.uriLinkStream.listen((Uri uri) {
      debugPrint('uri: $uri');
      Superwall.shared.handleDeepLink(uri);
    }, onError: (Object err) {
      print('Error receiving incoming link: $err');
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Configure Superwall
  Future<void> configureSuperwall(bool useRevenueCat) async {
    try {
      // MARK: Step 1 - Create your Purchase Controller
      /// Create an `RCPurchaseController()` wherever Superwall and RevenueCat are being initialized.
      final purchaseController = RCPurchaseController();
      final delegate = MySuperwallDelegate();

      // Get Superwall API Key
      final apiKey = Platform.isIOS
          ? 'pk_e361c8a9662281f4249f2fa11d1a63854615fa80e15e7a4d'
          : 'pk_d1f0959f70c761b1d55bb774a03e22b2b6ed290ce6561f85';

      final logging = Logging();
      logging.level = LogLevel.info;
      logging.scopes = {LogScope.all};

      final options = SuperwallOptions();
      options.paywalls.shouldPreload = false;
      options.paywalls.shouldShowWebRestorationAlert = false;
      // options.logging = logging;

      // MARK: Step 2 - Configure Superwall
      /// Always configure Superwall first. Pass in the `purchaseController` you just created.
      Superwall.configure(apiKey,
          purchaseController: useRevenueCat ? purchaseController : null,
          options: options, completion: () {
        logging.info('Executing Superwall configure completion block');
        print('Executing Superwall configure completion block');
        listenForPurchases();
      });
      _handleIncomingLinks();
      Superwall.shared.setDelegate(delegate);
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

  // // Method to call when the button is tapped
  // Future<void> onRegisterTapped() async {
  //   try {
  //     final handler = PaywallPresentationHandler();
  //     handler
  //       ..onPresent((paywallInfo) async {
  //         final name = await paywallInfo.name;
  //         logging.info('Handler (onPresent): $name');
  //       })
  //       ..onDismiss((paywallInfo) async {
  //         final name = await paywallInfo.name;
  //         logging.info('Handler (onDismiss): $name');
  //       })
  //       ..onError((error) {
  //         logging.error('Handler (onError):', error);
  //       })
  //       ..onSkip(handleSkipReason);

  //     Superwall.shared.registerPlacement('flutter', handler: handler,
  //         feature: () {
  //       logging.info('Executing feature block');
  //       performFeatureBlockActions();
  //     });
  //     logging.info('Register method called successfully.');
  //   } catch (e) {
  //     // Handle any errors that occur during registration
  //     logging.error('Failed to call register method:', e);
  //   }
  // }

  // Future<void> performFeatureBlockActions() async {
  //   final paywallInfo = await Superwall.shared.getLatestPaywallInfo();

  //   if (paywallInfo != null) {
  //     final identifier = await paywallInfo.identifier;
  //     logging.info('Identifier: $identifier');

  //     final experiment = await paywallInfo.experiment;
  //     logging.info('Experiment: $experiment');

  //     final products = await paywallInfo.products;
  //     logging.info('Products: $products');

  //     final productIds = await paywallInfo.productIds;
  //     logging.info('Product IDs: $productIds');

  //     final name = await paywallInfo.name;
  //     logging.info('Name: $name');

  //     final url = await paywallInfo.url;
  //     logging.info('URL: $url');

  //     final presentedByPlacementWithName =
  //         await paywallInfo.presentedByPlacementWithName;
  //     logging.info(
  //         'Presented By Placement With Name: $presentedByPlacementWithName');

  //     final presentedByPlacementWithId =
  //         await paywallInfo.presentedByPlacementWithId;
  //     logging
  //         .info('Presented By Placement With Id: $presentedByPlacementWithId');

  //     final presentedByPlacementAt = await paywallInfo.presentedByPlacementAt;
  //     logging.info('Presented By Placement At: $presentedByPlacementAt');

  //     final presentedBy = await paywallInfo.presentedBy;
  //     logging.info('Presented By: $presentedBy');

  //     final presentationSourceType = await paywallInfo.presentationSourceType;
  //     logging.info('Presentation Source Type: $presentationSourceType');

  //     final responseLoadStartTime = await paywallInfo.responseLoadStartTime;
  //     logging.info('Response Load Start Time: $responseLoadStartTime');

  //     final responseLoadCompleteTime =
  //         await paywallInfo.responseLoadCompleteTime;
  //     logging.info('Response Load Complete Time: $responseLoadCompleteTime');

  //     final responseLoadFailTime = await paywallInfo.responseLoadFailTime;
  //     logging.info('Response Load Fail Time: $responseLoadFailTime');

  //     final responseLoadDuration = await paywallInfo.responseLoadDuration;
  //     logging.info('Response Load Duration: $responseLoadDuration');

  //     final webViewLoadStartTime = await paywallInfo.webViewLoadStartTime;
  //     logging.info('Web View Load Start Time: $webViewLoadStartTime');

  //     final webViewLoadCompleteTime = await paywallInfo.webViewLoadCompleteTime;
  //     logging.info('Web View Load Complete Time: $webViewLoadCompleteTime');

  //     final webViewLoadFailTime = await paywallInfo.webViewLoadFailTime;
  //     logging.info('Web View Load Fail Time: $webViewLoadFailTime');

  //     final webViewLoadDuration = await paywallInfo.webViewLoadDuration;
  //     logging.info('Web View Load Duration: $webViewLoadDuration');

  //     final productsLoadStartTime = await paywallInfo.productsLoadStartTime;
  //     logging.info('Products Load Start Time: $productsLoadStartTime');

  //     final productsLoadCompleteTime =
  //         await paywallInfo.productsLoadCompleteTime;
  //     logging.info('Products Load Complete Time: $productsLoadCompleteTime');

  //     final productsLoadFailTime = await paywallInfo.productsLoadFailTime;
  //     logging.info('Products Load Fail Time: $productsLoadFailTime');

  //     final productsLoadDuration = await paywallInfo.productsLoadDuration;
  //     logging.info('Products Load Duration: $productsLoadDuration');

  //     final paywalljsVersion = await paywallInfo.paywalljsVersion;
  //     logging.info('Paywall.js Version: $paywalljsVersion');

  //     final isFreeTrialAvailable = await paywallInfo.isFreeTrialAvailable;
  //     logging.info('Is Free Trial Available: $isFreeTrialAvailable');

  //     final featureGatingBehavior = await paywallInfo.featureGatingBehavior;
  //     logging.info('Feature Gating Behavior: $featureGatingBehavior');

  //     final closeReason = await paywallInfo.closeReason;
  //     logging.info('Close Reason: $closeReason');

  //     final localNotifications = await paywallInfo.localNotifications;
  //     logging.info('Local Notifications: $localNotifications');

  //     final computedPropertyRequests =
  //         await paywallInfo.computedPropertyRequests;
  //     logging.info('Computed Property Requests: $computedPropertyRequests');

  //     final surveys = await paywallInfo.surveys;
  //     logging.info('Surveys: $surveys');
  //   } else {
  //     logging.info('Paywall Info is null');
  //   }
  // }

  // Future<void> performAction() async {
  //   try {
  //     await Superwall.shared.identify('123456');

  //     final userId = await Superwall.shared.getUserId();
  //     logging.info(userId);

  //     await Superwall.shared.setUserAttributes({'someAttribute': 'someValue'});
  //     final attributes1 = await Superwall.shared.getUserAttributes();
  //     logging.info('$attributes1}');

  //     await Superwall.shared
  //         .setUserAttributes({'jack': 'lost', 'kate': 'antman'});
  //     final attributes2 = await Superwall.shared.getUserAttributes();
  //     logging.info('$attributes2}');

  //     await Superwall.shared.setUserAttributes({
  //       'jack': '123',
  //       'kate': {'tv': 'series'}
  //     });
  //     final attributes3 = await Superwall.shared.getUserAttributes();
  //     logging.info('$attributes3');

  //     await Superwall.shared.reset();

  //     final attributes4 = await Superwall.shared.getUserAttributes();
  //     logging.info('$attributes4');

  //     Superwall.shared.setLogLevel(LogLevel.error);
  //     final logLevel = await Superwall.shared.getLogLevel();
  //     logging.info('Log Level: $logLevel');
  //   } catch (e) {
  //     logging.error('Failed perform action:', e);
  //   }
  // }

  // Future<void> handleSkipReason(PaywallSkippedReason skipReason) async {
  //   final description = await skipReason.description;

  //   if (skipReason is PaywallSkippedReasonHoldout) {
  //     final experiment = await skipReason.experiment;
  //     final experimentId = await experiment.id;
  //     logging.info('Holdout with experiment: $experimentId');
  //     logging.info('Handler (onSkip): $description');
  //   } else if (skipReason is PaywallSkippedReasonNoAudienceMatch) {
  //     logging.info('Handler (onSkip): $description');
  //   } else if (skipReason is PaywallSkippedReasonPlacementNotFound) {
  //     logging.info('Handler (onSkip): $description');
  //   } else {
  //     logging.info('Handler (onSkip): Unknown skip reason');
  //   }
  // }

  // @override
  // Widget build(BuildContext context) => MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       home: Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Flutter superapp'),
  //         ),
  //         body: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               const Text('Running'),
  //               ElevatedButton(
  //                 onPressed: onRegisterTapped,
  //                 child: const Text('Register placement'),
  //               ),
  //               ElevatedButton(
  //                 onPressed: performAction,
  //                 child: const Text('Perform action'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Superwall Flutter Demo',
        initialRoute: '/',
        routes: {
          // Home screen is the default route.
          '/': (context) => const Home(),
          // LaunchedFeature route receives a string argument.
          '/launchedFeature': (context) => const LaunchedFeature(),
        },
      );
}
