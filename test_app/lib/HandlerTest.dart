import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'handler/TestHandler.dart';

class HandlerTest extends StatefulWidget {
  @override
  _HandlerTestState createState() => _HandlerTestState();
}

class _HandlerTestState extends State<HandlerTest> {
  final PaywallPresentationHandler presentationHandler =
      PaywallPresentationHandler();
  late TestHandler testHandler;
  bool featureBlockExecuted = false;

  @override
  void initState() {
    super.initState();
    testHandler = TestHandler(presentationHandler);
  }

  void _showHandlerEventsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Handler Events'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: testHandler.events.length,
            itemBuilder: (context, index) {
              final event = testHandler.events[index];
              String eventName = '';

              if (event is PresentEvent) {
                eventName = 'OnPresent';
              } else if (event is DismissEvent) {
                eventName = 'OnDismiss';
              } else if (event is ErrorEvent) {
                eventName = 'OnError';
              } else if (event is SkipEvent) {
                eventName = 'OnSkip';
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

  // Feature block function that will be executed for non-gated paywalls
  void _featureBlock() {
    setState(() {
      featureBlockExecuted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feature block executed!')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Handler Test'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Test Non-Gated Paywall'),
                  onPressed: () async {
                    await Superwall.shared.registerPlacement(
                      "non_gated_paywall",
                      handler: presentationHandler,
                      feature: _featureBlock,
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Test Gated Paywall'),
                  onPressed: () async {
                    await Superwall.shared.registerPlacement(
                      "gated_paywall",
                      handler: presentationHandler,
                      feature: _featureBlock,
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Test Skip Audience'),
                  onPressed: () async {
                    await Superwall.shared.registerPlacement(
                      "skip_audience",
                      handler: presentationHandler,
                      feature: _featureBlock,
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Test Error Placement'),
                  onPressed: () async {
                    await Superwall.shared.registerPlacement(
                      "error_placement",
                      handler: presentationHandler,
                      feature: _featureBlock,
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Dismiss Paywall'),
                  onPressed: () async {
                    await Superwall.shared.dismiss();
                  },
                ),
                ElevatedButton(
                  child: Text('Clear Handler Events'),
                  onPressed: () {
                    setState(() {
                      testHandler.events.clear();
                      featureBlockExecuted = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Handler events cleared')),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('Show Handler Events'),
                  onPressed: () {
                    _showHandlerEventsDialog();
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Test Results',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                          'Feature Block Executed: ${featureBlockExecuted ? "Yes" : "No"}'),
                      Text('Event Count: ${testHandler.events.length}'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
