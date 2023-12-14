import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/BridgingCreator.dart';

class CompletionBlockProxy {
  Bridge bridge;
  Function(dynamic?) block;

  late final MethodChannel channel;

  CompletionBlockProxy({required this.bridge, required this.block}): channel = MethodChannel(bridge) {
    bridge.associate(this);
    channel.setMethodCallHandler(_handleMethodCall);
  }

  // Handle method calls from native
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'callCompletionBlock':
        final arguments = call.arguments;
        block(arguments);
      default:
        throw UnimplementedError('Method ${call.method} not implemented.');
    }
  }
}