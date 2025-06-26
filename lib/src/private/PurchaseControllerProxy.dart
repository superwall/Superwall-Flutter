import 'dart:async';

import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// A proxy class that bridges between the Flutter PurchaseController
/// and the generated PPurchaseControllerGenerated interface.
class PurchaseControllerProxy implements PPurchaseControllerGenerated {
  final PurchaseController controller;

  PurchaseControllerProxy(this.controller);

  static void register(PurchaseController controller, {String? hostId}) {
    final proxy = PurchaseControllerProxy(controller);
    PPurchaseControllerGenerated.setUp(proxy,
        messageChannelSuffix: hostId ?? '');
  }

  @override
  Future<PPurchaseResult> purchaseFromAppStore(String productId) async {
    final result = await controller.purchaseFromAppStore(productId);
    return PurchaseResult.toPPurchaseResult(result);
  }

  @override
  Future<PPurchaseResult> purchaseFromGooglePlay(
      String productId, String? basePlanId, String? offerId) async {
    final result =
        await controller.purchaseFromGooglePlay(productId, basePlanId, offerId);
    return PurchaseResult.toPPurchaseResult(result);
  }

  @override
  Future<PRestorationResult> restorePurchases() async {
    final result = await controller.restorePurchases();
    return RestorationResult.toPRestorationResult(result);
  }
}
