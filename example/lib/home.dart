import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class Home extends StatelessWidget {
  final VoidCallback onPressed;

  const Home({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

// Home screen with buttons to trigger Superwall events and navigation.
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                // Launch Non-Gated Feature.
                child: Text('Launch Non-Gated Feature'),
                onPressed: () async {
                  onPressed();
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
                  Superwall.shared.identify('abc');
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
