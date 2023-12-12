import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/SuperwallEvent.dart';

class SuperwallEventInfo {
  final SuperwallEvent event;
  final Map<String, dynamic> params;

  SuperwallEventInfo({required this.event, required this.params});
}