import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class SuperwallBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, SubscriptionStatus status)
      builder;

  const SuperwallBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<SuperwallBuilder> createState() => _SuperwallBuilderState();
}

class _SuperwallBuilderState extends State<SuperwallBuilder> {
  SubscriptionStatus _status = SubscriptionStatus.unknown;
  StreamSubscription<SubscriptionStatus>? _subscription;

  @override
  void initState() {
    super.initState();
    _initializeStatus();
  }

  Future<void> _initializeStatus() async {
    _status = await Superwall.shared.getSubscriptionStatus();
    _subscription = Superwall.shared.subscriptionStatus.listen((status) {
      setState(() {
        _status = status;
      });
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _status);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
