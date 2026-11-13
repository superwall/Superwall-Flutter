import 'package:flutter/material.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Shows a paywall inside the screen with [PaywallView], and reports what the
/// view called back with so the Maestro flow can assert on it.
class EmbeddedPaywallTest extends StatefulWidget {
  const EmbeddedPaywallTest({super.key});

  @override
  State<EmbeddedPaywallTest> createState() => _EmbeddedPaywallTestState();
}

class _EmbeddedPaywallTestState extends State<EmbeddedPaywallTest> {
  String? _placement;
  String _status = 'None';

  void _embed(String placement) {
    setState(() {
      _placement = placement;
      _status = 'Loading';
    });
  }

  void _setStatus(String status) {
    if (!mounted) return;
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    final placement = _placement;
    return Scaffold(
      appBar: AppBar(
        title: Text('Embedded Paywall Test'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            child: Text('Embed Paywall'),
            onPressed: () => _embed('non_gated_paywall'),
          ),
          ElevatedButton(
            child: Text('Embed Skip Audience'),
            onPressed: () => _embed('skip_audience'),
          ),
          ElevatedButton(
            child: Text('Remove Paywall'),
            onPressed: () => setState(() {
              _placement = null;
              _status = 'None';
            }),
          ),
          Text('Embedded Status: $_status'),
          Expanded(
            child: placement == null
                ? SizedBox.shrink()
                : PaywallView(
                    placement: placement,
                    onPresent: (paywallInfo) => _setStatus('Presented'),
                    onSkip: (reason) => _setStatus('Skipped'),
                    onError: (error) => _setStatus('Error'),
                    onFinished: (paywallInfo, result, shouldDismiss) {
                      if (shouldDismiss) {
                        setState(() {
                          _placement = null;
                          _status = 'Finished';
                        });
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
