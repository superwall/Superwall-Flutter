import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';

class CompletionBlockProxy {
  BridgeId bridgeId;
  Function(dynamic?) block;

  CompletionBlockProxy({required this.bridgeId, required this.block}) {
    bridgeId.associate(this);
    bridgeId.communicator.setMethodCallHandler(_handleMethodCall);
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