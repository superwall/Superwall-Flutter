import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/public/SuperwallEvent.dart';

/// Contains information about the internally tracked superwall event.
class SuperwallEventInfo {
  final SuperwallEvent event;
  final Map<String, dynamic> params;

  SuperwallEventInfo({required this.event, required this.params});
}