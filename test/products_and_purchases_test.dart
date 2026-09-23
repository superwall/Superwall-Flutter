import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

const _prefix = 'dev.flutter.pigeon.superwallkit_flutter.PSuperwallHostApi';
const _codec = PSuperwallHostApi.pigeonChannelCodec;

PStoreProduct _product(String id, double price, String localizedPrice) =>
    PStoreProduct(
      entitlements: [],
      productIdentifier: id,
      attributes: {},
      localizedPrice: localizedPrice,
      localizedSubscriptionPeriod: '',
      period: '',
      periodly: '',
      periodWeeks: 0,
      periodWeeksString: '',
      periodMonths: 0,
      periodMonthsString: '',
      periodYears: 0,
      periodYearsString: '',
      periodDays: 0,
      periodDaysString: '',
      dailyPrice: '',
      weeklyPrice: '',
      monthlyPrice: '',
      yearlyPrice: '',
      hasFreeTrial: false,
      trialPeriodEndDateString: '',
      localizedTrialPeriodPrice: '',
      trialPeriodPrice: 0,
      trialPeriodDays: 0,
      trialPeriodDaysString: '',
      trialPeriodWeeks: 0,
      trialPeriodWeeksString: '',
      trialPeriodMonths: 0,
      trialPeriodMonthsString: '',
      trialPeriodYears: 0,
      trialPeriodYearsString: '',
      trialPeriodText: '',
      locale: 'en_US',
      currencyCode: 'USD',
      currencySymbol: r'$',
      isFamilyShareable: false,
      price: price,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  /// Registers a mock host method that records its arguments and replies with
  /// [reply] (a success value) or [error] (a PlatformException-style error).
  List<Object?> mockHost(String method, {Object? reply, List<Object?>? error}) {
    final calls = <Object?>[];
    messenger.setMockMessageHandler('$_prefix.$method', (message) async {
      final args = _codec.decodeMessage(message) as List<Object?>?;
      calls.add(args);
      return _codec.encodeMessage(error ?? <Object?>[reply]);
    });
    return calls;
  }

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('getProducts', () {
    test('maps products and forwards identifiers', () async {
      final calls = mockHost('getProducts', reply: [
        _product('coins_100', 0.99, r'$0.99'),
        _product('coins_500', 3.99, r'$3.99'),
      ]);

      final products = await Superwall.shared
          .getProducts(['coins_100', 'unknown', 'coins_500']);

      expect(calls.single, [
        ['coins_100', 'unknown', 'coins_500']
      ]);
      expect(products.map((p) => p.productIdentifier),
          ['coins_100', 'coins_500']);
      expect(products.first.price, 0.99);
      expect(products.first.localizedPrice, r'$0.99');
      expect(products.first.currencyCode, 'USD');
    });
  });

  group('purchase', () {
    final cases = <PPurchaseResult, Type>{
      PPurchasePurchased(): PurchaseResultPurchased,
      PPurchaseCancelled(): PurchaseResultCancelled,
      PPurchasePending(): PurchaseResultPending,
    };
    cases.forEach((native, expected) {
      test('maps ${native.runtimeType}', () async {
        final calls = mockHost('purchase', reply: native);
        final result = await Superwall.shared.purchase('coins_100');
        expect(calls.single, ['coins_100']);
        expect(result.runtimeType, expected);
      });
    });

    test('returns failure with native error details', () async {
      mockHost('purchase',
          reply: PPurchaseFailed(error: 'Product with id x not found'));
      final result = await Superwall.shared.purchase('x');
      expect(result, isA<PurchaseResultFailed>());
      expect((result as PurchaseResultFailed).error,
          'Product with id x not found');
    });
  });

  group('queryInAppPurchases', () {
    test('Android: query, grant, then consume each token', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      mockHost('queryInAppPurchases', reply: [
        POwnedInAppPurchase(
          productIds: ['coins_100'],
          purchaseToken: 'token-1',
          orderId: 'GPA.1',
          purchaseTime: 1700000000000,
          quantity: 2,
          isAcknowledged: false,
        ),
      ]);
      final consumeCalls = mockHost('consume', reply: 'token-1');

      final owned = await Superwall.shared.queryInAppPurchases();
      expect(owned, hasLength(1));
      final purchase = owned.single;
      expect(purchase.productIds, ['coins_100']);
      expect(purchase.purchaseToken, 'token-1');
      expect(purchase.orderId, 'GPA.1');
      expect(purchase.quantity, 2);
      expect(purchase.isAcknowledged, isFalse);
      expect(purchase.purchaseTime,
          DateTime.fromMillisecondsSinceEpoch(1700000000000));

      final consumed = await Superwall.shared.consume(purchase.purchaseToken);
      expect(consumed, 'token-1');
      expect(consumeCalls.single, ['token-1']);
    });

    test('Android: surfaces billing errors', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      mockHost('queryInAppPurchases',
          error: ['InAppPurchaseQueryException', 'setup failed: 3', null]);
      expect(Superwall.shared.queryInAppPurchases(),
          throwsA(isA<PlatformException>()));
    });

    test('throws UnsupportedError on iOS without calling native', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final calls = mockHost('queryInAppPurchases', reply: []);
      expect(Superwall.shared.queryInAppPurchases(),
          throwsA(isA<UnsupportedError>()));
      expect(calls, isEmpty);
    });
  });
}
