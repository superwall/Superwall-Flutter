import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import '../public/PurchaseController.dart';

class PurchaseControllerProxy {
  BridgeId bridgeId;
  PurchaseController purchaseController;

  PurchaseControllerProxy(
      {required this.bridgeId, required this.purchaseController}) {
    bridgeId.associate(this);
    bridgeId.communicator.setMethodCallHandler(_handleMethodCall);
  }

  // Handle method calls from native
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'purchaseProduct':
        final productId = call.arguments['productId'];
        final purchaseResult = await purchaseController.purchase(productId);
        await purchaseResult.bridgeId.ensureBridgeCreated();
        return purchaseResult.bridgeId;
      case 'restorePurchases':
        final restorationResult = await purchaseController.restorePurchases();
        await restorationResult.bridgeId.ensureBridgeCreated();
        return restorationResult.bridgeId;
    }
  }
}