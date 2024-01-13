import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/PurchaseResult.dart';
import 'package:superwallkit_flutter/src/public/RestorationResult.dart';
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
      case 'purchaseFromAppStore':
        String productId = call.arguments['productId'];
        PurchaseResult purchaseResult = await purchaseController.purchaseFromAppStore(productId);
        await purchaseResult.bridgeId.ensureBridgeCreated();
        return purchaseResult.bridgeId;
      case 'purchaseFromGooglePlay':
        String productId = call.arguments['productId'];
        String? basePlanId = call.arguments['basePlanId'];
        String? offerId = call.arguments['offerId'];
        PurchaseResult purchaseResult = await purchaseController.purchaseFromGooglePlay(productId, basePlanId, offerId);
        await purchaseResult.bridgeId.ensureBridgeCreated();
        return purchaseResult.bridgeId;
      case 'restorePurchases':
        RestorationResult restorationResult = await purchaseController.restorePurchases();
        await restorationResult.bridgeId.ensureBridgeCreated();
        return restorationResult.bridgeId;
    }
  }
}