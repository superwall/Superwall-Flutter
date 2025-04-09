import 'dart:io';
import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'RCPurchaseController.dart';
import 'TestingPurchaseController.dart';

class SubscriptionStatusTest extends StatelessWidget {
  // Function to show configuration completion dialog

// Home screen with buttons to trigger Superwall events and navigation.
  @override
  Widget build(BuildContext context) {
    void _showSubscriptionStatusDialog(SubscriptionStatus status) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Builder(
              builder: (context) {
                if (status is SubscriptionStatusActive) {
                  return Text(
                      'Subscription status: Active - Entitlements: ${status.entitlements.map((e) => e.id).join(", ")}');
                } else if (status is SubscriptionStatusInactive) {
                  return Text('Subscription status: Inactive');
                } else if (status is SubscriptionStatusUnknown) {
                  return Text('Subscription status: Unknown');
                } else {
                  return Text('Subscription status: $status');
                }
              },
            ),
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
        title: Text('Subscription Status Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Set Subscription Status Active'),
              onPressed: () async {
                // Create active subscription status with pro and test_entitlement
                final activeStatus = SubscriptionStatusActive(
                  entitlements: {
                    Entitlement(id: 'pro'),
                    Entitlement(id: 'test_entitlement'),
                  },
                );

                // Set the subscription status
                await Superwall.shared.setSubscriptionStatus(activeStatus);

                // Show dialog with the status
                _showSubscriptionStatusDialog(activeStatus);
              },
            ),
            ElevatedButton(
              child: Text('Set Subscription Status Inactive'),
              onPressed: () async {
                // Create inactive subscription status
                final inactiveStatus = SubscriptionStatusInactive();

                // Set the subscription status
                await Superwall.shared.setSubscriptionStatus(inactiveStatus);

                // Show dialog with the status
                _showSubscriptionStatusDialog(inactiveStatus);
              },
            ),
            ElevatedButton(
              child: Text('Set Subscription Status Unknown'),
              onPressed: () async {
                // Create unknown subscription status
                final unknownStatus = SubscriptionStatusUnknown();

                // Set the subscription status
                await Superwall.shared.setSubscriptionStatus(unknownStatus);

                // Show dialog with the status
                _showSubscriptionStatusDialog(unknownStatus);
              },
            ),
          ],
        ),
      ),
    );
  }
}
