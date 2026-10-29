import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

const _hostPrefix = 'dev.flutter.pigeon.superwallkit_flutter.PSuperwallHostApi';
const _streamChannel =
    'dev.flutter.pigeon.superwallkit_flutter.SuperwallEventStreams.streamCustomerInfo';
const _delegateChannel =
    'dev.flutter.pigeon.superwallkit_flutter.PSuperwallDelegateGenerated.customerInfoDidChange';
const _codec = PSuperwallHostApi.pigeonChannelCodec;
const _purchaseDate = 1700000000123;
const _renewedDate = 1700000100456;
const _expirationDate = 1700000200789;

PEntitlement _entitlement({bool active = true}) => PEntitlement(
  id: active ? 'premium' : 'expired',
  type: PEntitlementType.serviceLevel,
  isActive: active,
  productIds: ['premium:monthly', 'premium:yearly'],
  latestProductId: 'premium:monthly',
  store: PProductStore.playStore,
  startsAt: _purchaseDate,
  renewedAt: _renewedDate,
  expiresAt: _expirationDate,
  isLifetime: false,
  willRenew: active,
  state: active
      ? PLatestSubscriptionState.subscribed
      : PLatestSubscriptionState.expired,
  offerType: active ? PLatestSubscriptionOfferType.trial : null,
);

PCustomerInfo _customerInfo({String userId = 'customer-1'}) => PCustomerInfo(
  subscriptions: [
    PSubscriptionTransaction(
      transactionId: 'subscription-1',
      productId: 'premium:monthly',
      purchaseDate: _purchaseDate,
      willRenew: true,
      isRevoked: false,
      isInGracePeriod: false,
      isInBillingRetryPeriod: true,
      isActive: true,
      expirationDate: _expirationDate,
      offerType: PLatestSubscriptionOfferType.trial,
      subscriptionGroupId: 'group-1',
      store: PProductStore.playStore,
    ),
    PSubscriptionTransaction(
      transactionId: 'subscription-revoked',
      productId: 'premium:yearly',
      purchaseDate: _purchaseDate,
      willRenew: false,
      isRevoked: true,
      isInGracePeriod: false,
      isInBillingRetryPeriod: false,
      isActive: false,
    ),
  ],
  nonSubscriptions: [
    PNonSubscriptionTransaction(
      transactionId: 'purchase-1',
      productId: 'coins',
      purchaseDate: _purchaseDate,
      isConsumable: true,
      isRevoked: false,
      store: PProductStore.stripe,
    ),
  ],
  entitlements: [_entitlement(), _entitlement(active: false)],
  userId: userId,
);

void _expectEntitlement(Entitlement entitlement, {bool active = true}) {
  expect(entitlement.id, active ? 'premium' : 'expired');
  expect(entitlement.type, EntitlementType.serviceLevel);
  expect(entitlement.isActive, active);
  expect(entitlement.productIds, {'premium:monthly', 'premium:yearly'});
  expect(entitlement.latestProductId, 'premium:monthly');
  expect(entitlement.store, ProductStore.playStore);
  expect(entitlement.startsAt!.millisecondsSinceEpoch, _purchaseDate);
  expect(entitlement.renewedAt!.millisecondsSinceEpoch, _renewedDate);
  expect(entitlement.expiresAt!.millisecondsSinceEpoch, _expirationDate);
  expect(entitlement.isLifetime, false);
  expect(entitlement.willRenew, active);
  expect(
    entitlement.state,
    active
        ? LatestSubscriptionState.subscribed
        : LatestSubscriptionState.expired,
  );
  expect(
    entitlement.offerType,
    active ? LatestSubscriptionOfferType.trial : null,
  );
}

