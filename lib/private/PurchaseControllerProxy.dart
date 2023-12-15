import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/public/PurchaseController.dart';

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
        return purchaseResult.toJson();
      case 'restorePurchases':
        final restorationResult = await purchaseController.restorePurchases();
        return restorationResult.toJson();
    }
  }
}