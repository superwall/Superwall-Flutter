import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// A proxy class that bridges between the Flutter FeatureHandler
/// and the generated PFeatureHandlerGenerated interface.
class FeatureBlockProxy implements PFeatureHandlerGenerated {
  final Function handler;

  FeatureBlockProxy(this.handler);

  static void register(Function handler, {String? hostId}) {
    final proxy = FeatureBlockProxy(handler);
    PFeatureHandlerGenerated.setUp(proxy, messageChannelSuffix: hostId ?? '');
  }

  @override
  void onFeature(String id) {
    handler();
  }
}
