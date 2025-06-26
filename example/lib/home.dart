import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

// Home screen with buttons to trigger Superwall events and navigation.
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
                            Text('Subscription Status: $status',
                                textAlign: TextAlign.center),
                          ]))),
              ElevatedButton(
                // Launch Non-Gated Feature.
                child: const Text('Launch Non-Gated Feature'),
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
                child: const Text('Launch Pro Feature'),
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
                child: const Text('Launch Diamond Feature'),
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
                child: const Text('Identify'),
                onPressed: () {
                  Superwall.shared.identify('abc');
                },
              ),
              ElevatedButton(
                // Reset action.
                child: const Text('Reset'),
                onPressed: () {
                  Superwall.shared.reset();
                },
              ),
            ],
          ),
        ),
      );
}
