import 'package:superwallkit_flutter/superwallkit_flutter.dart';

import 'package:flutter/services.dart';
import 'dart:async';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/public/PurchaseResult.dart';
import 'package:superwallkit_flutter/src/public/RestorationResult.dart';

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
  Future<PPurchaseResult> purchaseFromGooglePlay(String productId,
      String? basePlanId, String? offerId, PProductReplacement? replacement) async {
    final result = replacement == null
        ? await controller.purchaseFromGooglePlay(productId, basePlanId, offerId)
        : await controller.purchaseFromGooglePlayWithReplacement(productId,
            basePlanId, offerId, ProductReplacement.fromPigeon(replacement));
    return PurchaseResult.toPPurchaseResult(result);
  }

  @override
  Future<PRestorationResult> restorePurchases() async {
    final result = await controller.restorePurchases();
    return RestorationResult.toPRestorationResult(result);
  }
}
