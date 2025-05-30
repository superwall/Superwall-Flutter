import 'dart:io';
import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'TestingPurchaseController.dart';

class PurchaseControllerTest extends StatefulWidget {
  @override
  _PurchaseControllerTestState createState() => _PurchaseControllerTestState();
}

class _PurchaseControllerTestState extends State<PurchaseControllerTest> {
  bool isConfigured = false;
  final apiKey = Platform.isIOS
      ? 'pk_25605698906751f5383385f9976e21f840d44aa11cd4639c'
      : 'pk_6d16c4c892b1e792490ab8bfe831f1ad96e7c18aee7a5257';
  TestingPurchaseController? purchaseController;
  // Function to show configuration completion dialog

  @override
  Widget build(BuildContext context) {
    if (purchaseController == null) {
      setState(() {
        purchaseController = TestingPurchaseController(context: context);
      });
    }

    // Function to show feature triggered dialog
    void _showFeatureDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Feature'),
            content: Text('Feature triggered'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mock PC Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Configure with PC'),
              onPressed: () async {
                // Create active subscription status with pro and test_entitlement
                final options = SuperwallOptions();
                options.paywalls.shouldPreload = false;

                Superwall.configure(apiKey,
                    purchaseController: purchaseController!,
                    options: options, completion: () {
                  Superwall.shared
                      .setSubscriptionStatus(SubscriptionStatusInactive());
                  setState(() {
                    isConfigured = true;
                  });
                });
              },
            ),
            ElevatedButton(
              child: Text('Configure without PC'),
              onPressed: () async {
                // Create active subscription status with pro and test_entitlement
                final options = SuperwallOptions();
                options.paywalls.shouldPreload = false;

                Superwall.configure(apiKey, options: options, completion: () {
                  Superwall.shared
                      .setSubscriptionStatus(SubscriptionStatusInactive());
                  setState(() {
                    isConfigured = true;
                  });
                });
              },
            ),
            if (isConfigured)
              ElevatedButton(
                child: Text('Trigger Paywall'),
                onPressed: () async {
                  await Superwall.shared.registerPlacement('campaign_trigger',
                      feature: () {
                    print("feature triggered");
                    _showFeatureDialog(context);
                  });
                },
              ),
            if (isConfigured)
              ElevatedButton(
                child: purchaseController!.rejectPurchase
                    ? Text('Enable purchases')
                    : Text('Disable purchases'),
                onPressed: () async {
                  purchaseController!.rejectPurchase =
                      !purchaseController!.rejectPurchase;
                  setState(() {});
                },
              ),
            if (isConfigured)
              ElevatedButton(
                child: purchaseController!.restorePurchase
                    ? Text('Disable restore')
                    : Text('Enable restore'),
                onPressed: () async {
                  purchaseController!.restorePurchase =
                      !purchaseController!.restorePurchase;
                  setState(() {});
                },
              ),
            if (isConfigured)
              ElevatedButton(
                child: Text('Reset status'),
                onPressed: () async {
                  await Superwall.shared
                      .setSubscriptionStatus(SubscriptionStatusInactive());
                },
              ),
          ],
        ),
      ),
    );
  }
}
