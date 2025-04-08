import 'dart:io';
import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'RCPurchaseController.dart';
import 'TestingPurchaseController.dart';

class ConfigureTest extends StatelessWidget {
  final apiKey = Platform.isIOS
      ? 'pk_e361c8a9662281f4249f2fa11d1a63854615fa80e15e7a4d'
      : 'pk_6d16c4c892b1e792490ab8bfe831f1ad96e7c18aee7a5257';

  final logging = Logging();

  final options = SuperwallOptions();

  // Function to show configuration completion dialog
  void _showConfigurationCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Configuration completed'),
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

// Home screen with buttons to trigger Superwall events and navigation.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('ConfigureTest'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SuperwallBuilder(
                  builder: (context, status) => Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            Text('Configuration Status: ${status}'),
                          ]))),
              ElevatedButton(
                // Launch Non-Gated Feature.
                child: Text('Configure with dialog shown + PC'),
                onPressed: () async {
                  options.paywalls.shouldPreload = false;

                  // Get Superwall API Key
                  // options.logging = logging;

                  // MARK: Step 2 - Configure Superwall
                  /// Always configure Superwall first. Pass in the `purchaseController` you just created.
                  final purchaseController =
                      TestingPurchaseController(context: context);
                  Superwall.configure(apiKey,
                      purchaseController: purchaseController,
                      options: options, completion: () {
                    _showConfigurationCompletedDialog(context);
                  });
                },
              ),
              ElevatedButton(
                // Launch Pro Feature.
                child: Text('Configure with dialog shown + no PC'),
                onPressed: () async {
                  Superwall.configure(apiKey, options: options, completion: () {
                    _showConfigurationCompletedDialog(context);
                  });
                },
              ),
              ElevatedButton(
                // Launch Diamond Feature.
                child: Text('Configure with dialog shown and RC'),
                onPressed: () async {
                  final purchaseController = RCPurchaseController();

                  Superwall.configure(apiKey,
                      purchaseController: purchaseController,
                      options: options, completion: () {
                    _showConfigurationCompletedDialog(context);
                  });
                },
              ),
              ElevatedButton(
                // Identify action.
                child: Text('Just configure'),
                onPressed: () {
                  Superwall.configure(apiKey,
                      options: options, completion: () {});
                },
              ),
            ],
          ),
        ),
      );
}
