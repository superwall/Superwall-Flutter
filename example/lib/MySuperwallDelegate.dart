import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class MySuperwallDelegate extends SuperwallDelegate {
  final logging = Logging();

  @override
  void handleSuperwallEvent(SuperwallEventInfo eventInfo) {
    logging.info('handleSuperwallEvent: ${eventInfo.event.type}');
  }
}