void _expectCustomerInfo(CustomerInfo info, {String userId = 'customer-1'}) {
  expect(info.userId, userId);
  expect(info.subscriptions, hasLength(2));
  final subscription = info.subscriptions.first;
  expect(subscription.transactionId, 'subscription-1');
  expect(subscription.productId, 'premium:monthly');
  expect(subscription.purchaseDate.millisecondsSinceEpoch, _purchaseDate);
  expect(subscription.willRenew, true);
  expect(subscription.isRevoked, false);
  expect(subscription.isInGracePeriod, false);
  expect(subscription.isInBillingRetryPeriod, true);
  expect(subscription.isActive, true);
  expect(subscription.expirationDate!.millisecondsSinceEpoch, _expirationDate);
  expect(subscription.offerType, LatestSubscriptionOfferType.trial);
  expect(subscription.subscriptionGroupId, 'group-1');
  expect(subscription.store, ProductStore.playStore);
  final revoked = info.subscriptions.last;
  expect(revoked.transactionId, 'subscription-revoked');
  expect(revoked.isActive, false);
  expect(revoked.isRevoked, true);
  expect(revoked.willRenew, false);
  expect(revoked.expirationDate, isNull);
  expect(revoked.offerType, isNull);
  expect(revoked.subscriptionGroupId, isNull);
  expect(revoked.store, isNull);
  expect(info.nonSubscriptions, hasLength(1));
  final purchase = info.nonSubscriptions.single;
  expect(purchase.transactionId, 'purchase-1');
  expect(purchase.productId, 'coins');
  expect(purchase.purchaseDate.millisecondsSinceEpoch, _purchaseDate);
  expect(purchase.isConsumable, true);
  expect(purchase.isRevoked, false);
  expect(purchase.store, ProductStore.stripe);
  expect(info.entitlements, hasLength(2));
  _expectEntitlement(info.entitlements.first);
  _expectEntitlement(info.entitlements.last, active: false);
}

class _RecordingDelegate extends SuperwallDelegate {
  final changes = <(CustomerInfo, CustomerInfo)>[];

