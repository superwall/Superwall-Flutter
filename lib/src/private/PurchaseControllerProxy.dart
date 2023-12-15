import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/public/PurchaseController.dart';

class PurchaseControllerProxy {
  MethodChannel channel;
  PurchaseController purchaseController;

  PurchaseControllerProxy({required this.channel, required this.purchaseController}) {
    channel.setMethodCallHandler(_handleMethodCall);
  }

  // Handle method calls from native
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'purchaseProduct':
        final productId = call.arguments['productId'];
        final purchaseResult = await purchaseController.purchase(productId);
        // TODO
        return purchaseResult.toString();
      case 'restorePurchases':
        final restorationResult = await purchaseController.restorePurchases();
        // TODO
        return restorationResult.toString();
    }
  }
}
