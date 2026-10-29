import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/private/PurchaseControllerProxy.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

class _BasicController extends PurchaseController {
  final calls = <List<Object?>>[];

  @override
  Future<PurchaseResult> purchaseFromAppStore(String productId) async =>
      PurchaseResult.purchased;

  @override
  Future<PurchaseResult> purchaseFromGooglePlay(
      String productId, String? basePlanId, String? offerId) async {
    calls.add([productId, basePlanId, offerId]);
    return PurchaseResult.purchased;
  }

  @override
  Future<RestorationResult> restorePurchases() async =>
      RestorationResult.restored;
}

class _ReplacingController extends _BasicController {
  final replacements = <ProductReplacement>[];

  @override
  Future<PurchaseResult> purchaseFromGooglePlayWithReplacement(
      String productId,
      String? basePlanId,
      String? offerId,
      ProductReplacement replacement) async {
    replacements.add(replacement);
    return PurchaseResult.cancelled;
  }
}

void main() {
  final pigeonReplacement = PProductReplacement(
      mode: PProductReplacementMode.chargeProrated,
      oldProductId: 'old_sub',
      oldPurchaseToken: 'token');

  test('ProductReplacement maps from Pigeon', () {
    expect(
        ProductReplacement.fromPigeon(pigeonReplacement),
        const ProductReplacement(
            mode: ProductReplacementMode.chargeProrated,
            oldProductId: 'old_sub',
            oldPurchaseToken: 'token'));
    expect(
        ProductReplacementMode.fromPigeon(PProductReplacementMode.storeDefault),
        ProductReplacementMode.storeDefault);
    expect(
        ProductReplacementMode.fromPigeon(
            PProductReplacementMode.chargeFullPrice),
        ProductReplacementMode.chargeFullPrice);
  });

  test('purchases without a replacement call purchaseFromGooglePlay', () async {
    final controller = _ReplacingController();
    final result = await PurchaseControllerProxy(controller)
        .purchaseFromGooglePlay('product', 'base', 'offer', null);
    expect(result, isA<PPurchasePurchased>());
    expect(controller.calls.single, ['product', 'base', 'offer']);
    expect(controller.replacements, isEmpty);
  });

  test('replacements call purchaseFromGooglePlayWithReplacement', () async {
    final controller = _ReplacingController();
    final result = await PurchaseControllerProxy(controller)
        .purchaseFromGooglePlay('product', null, null, pigeonReplacement);
    expect(result, isA<PPurchaseCancelled>());
    expect(controller.calls, isEmpty);
    expect(controller.replacements.single.oldPurchaseToken, 'token');
  });

  test('the default replacement method falls back to purchaseFromGooglePlay',
      () async {
    final controller = _BasicController();
    final result = await PurchaseControllerProxy(controller)
        .purchaseFromGooglePlay('product', 'base', null, pigeonReplacement);
    expect(result, isA<PPurchasePurchased>());
    expect(controller.calls.single, ['product', 'base', null]);
  });
}
