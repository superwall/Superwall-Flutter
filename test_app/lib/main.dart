import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:superwallkit_flutter_example/ConfigureTest.dart';
import 'package:superwallkit_flutter_example/DelegateTest.dart';
import 'package:superwallkit_flutter_example/HandlerTest.dart';
import 'package:superwallkit_flutter_example/PurchaseControllerTest.dart';
import 'package:superwallkit_flutter_example/SubscriptionStatusTest.dart';
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

  @override
  void initState() {
    super.initState();
  }

  void listenForPurchases() {
/*    _subscription = Superwall.shared.subscriptionStatus.listen((status) {
      logging.info('subscriptionStatusDidChange listener: $status');
    });*/
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Superwall Flutter Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/configureTest': (context) => ConfigureTest(),
          '/subscriptionStatusTest': (context) => SubscriptionStatusTest(),
          '/launchedFeature': (context) => LaunchedFeature(),
          '/purchaseControllerTest': (context) => PurchaseControllerTest(),
          '/delegateTest': (context) => DelegateTest(),
          '/handlerTest': (context) => HandlerTest(),
        },
      );
}
