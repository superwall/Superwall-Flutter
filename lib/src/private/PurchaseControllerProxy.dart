import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/PurchaseResult.dart';
import 'package:superwallkit_flutter/src/public/RestorationResult.dart';
import '../public/PurchaseController.dart';

class PurchaseControllerProxy extends BridgeIdInstantiable {
  static const BridgeClass bridgeClass = "PurchaseControllerProxyBridge";
  PurchaseControllerProxy(
      {required this.purchaseController, super.givenId, super.bridgeId})
      : super(bridgeClass: bridgeClass);

  PurchaseController purchaseController;

  // Handle method calls from native
  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'purchaseFromAppStore':
        print(
            "Calling purchaseFromAppStore in the PurchaseController. Bridge Id: $bridgeId");
        String productId = call.arguments['productId'];
        PurchaseResult purchaseResult =
            await purchaseController.purchaseFromAppStore(productId);
        print("Ensuring bridge created");
        await purchaseResult.bridgeId.ensureBridgeCreated();
        print("returning PurchaseResult");
        return purchaseResult.bridgeId;
      case 'purchaseFromGooglePlay':
        String productId = call.arguments['productId'];
        String? basePlanId = call.arguments['basePlanId'];
        String? offerId = call.arguments['offerId'];
        print(
            "Calling purchaseFromGooglePlay in the PurchaseController. Bridge Id: $bridgeId");
        PurchaseResult purchaseResult = await purchaseController
            .purchaseFromGooglePlay(productId, basePlanId, offerId);
        print("Ensuring bridge created");
        await purchaseResult.bridgeId.ensureBridgeCreated();
        print("returning PurchaseResult");
        return purchaseResult.bridgeId;
      case 'restorePurchases':
        print(
            "Calling restorePurchases from the PurchaseController. Bridge Id: $bridgeId");
        RestorationResult restorationResult =
            await purchaseController.restorePurchases();
        print("Ensuring bridge created");
        await restorationResult.bridgeId.ensureBridgeCreated();
        print("returning RestorationResult");
        return restorationResult.bridgeId;
    }
  }
}
