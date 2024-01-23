import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/PurchaseResult.dart';
import 'package:superwallkit_flutter/src/public/RestorationResult.dart';
import '../public/PurchaseController.dart';

class PurchaseControllerProxy extends BridgeIdInstantiable {
  static const BridgeClass bridgeClass = "PurchaseControllerProxyBridge";
  PurchaseControllerProxy({required this.purchaseController, BridgeId? bridgeId}): super(bridgeClass: bridgeClass, bridgeId: bridgeId);

  PurchaseController purchaseController;

  // Handle method calls from native
  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
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