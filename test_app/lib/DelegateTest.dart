import 'dart:io';
import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'RCPurchaseController.dart';
import 'TestingPurchaseController.dart';
import 'delegate/TestDelegate.dart';
import 'delegate/TestDelegateEvent.dart';

class DelegateTest extends StatefulWidget {
  @override
  _DelegateTestState createState() => _DelegateTestState();
}

class _DelegateTestState extends State<DelegateTest> {
  final TestDelegate testDelegate = TestDelegate();

  void _showDelegateEventsListDialog(List<TestDelegateEvent> eventsList) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delegate Events'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: eventsList.length,
            itemBuilder: (context, index) {
              final event = eventsList[index];
              String eventName = '';

              if (event is DidDismissPaywallEvent) {
                eventName = 'DidDismissPaywall';
              } else if (event is DidPresentPaywallEvent) {
                eventName = 'DidPresentPaywall';
              } else if (event is HandleCustomPaywallActionEvent) {
                eventName = 'HandleCustomPaywallAction';
              } else if (event is HandleLogEvent) {
                eventName = 'HandleLog';
              } else if (event is HandleSuperwallEventEvent) {
                eventName = 'HandleSuperwallEvent';
              } else if (event is PaywallWillOpenDeepLinkEvent) {
                eventName = 'PaywallWillOpenDeepLink';
              } else if (event is PaywallWillOpenURLEvent) {
                eventName = 'PaywallWillOpenURL';
              } else if (event is SubscriptionStatusDidChangeEvent) {
                eventName = 'SubscriptionStatusDidChange';
              } else if (event is WillDismissPaywallEvent) {
                eventName = 'WillDismissPaywall';
              } else if (event is WillPresentPaywallEvent) {
                eventName = 'WillPresentPaywall';
              }

              return ListTile(
                title: Text('Event ${index + 1}: $eventName'),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Delegate Test'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Set Test Delegate'),
                  onPressed: () async {
                    Superwall.shared.setDelegate(testDelegate);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Test delegate set')),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Show Paywall'),
                  onPressed: () async {
                    await Superwall.shared.registerPlacement(
                      "campaign_trigger",
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Change Subscription Status'),
                  onPressed: () async {
                    final activeStatus = SubscriptionStatusActive(
                      entitlements: {
                        Entitlement(id: 'pro'),
                        Entitlement(id: 'test_entitlement'),
                      },
                    );
                    await Superwall.shared.setSubscriptionStatus(activeStatus);
                  },
                ),
                ElevatedButton(
                  child: Text('Clear Delegate and Change Status'),
                  onPressed: () async {
                    testDelegate.events.clear();
                    Superwall.shared.setDelegate(null);
                    final inactiveStatus = SubscriptionStatusInactive();
                    await Superwall.shared
                        .setSubscriptionStatus(inactiveStatus);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Delegate cleared')),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Clear Delegate Events'),
                  onPressed: () {
                    setState(() {
                      testDelegate.events.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delegate events cleared')),
                    );
                  },
                ),
                ElevatedButton(
                    child: Text('Show Delegate Events without log'),
                    onPressed: () {
                      _showDelegateEventsListDialog(
                          testDelegate.eventsWithoutLog);
                    }),
                ElevatedButton(
                  child: Text('Show Delegate Events with log'),
                  onPressed: () {
                    _showDelegateEventsListDialog(testDelegate.events
                        .where((event) => event is HandleLogEvent)
                        .toList());
                  },
                ),
                ElevatedButton(
                  child: Text('Events without log and presentation'),
                  onPressed: () {
                    _showDelegateEventsListDialog(testDelegate.eventsWithoutLog
                        .where((event) =>
                            event is! WillPresentPaywallEvent &&
                            event is! DidPresentPaywallEvent &&
                            event is! WillDismissPaywallEvent &&
                            event is! DidDismissPaywallEvent &&
                            event is! HandleSuperwallEventEvent)
                        .toList());
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
