import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// A proxy class that bridges between the Flutter ConfigureCompletion
/// and the generated PConfigureCompletionGenerated interface.
class ConfigureCompletionProxy implements PConfigureCompletionGenerated {
  final Function handler;

  ConfigureCompletionProxy(this.handler);

  static void register(Function handler, {String? hostId}) {
    final proxy = ConfigureCompletionProxy(handler);
    PConfigureCompletionGenerated.setUp(proxy,
        messageChannelSuffix: hostId ?? '');
  }

  @override
  void onConfigureCompleted(bool success) {
    handler();
  }
}
