import 'package:flutter/widgets.dart';

class SuperwallProvider extends InheritedWidget {
  final SubscriptionStatus _status;

  const SuperwallProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static SuperwallProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SuperwallProvider>();
  }

  @override
  bool updateShouldNotify(SuperwallProvider oldWidget) {
    return oldWidget.status != status;
  }
}