  @override
  void customerInfoDidChange(CustomerInfo from, CustomerInfo to) {
    changes.add((from, to));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  List<Object?> mockHost(String method, Object? reply) {
    final calls = <Object?>[];
    messenger.setMockMessageHandler('$_hostPrefix.$method', (message) async {
      calls.add(_codec.decodeMessage(message));
      return _codec.encodeMessage([reply]);
    });
    addTearDown(
      () => messenger.setMockMessageHandler('$_hostPrefix.$method', null),
    );
    return calls;
  }

  Future<ByteData?> sendNativeMessage(String channel, ByteData? message) {
    final response = Completer<ByteData?>();
    TestDefaultBinaryMessengerBinding.instance.channelBuffers.push(
      channel,
      message,
      response.complete,
    );
    return response.future;
  }

  test(
    'getCustomerInfo preserves transactions, history and entitlement details',
    () async {
      final calls = mockHost('getCustomerInfo', _customerInfo());
      _expectCustomerInfo(await Superwall.shared.getCustomerInfo());
      expect(calls, [null]);
    },
  );

  test(
    'getEntitlements preserves inactive details and forwards product lookup',
    () async {
      mockHost(
        'getEntitlements',
        PEntitlements(
          active: [_entitlement()],
          inactive: [_entitlement(active: false)],
          all: [_entitlement(), _entitlement(active: false)],
          web: [],
        ),
      );
      final filterCalls = mockHost('getEntitlementsByProductIds', [
        _entitlement(),
      ]);

      final entitlements = await Superwall.shared.getEntitlements();
      _expectEntitlement(entitlements.active.single);
      _expectEntitlement(entitlements.inactive.single, active: false);
      expect(entitlements.all, hasLength(2));
      expect(entitlements.web, isEmpty);

      final matches = await entitlements.byProductIds({
        'premium:monthly',
        'unknown',
      });
      expect(filterCalls, [
        [
          ['premium:monthly', 'unknown'],
        ],
      ]);
      _expectEntitlement(matches.single);
    },
  );

  test('customerInfoStream cancels and can listen again after an error or last listener', () async {
    var listening = Completer<void>();
    var cancelling = Completer<void>();
    final controlMethods = <String>[];
    const controlChannel = MethodChannel(_streamChannel, pigeonMethodCodec);
    messenger.setMockMethodCallHandler(controlChannel, (call) async {
      controlMethods.add(call.method);
      if (call.method == 'listen' && !listening.isCompleted) {
        listening.complete();
      }
      if (call.method == 'cancel' && !cancelling.isCompleted) {
        cancelling.complete();
      }
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(controlChannel, null));

    final errorReceived = Completer<PlatformException>();
    final beforeConfigure = Superwall.shared.customerInfoStream.listen(
      (_) => fail('Expected a configure-first error'),
      onError: (Object error) =>
          errorReceived.complete(error as PlatformException),
    );
    addTearDown(beforeConfigure.cancel);
    await listening.future;
    await sendNativeMessage(
      _streamChannel,
      pigeonMethodCodec.encodeErrorEnvelope(
        code: 'not-configured',
        message: 'Superwall has not been initialized or configured.',
      ),
    );
    expect((await errorReceived.future).code, 'not-configured');
    await beforeConfigure.cancel();
    await cancelling.future.timeout(const Duration(seconds: 2));
    expect(controlMethods, ['listen', 'cancel']);

    listening = Completer<void>();
    cancelling = Completer<void>();
    final firstEvents = <CustomerInfo>[];
    final secondEvents = <CustomerInfo>[];
    final firstUpdated = Completer<void>();
    final secondUpdated = Completer<void>();
    final first = Superwall.shared.customerInfoStream.listen((info) {
      firstEvents.add(info);
      if (firstEvents.length == 2) firstUpdated.complete();
    });
    final second = Superwall.shared.customerInfoStream.listen((info) {
      secondEvents.add(info);
      if (secondEvents.length == 2) secondUpdated.complete();
    });
    addTearDown(first.cancel);
    addTearDown(second.cancel);
    await listening.future.timeout(const Duration(seconds: 2));

    await sendNativeMessage(
      _streamChannel,
      pigeonMethodCodec.encodeSuccessEnvelope(_customerInfo()),
    );
    await sendNativeMessage(
      _streamChannel,
      pigeonMethodCodec.encodeSuccessEnvelope(_customerInfo(userId: 'updated')),
    );
    await Future.wait([firstUpdated.future, secondUpdated.future]);
    _expectCustomerInfo(firstEvents.first);
    _expectCustomerInfo(secondEvents.first);
    _expectCustomerInfo(firstEvents.last, userId: 'updated');
    _expectCustomerInfo(secondEvents.last, userId: 'updated');
    expect(controlMethods, ['listen', 'cancel', 'listen']);

    await first.cancel();
    expect(controlMethods, ['listen', 'cancel', 'listen']);
    await second.cancel();
    await cancelling.future.timeout(const Duration(seconds: 2));
    expect(controlMethods, ['listen', 'cancel', 'listen', 'cancel']);

    listening = Completer<void>();
    cancelling = Completer<void>();
    final receivedAgain = Completer<CustomerInfo>();
    final again = Superwall.shared.customerInfoStream.listen(
      receivedAgain.complete,
    );
    addTearDown(again.cancel);
    await listening.future.timeout(const Duration(seconds: 2));
    await sendNativeMessage(
      _streamChannel,
      pigeonMethodCodec.encodeSuccessEnvelope(
        _customerInfo(userId: 'reconnected'),
      ),
    );
    _expectCustomerInfo(await receivedAgain.future, userId: 'reconnected');
    await again.cancel();
    await cancelling.future.timeout(const Duration(seconds: 2));
    expect(controlMethods, [
      'listen',
      'cancel',
      'listen',
      'cancel',
      'listen',
      'cancel',
    ]);
  });

  test(
    'customerInfoDidChange delivers complete old and new snapshots',
    () async {
      final delegate = _RecordingDelegate();
      PSuperwallDelegateGenerated.setUp(SuperwallDelegateHost(delegate));
      addTearDown(() => PSuperwallDelegateGenerated.setUp(null));

      final reply = await sendNativeMessage(
        _delegateChannel,
        _codec.encodeMessage([
          _customerInfo(userId: 'previous'),
          _customerInfo(userId: 'updated'),
        ]),
      );

      expect(_codec.decodeMessage(reply), isEmpty);
      expect(delegate.changes, hasLength(1));
      _expectCustomerInfo(delegate.changes.single.$1, userId: 'previous');
      _expectCustomerInfo(delegate.changes.single.$2, userId: 'updated');
    },
  );
}
