import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class Home extends StatelessWidget {
// Home screen with buttons to trigger Superwall events and navigation.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
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
                            Text('Subscription Status: ${status}'),
                          ]))),
              ElevatedButton(
                // Launch Non-Gated Feature.
                child: Text('Launch Non-Gated Feature'),
                onPressed: () async {
                  await Superwall.shared.registerPlacement('non_gated',
                      feature: () {
                    Navigator.pushNamed(
                      context,
                      '/launchedFeature',
                      arguments: 'Non-gated feature launched',
                    );
                  });
                },
              ),
              ElevatedButton(
                // Launch Pro Feature.
                child: Text('Launch Pro Feature'),
                onPressed: () async {
                  await Superwall.shared.registerPlacement('pro', feature: () {
                    Navigator.pushNamed(
                      context,
                      '/launchedFeature',
                      arguments: 'Pro feature launched',
                    );
                  });
                },
              ),
              ElevatedButton(
                // Launch Diamond Feature.
                child: Text('Launch Diamond Feature'),
                onPressed: () async {
                  await Superwall.shared.registerPlacement('diamond',
                      feature: () {
                    Navigator.pushNamed(
                      context,
                      '/launchedFeature',
                      arguments: 'Diamond feature launched',
                    );
                  });
                },
              ),
              ElevatedButton(
                // Identify action.
                child: Text('Identify'),
                onPressed: () {
                  onRegisterTapped();
                },
              ),
              ElevatedButton(
                // Reset action.
                child: Text('Reset'),
                onPressed: () {
                  Superwall.shared.reset();
                },
              ),
            ],
          ),
        ),
      );
}

// Method to call when the button is tapped
Future<void> onRegisterTapped() async {
  try {
    final handler = PaywallPresentationHandler();
    handler
      ..onPresent((paywallInfo) async {
        final name = await paywallInfo.name;
        debugPrint('Handler (onPresent): $name');
      })
      ..onDismiss((paywallInfo) async {
        final name = await paywallInfo.name;
        debugPrint('Handler (onDismiss): $name');
      })
      ..onError((error) {
        debugPrint('Handler (onError): $error');
      })
      ..onSkip((skipReason) {
        debugPrint('Handler (onSkip): $skipReason');
      });

    Superwall.shared.registerPlacement('flutter', handler: handler,
        feature: () {
      debugPrint('Executing feature block');
    });
    debugPrint('Register method called successfully.');
  } catch (e) {
    // Handle any errors that occur during registration
    debugPrint('Failed to call register method: $e');
  }
}
