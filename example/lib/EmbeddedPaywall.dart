import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Shows the paywall of the `pro` placement inside the screen with a
/// [PaywallView], instead of presenting it over the app.
class EmbeddedPaywall extends StatelessWidget {
  const EmbeddedPaywall({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Embedded Paywall'),
        ),
        body: PaywallView(
          placement: 'pro',
          loadingBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
          skippedBuilder: (context, reason) =>
              Center(child: Text('No paywall to show: ${reason.runtimeType}')),
          errorBuilder: (context, error) => Center(child: Text(error)),
          onFinished: (paywallInfo, result, shouldDismiss) {
            // The paywall has been removed from the view, so leave the screen.
            if (shouldDismiss) {
              Navigator.pop(context);
            }
          },
        ),
      );
}
