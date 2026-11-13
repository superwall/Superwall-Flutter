import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/private/PaywallPresentationHandlerProxy.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

const _prefix = 'dev.flutter.pigeon.superwallkit_flutter.PSuperwallHostApi';
const _codec = PSuperwallHostApi.pigeonChannelCodec;

PStoreProduct _product({
  PSubscriptionPeriod? subscriptionPeriod,
  String? fullIdentifier,
  String? productType,
  String? storeFrontCountryCode,
  bool? isCustomProduct,
  String? customTransactionId,
  PStoreProductDiscount? introductoryDiscount,
  List<PStoreProductDiscount>? discounts,
  PBillingPlanType? billingPlanType,
  bool? isBillingPlanAvailable,
}) =>
    PStoreProduct(
      entitlements: [],
      productIdentifier: 'monthly',
      attributes: {},
      localizedPrice: r'$4.99',
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
      isFamilyShareable: false,
      price: 4.99,
      subscriptionPeriod: subscriptionPeriod,
      fullIdentifier: fullIdentifier,
      productType: productType,
      storeFrontCountryCode: storeFrontCountryCode,
      isCustomProduct: isCustomProduct,
      customTransactionId: customTransactionId,
      introductoryDiscount: introductoryDiscount,
      discounts: discounts,
      billingPlanType: billingPlanType,
      isBillingPlanAvailable: isBillingPlanAvailable,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  List<List<Object?>> mockHost(String method, {Object? reply}) {
    final calls = <List<Object?>>[];
    messenger.setMockMessageHandler('$_prefix.$method', (message) async {
      calls.add(_codec.decodeMessage(message) as List<Object?>? ?? []);
      return _codec.encodeMessage(<Object?>[reply]);
    });
    return calls;
  }

  Future<PSuperwallOptions> configuredOptions(SuperwallOptions options) async {
    final calls = mockHost('configure');
    Superwall.configure('pk_test', options: options);
    await pumpEventQueue();
    return calls.single[2] as PSuperwallOptions;
  }

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('Superwall', () {
    test('getAssignments maps the native assignments', () async {
      final calls = mockHost('getAssignments', reply: [
        PConfirmedAssignment(
            experimentId: 'exp1',
            variant: PVariant(
                id: 'var1', type: PVariantType.treatment, paywallId: 'pw1')),
      ]);
      final assignments = await Superwall.shared.getAssignments();
      expect(calls, hasLength(1));
      expect(assignments.single.experimentId, 'exp1');
      expect(assignments.single.variant.id, 'var1');
      expect(assignments.single.variant.type, VariantType.treatment);
      expect(assignments.single.variant.paywallId, 'pw1');
    });

    test('refreshConfiguration calls native', () async {
      final calls = mockHost('refreshConfiguration');
      await Superwall.shared.refreshConfiguration();
      expect(calls, hasLength(1));
    });

    test('getEventTrackingBehavior returns the native value', () async {
      mockHost('getEventTrackingBehavior',
          reply: PEventTrackingBehavior.superwallOnly);
      expect(await Superwall.shared.getEventTrackingBehavior(),
          EventTrackingBehavior.superwallOnly);
    });

    test('setEventTrackingBehavior sends the behavior to native', () async {
      final calls = mockHost('setEventTrackingBehavior');
      await Superwall.shared
          .setEventTrackingBehavior(EventTrackingBehavior.none);
      expect(calls.single, [PEventTrackingBehavior.none]);
    });

    test('setInterfaceStyle sends the style, or null for the system style',
        () async {
      final calls = mockHost('setInterfaceStyle');
      await Superwall.shared.setInterfaceStyle(InterfaceStyle.dark);
      await Superwall.shared.setInterfaceStyle(InterfaceStyle.light);
      await Superwall.shared.setInterfaceStyle(null);
      expect(calls, [
        [PInterfaceStyle.dark],
        [PInterfaceStyle.light],
        [null],
      ]);
    });

    test('setUserAttributes keeps null values, which remove attributes',
        () async {
      final calls = mockHost('setUserAttributes');
      await Superwall.shared.setUserAttributes({'name': 'Jo', 'age': null});
      expect(calls.single[0], {'name': 'Jo', 'age': null});
    });

    test('setUserAttributes still accepts a Map<String, Object>', () async {
      final calls = mockHost('setUserAttributes');
      final Map<String, Object> attributes = {'name': 'Jo'};
      await Superwall.shared.setUserAttributes(attributes);
      expect(calls.single[0], {'name': 'Jo'});
    });

    test('getIntegrationAttributes returns the native value', () async {
      mockHost('getIntegrationAttributes', reply: {'adjustId': 'abc'});
      expect(await Superwall.shared.getIntegrationAttributes(),
          {'adjustId': 'abc'});
    });

    test('push notification methods call native', () async {
      final token = mockHost('setPushToken');
      final optOut = mockHost('optOutOfNotifications');
      final optIn = mockHost('optInToNotifications');
      final open = mockHost('handleNotificationOpen');

      await Superwall.shared.setPushToken('fcm-token');
      await Superwall.shared.optOutOfNotifications();
      await Superwall.shared.optInToNotifications();
      await Superwall.shared.handleNotificationOpen({'sw': 'payload'});

      expect(token.single, ['fcm-token']);
      expect(optOut, hasLength(1));
      expect(optIn, hasLength(1));
      expect(open.single[0], {'sw': 'payload'});
    });

    test('cancelAllScheduledNotifications calls native', () async {
      final calls = mockHost('cancelAllScheduledNotifications');
      await Superwall.shared.cancelAllScheduledNotifications();
      expect(calls, hasLength(1));
    });
  });

  group('enums', () {
    test('every case maps to the Pigeon case with the same name', () {
      for (final value in EventTrackingBehavior.values) {
        expect(value.toPigeon().name, value.name);
        expect(EventTrackingBehavior.fromPigeon(value.toPigeon()), value);
      }
      for (final value in StoreKitVersion.values) {
        expect(value.toPigeon().name, value.name);
      }
      for (final value in InterfaceStyle.values) {
        expect(value.toPigeon().name, value.name);
      }
      for (final value in PaywallPresentationStyle.values) {
        expect(value.toPigeon().name, value.name);
        expect(PaywallPresentationStyle.fromPigeon(value.toPigeon()), value);
      }
      for (final value in IntroOfferEligibility.values) {
        expect(value.toPigeon().name, value.name);
        expect(IntroOfferEligibility.fromPigeon(value.toPigeon()), value);
      }
      for (final value in ProductStore.values) {
        expect(value.toPigeon().name, value.name);
        expect(ProductStore.fromPigeon(value.toPigeon()), value);
      }
    });

    test('every Pigeon case maps to the public case with the same name', () {
      for (final value in PStoreTransactionState.values) {
        expect(StoreTransactionState.fromPigeon(value).name, value.name);
      }
      for (final value in PSubscriptionPeriodUnit.values) {
        expect(SubscriptionPeriodUnit.fromPigeon(value).name, value.name);
      }
      for (final value in PTransactionType.values) {
        expect(TransactionType.fromPigeon(value).name, value.name);
      }
    });

    test('LogScope and Pigeon have the same cases', () {
      expect(LogScope.values.map((e) => e.name),
          PLogScope.values.map((e) => e.name));
      for (final scope in LogScope.values) {
        expect(scope.toJson(), scope.name);
      }
    });

    test('every LogScope is passed to configure', () async {
      final options = await configuredOptions(
          SuperwallOptions()..logging.scopes = LogScope.values.toSet());
      expect(options.logging!.scopes, PLogScope.values);
    });
  });

  group('SuperwallOptions', () {
    test('sends neither tracking option by default', () async {
      final options = await configuredOptions(SuperwallOptions());
      expect(options.eventTrackingBehavior, isNull);
      expect(options.isExternalDataCollectionEnabled, isNull);
      expect(options.storeKitVersion, isNull);
    });

    test('passes eventTrackingBehavior and storeKitVersion to configure',
        () async {
      final options = await configuredOptions(SuperwallOptions()
        ..eventTrackingBehavior = EventTrackingBehavior.superwallOnly
        ..storeKitVersion = StoreKitVersion.storeKit1);
      expect(
          options.eventTrackingBehavior, PEventTrackingBehavior.superwallOnly);
      expect(options.storeKitVersion, PStoreKitVersion.storeKit1);
    });

    test('isExternalDataCollectionEnabled defaults to true and is sent once set',
        () async {
      // ignore: deprecated_member_use_from_same_package
      expect(SuperwallOptions().isExternalDataCollectionEnabled, isTrue);

      final options = await configuredOptions(SuperwallOptions()
        // ignore: deprecated_member_use_from_same_package
        ..isExternalDataCollectionEnabled = false);
      expect(options.isExternalDataCollectionEnabled, isFalse);
      expect(options.eventTrackingBehavior, isNull);
    });

    test('eventTrackingBehavior replaces isExternalDataCollectionEnabled',
        () async {
      final options = await configuredOptions(SuperwallOptions()
        // ignore: deprecated_member_use_from_same_package
        ..isExternalDataCollectionEnabled = false
        ..eventTrackingBehavior = EventTrackingBehavior.all);
      expect(options.eventTrackingBehavior, PEventTrackingBehavior.all);
      expect(options.isExternalDataCollectionEnabled, isNull);
    });

    test('new options are included in toJson', () {
      final json = (SuperwallOptions()
            ..eventTrackingBehavior = EventTrackingBehavior.superwallOnly
            ..storeKitVersion = StoreKitVersion.storeKit2)
          .toJson();
      expect(json['eventTrackingBehavior'], 'superwallOnly');
      expect(json['storeKitVersion'], 'storeKit2');
      expect(json['isExternalDataCollectionEnabled'], isTrue);
    });
  });

  group('PaywallOptions', () {
    test('new options have the native defaults', () async {
      final paywalls = PaywallOptions();
      expect(paywalls.notificationPermissionsDenied, isNull);
      expect(paywalls.optimisticLoading, isFalse);
      expect(paywalls.timeoutAfter, isNull);

      final options = await configuredOptions(SuperwallOptions());
      expect(options.paywalls!.notificationPermissionsDenied, isNull);
      expect(options.paywalls!.optimisticLoading, isFalse);
      expect(options.paywalls!.timeoutAfterMillis, isNull);
    });

    test('passes the new options to configure', () async {
      final options = await configuredOptions(SuperwallOptions()
        ..paywalls.notificationPermissionsDenied =
            (NotificationPermissionsDenied()
              ..title = 'Title'
              ..closeButtonTitle = 'Close')
        ..paywalls.optimisticLoading = true
        ..paywalls.timeoutAfter = const Duration(seconds: 5));
      final denied = options.paywalls!.notificationPermissionsDenied!;
      expect(denied.title, 'Title');
      expect(denied.message, NotificationPermissionsDenied().message);
      expect(denied.actionButtonTitle, 'Open Settings');
      expect(denied.closeButtonTitle, 'Close');
      expect(options.paywalls!.optimisticLoading, isTrue);
      expect(options.paywalls!.timeoutAfterMillis, 5000);
    });

    test('new options are included in toJson', () {
      final json = (PaywallOptions()
            ..notificationPermissionsDenied = NotificationPermissionsDenied()
            ..optimisticLoading = true
            ..timeoutAfter = const Duration(milliseconds: 1500))
          .toJson();
      expect(json['notificationPermissionsDenied'], {
        'title': 'Notification Permissions Denied',
        'message':
            'Please enable notification permissions from the Settings app so we can notify you when your free trial ends.',
        'actionButtonTitle': 'Open Settings',
        'closeButtonTitle': 'Not now',
      });
      expect(json['optimisticLoading'], isTrue);
      expect(json['timeoutAfterMillis'], 1500);
      expect(PaywallOptions().toJson()['timeoutAfterMillis'], isNull);
    });
  });

  group('models', () {
    test('PaywallInfo maps the new fields and round-trips them', () {
      final info = PaywallInfo.fromPigeon(PPaywallInfo(
        identifier: 'pw1',
        products: [
          PProduct(id: 'p1', name: 'primary', store: PProductStore.custom),
          PProduct(id: 'p2', name: 'secondary'),
        ],
        cacheKey: 'key',
        buildId: 'build',
        shimmerLoadStartTime: '2026-01-01T00:00:00Z',
        shimmerLoadCompleteTime: '2026-01-01T00:00:01Z',
        presentation: PPaywallPresentationInfo(
            style: PPaywallPresentationStyle.popup,
            delay: 250,
            height: 400,
            width: 300,
            cornerRadius: 12),
        isScrollEnabled: false,
        presentationId: 'presentation',
        isLocal: true,
        introOfferEligibility: PIntroOfferEligibility.ineligible,
      ))!;

      expect(info.cacheKey, 'key');
      expect(info.buildId, 'build');
      expect(info.shimmerLoadStartTime, '2026-01-01T00:00:00Z');
      expect(info.shimmerLoadCompleteTime, '2026-01-01T00:00:01Z');
      expect(info.presentation!.style, PaywallPresentationStyle.popup);
      expect(info.presentation!.delay, const Duration(milliseconds: 250));
      expect(info.presentation!.height, 400);
      expect(info.presentation!.width, 300);
      expect(info.presentation!.cornerRadius, 12);
      expect(info.isScrollEnabled, isFalse);
      expect(info.presentationId, 'presentation');
      expect(info.isLocal, isTrue);
      expect(info.introOfferEligibility, IntroOfferEligibility.ineligible);
      expect(info.products![0].store, ProductStore.custom);
      expect(info.products![1].store, isNull);

      final pigeon = info.toPigeon();
      expect(pigeon.cacheKey, 'key');
      expect(pigeon.buildId, 'build');
      expect(pigeon.presentation!.style, PPaywallPresentationStyle.popup);
      expect(pigeon.presentation!.delay, 250);
      expect(pigeon.presentation!.height, 400);
      expect(pigeon.isScrollEnabled, isFalse);
      expect(pigeon.presentationId, 'presentation');
      expect(pigeon.isLocal, isTrue);
      expect(pigeon.introOfferEligibility, PIntroOfferEligibility.ineligible);
      expect(pigeon.products![0].store, PProductStore.custom);
      expect(pigeon.products![1].store, isNull);
    });

    test('PaywallInfo leaves the new fields null when native omits them', () {
      final info = PaywallInfo.fromPigeon(PPaywallInfo(identifier: 'pw1'))!;
      expect(info.presentation, isNull);
      expect(info.introOfferEligibility, isNull);
      expect(info.isLocal, isNull);
    });

    test('Entitlement maps the new fields and round-trips them', () {
      final renewsAt = DateTime.fromMillisecondsSinceEpoch(1800000000000);
      final entitlement = Entitlement.fromPigeon(PEntitlement(
        id: 'pro',
        type: PEntitlementType.serviceLevel,
        isActive: true,
        productIds: ['monthly'],
        store: PProductStore.custom,
        isRevoked: false,
        renewsAt: renewsAt.millisecondsSinceEpoch,
        isInGracePeriod: true,
      ));
      expect(entitlement.store, ProductStore.custom);
      expect(entitlement.isRevoked, isFalse);
      expect(entitlement.renewsAt, renewsAt);
      expect(entitlement.isInGracePeriod, isTrue);

      final pigeon = entitlement.toPigeon();
      expect(pigeon.store, PProductStore.custom);
      expect(pigeon.isRevoked, isFalse);
      expect(pigeon.renewsAt, renewsAt.millisecondsSinceEpoch);
      expect(pigeon.isInGracePeriod, isTrue);
    });

    test('StoreTransaction maps the new fields', () {
      final transaction = StoreTransaction.fromPigeon(PStoreTransaction(
        configRequestId: 'config',
        appSessionId: 'session',
        originalTransactionIdentifier: 'original',
        state: PStoreTransactionState.purchased,
        payment: PStorePayment(
            productIdentifier: 'monthly',
            quantity: 2,
            discountIdentifier: 'discount'),
        appAccountToken: 'token',
        purchaseToken: 'purchase-token',
        signature: 'signature',
      ));
      expect(transaction.state, StoreTransactionState.purchased);
      expect(transaction.payment!.productIdentifier, 'monthly');
      expect(transaction.payment!.quantity, 2);
      expect(transaction.payment!.discountIdentifier, 'discount');
      expect(transaction.appAccountToken, 'token');
      expect(transaction.purchaseToken, 'purchase-token');
      expect(transaction.signature, 'signature');

      final bare = StoreTransaction.fromPigeon(PStoreTransaction(
          configRequestId: 'config',
          appSessionId: 'session',
          originalTransactionIdentifier: 'original'));
      expect(bare.state, isNull);
      expect(bare.payment, isNull);
    });

    test('StoreProduct maps the new fields', () {
      final product = StoreProduct.fromPigeon(_product(
        subscriptionPeriod:
            PSubscriptionPeriod(value: 3, unit: PSubscriptionPeriodUnit.month),
        fullIdentifier: 'monthly:base:offer',
        productType: 'subs',
        storeFrontCountryCode: 'US',
        isCustomProduct: true,
        customTransactionId: 'custom-txn',
      ));
      expect(
          product.subscriptionPeriod,
          const SubscriptionPeriod(
              value: 3, unit: SubscriptionPeriodUnit.month));
      expect(product.fullIdentifier, 'monthly:base:offer');
      expect(product.productType, 'subs');
      expect(product.storeFrontCountryCode, 'US');
      expect(product.isCustomProduct, isTrue);
      expect(product.customTransactionId, 'custom-txn');

      final bare = StoreProduct.fromPigeon(_product());
      expect(bare.subscriptionPeriod, isNull);
      expect(bare.isCustomProduct, isNull);
    });

    test('RedemptionInfo maps userAttributes and the product identifier', () {
      final result = RedemptionResult.fromPigeon(PSuccessRedemptionResult(
        code: 'code',
        redemptionInfo: PRedemptionInfo(
          ownership: PAppUserOwnership(appUserId: 'user'),
          purchaserInfo: PPurchaserInfo(
            appUserId: 'user',
            storeIdentifiers:
                PUnknownStoreIdentifiers(store: 'store', additionalInfo: {}),
          ),
          paywallInfo: PRedemptionPaywallInfo(
            identifier: 'pw1',
            placementName: 'placement',
            placementParams: {},
            variantId: 'variant',
            experimentId: 'experiment',
            productIdentifier: 'monthly',
          ),
          entitlements: [],
          userAttributes: {'name': 'Jo'},
        ),
      )) as RedemptionResultSuccess;
      expect(result.redemptionInfo.userAttributes, {'name': 'Jo'});
      expect(result.redemptionInfo.paywallInfo!.identifier, 'pw1');
      expect(result.redemptionInfo.paywallInfo!.productIdentifier, 'monthly');
    });
  });

  group('events', () {
    test('every Pigeon event type maps to an EventType', () {
      for (final type in PEventType.values) {
        final event = SuperwallEventInfo.fromPEventInfo(
                PSuperwallEventInfo(eventType: type))
            .event;
        // paywallResourceLoadFail has no public case of its own.
        if (type != PEventType.paywallResourceLoadFail) {
          expect(event.type.name, type.name);
        }
      }
    });

    test('maps paywall page view events', () {
      final event = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.paywallPageView,
        paywallInfo: PPaywallInfo(identifier: 'pw1'),
        pageViewData: PPageViewData(
          pageNodeId: 'page2',
          flowPosition: 1,
          pageName: 'Plans',
          navigationNodeId: 'nav',
          previousPageNodeId: 'page1',
          previousFlowPosition: 0,
          navigationType: 'forward',
          timeOnPreviousPageMs: 1200,
        ),
      )).event;
      expect(event.type, EventType.paywallPageView);
      expect(event.paywallInfo!.identifier, 'pw1');
      final data = event.pageViewData!;
      expect(data.pageNodeId, 'page2');
      expect(data.flowPosition, 1);
      expect(data.pageName, 'Plans');
      expect(data.navigationNodeId, 'nav');
      expect(data.previousPageNodeId, 'page1');
      expect(data.previousFlowPosition, 0);
      expect(data.navigationType, 'forward');
      expect(data.timeOnPreviousPageMs, 1200);
    });

    test('maps the permission, preload and transaction type payloads', () {
      final permission = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.permissionGranted,
        permissionName: 'notification',
        paywallIdentifier: 'pw1',
      )).event;
      expect(permission.permissionName, 'notification');
      expect(permission.paywallIdentifier, 'pw1');

      final preload = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.paywallPreloadStart,
        paywallCount: 3,
      )).event;
      expect(preload.paywallCount, 3);

      final transaction = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.transactionComplete,
        transactionType: PTransactionType.freeTrialStart,
      )).event;
      expect(transaction.transactionType, TransactionType.freeTrialStart);
      expect(transaction.pageViewData, isNull);
      expect(preload.transactionType, isNull);
    });
  });

  group('PaywallPresentationHandler', () {
    test('onWillDismiss is called before onDismiss with the mapped values', () {
      final calls = <String>[];
      final handler = PaywallPresentationHandler()
        ..onWillDismiss((info, result) {
          calls.add('willDismiss ${info.identifier} ${result.runtimeType}');
        })
        ..onDismiss((info, result) {
          calls.add('dismiss ${info.identifier} ${result.runtimeType}');
        });
      final proxy = PaywallPresentationHandlerProxy(handler);

      proxy.onWillDismiss(
          PPaywallInfo(identifier: 'pw1'), PDeclinedPaywallResult());
      proxy.onDismiss(
          PPaywallInfo(identifier: 'pw1'), PDeclinedPaywallResult());

      expect(calls, [
        'willDismiss pw1 DeclinedPaywallResult',
        'dismiss pw1 DeclinedPaywallResult',
      ]);
    });

    test('onWillDismiss does nothing without a handler', () {
      final proxy = PaywallPresentationHandlerProxy(PaywallPresentationHandler());
      proxy.onWillDismiss(
          PPaywallInfo(identifier: 'pw1'), PDeclinedPaywallResult());
    });
  });

  group('round 2: Superwall', () {
    PCustomerInfo customerInfo(String userId) => PCustomerInfo(
        subscriptions: [],
        nonSubscriptions: [],
        entitlements: [],
        userId: userId);

    test('refreshCustomerInfo maps the native customer info', () async {
      final calls =
          mockHost('refreshCustomerInfo', reply: customerInfo('user1'));
      final info = await Superwall.shared.refreshCustomerInfo();
      expect(calls, hasLength(1));
      expect(info.userId, 'user1');
    });

    test('showAlert sends its arguments and returns the native result',
        () async {
      final calls = mockHost('showAlert', reply: true);
      expect(
          await Superwall.shared.showAlert(
              title: 'Title',
              message: 'Message',
              actionTitle: 'OK',
              closeActionTitle: 'Close'),
          isTrue);
      expect(calls.single, ['Title', 'Message', 'OK', 'Close']);

      final bare = mockHost('showAlert', reply: false);
      expect(await Superwall.shared.showAlert(), isFalse);
      expect(bare.single, [null, null, null, null]);
    });

    test('openRestoreOnWeb calls native', () async {
      final calls = mockHost('openRestoreOnWeb');
      await Superwall.shared.openRestoreOnWeb();
      expect(calls, hasLength(1));
    });

    test('getExternalAccountId returns the native value or null', () async {
      mockHost('getExternalAccountId', reply: 'account');
      expect(await Superwall.shared.getExternalAccountId(), 'account');
      mockHost('getExternalAccountId');
      expect(await Superwall.shared.getExternalAccountId(), isNull);
    });

    test('granted entitlements are mapped to and from Pigeon', () async {
      mockHost('getGrantedEntitlements', reply: [
        PEntitlement(
            id: 'pro',
            type: PEntitlementType.serviceLevel,
            isActive: true,
            productIds: []),
      ]);
      final granted = await Superwall.shared.getGrantedEntitlements();
      expect(granted.single.id, 'pro');

      final calls = mockHost('setGrantedEntitlements');
      await Superwall.shared.setGrantedEntitlements({Entitlement(id: 'vip')});
      final sent = (calls.single[0] as List).cast<PEntitlement>();
      expect(sent.single.id, 'vip');
      expect(sent.single.isActive, isTrue);
    });

    test('localResources is passed to configure only when set', () async {
      expect((await configuredOptions(SuperwallOptions())).localResources,
          isNull);
      final options = await configuredOptions(
          SuperwallOptions()..localResources = {'hero': '/tmp/hero.png'});
      expect(options.localResources, {'hero': '/tmp/hero.png'});
      expect(
          (SuperwallOptions()..localResources = {'hero': 'file:///hero.png'})
              .toJson()['localResources'],
          {'hero': 'file:///hero.png'});
    });
  });

  group('round 2: PaywallSkippedReason', () {
    test('maps every Pigeon reason', () {
      expect(PaywallSkippedReason.fromPigeon(PPaywallSkippedReason.holdout),
          isA<PaywallSkippedReasonHoldout>());
      expect(
          PaywallSkippedReason.fromPigeon(
              PPaywallSkippedReason.noAudienceMatch),
          isA<PaywallSkippedReasonNoAudienceMatch>());
      expect(
          PaywallSkippedReason.fromPigeon(
              PPaywallSkippedReason.placementNotFound),
          isA<PaywallSkippedReasonPlacementNotFound>());
      expect(
          PaywallSkippedReason.fromPigeon(
              PPaywallSkippedReason.userIsSubscribed),
          isA<PaywallSkippedReasonUserIsSubscribed>());
    });

    test('a holdout can still be created without an experiment', () {
      const holdout = PaywallSkippedReasonHoldout();
      expect(holdout.experiment, isNull);
    });

    test('onSkip passes the experiment of a holdout', () {
      final reasons = <PaywallSkippedReason>[];
      final proxy = PaywallPresentationHandlerProxy(
          PaywallPresentationHandler()..onSkip(reasons.add));

      proxy.onSkip(
          PPaywallSkippedReason.holdout,
          PExperiment(
              id: 'exp1',
              groupId: 'group1',
              variant: PVariant(id: 'var1', type: PVariantType.holdout)));
      proxy.onSkip(PPaywallSkippedReason.holdout, null);
      proxy.onSkip(PPaywallSkippedReason.userIsSubscribed, null);

      final holdout = reasons[0] as PaywallSkippedReasonHoldout;
      expect(holdout.experiment!.id, 'exp1');
      expect(holdout.experiment!.groupId, 'group1');
      expect((reasons[1] as PaywallSkippedReasonHoldout).experiment, isNull);
      expect(reasons[2], isA<PaywallSkippedReasonUserIsSubscribed>());
    });
  });

  group('round 2: models', () {
    test('StoreProduct maps discounts and the billing plan', () {
      PStoreProductDiscount discount(
              PStoreProductDiscountType type, String? offerIdentifier) =>
          PStoreProductDiscount(
            offerIdentifier: offerIdentifier,
            currencyCode: 'USD',
            price: 0.99,
            localizedPriceString: r'$0.99',
            paymentMode: PStoreProductDiscountPaymentMode.payUpFront,
            subscriptionPeriod: PSubscriptionPeriod(
                value: 1, unit: PSubscriptionPeriodUnit.week),
            numberOfPeriods: 2,
            type: type,
          );

      final product = StoreProduct.fromPigeon(_product(
        introductoryDiscount:
            discount(PStoreProductDiscountType.introductory, null),
        discounts: [discount(PStoreProductDiscountType.promotional, 'promo')],
        billingPlanType: PBillingPlanType.monthly,
        isBillingPlanAvailable: true,
      ));

      final intro = product.introductoryDiscount!;
      expect(intro.offerIdentifier, isNull);
      expect(intro.currencyCode, 'USD');
      expect(intro.price, 0.99);
      expect(intro.localizedPriceString, r'$0.99');
      expect(intro.paymentMode, StoreProductDiscountPaymentMode.payUpFront);
      expect(
          intro.subscriptionPeriod,
          const SubscriptionPeriod(
              value: 1, unit: SubscriptionPeriodUnit.week));
      expect(intro.numberOfPeriods, 2);
      expect(intro.type, StoreProductDiscountType.introductory);
      expect(product.discounts!.single.offerIdentifier, 'promo');
      expect(
          product.discounts!.single.type, StoreProductDiscountType.promotional);
      expect(product.billingPlanType, BillingPlanType.monthly);
      expect(product.isBillingPlanAvailable, isTrue);

      final bare = StoreProduct.fromPigeon(_product());
      expect(bare.introductoryDiscount, isNull);
      expect(bare.discounts, isNull);
      expect(bare.billingPlanType, isNull);
    });

    test('discount enums map from the Pigeon case with the same name', () {
      for (final value in PBillingPlanType.values) {
        expect(BillingPlanType.fromPigeon(value).name, value.name);
      }
      for (final value in PStoreProductDiscountPaymentMode.values) {
        expect(StoreProductDiscountPaymentMode.fromPigeon(value).name,
            value.name);
      }
      for (final value in PStoreProductDiscountType.values) {
        expect(StoreProductDiscountType.fromPigeon(value).name, value.name);
      }
      for (final value in PCustomerCenterScreenType.values) {
        expect(CustomerCenterScreenType.fromPigeon(value).name, value.name);
      }
      for (final value in PCustomerCenterPresentationStyle.values) {
        expect(CustomerCenterPresentationStyle.fromPigeon(value).name,
            value.name);
      }
    });

    test('RedemptionPaywallInfo maps the purchased product', () {
      final info = RedemptionPaywallInfo.fromPigeon(PRedemptionPaywallInfo(
        identifier: 'pw1',
        placementName: 'placement',
        placementParams: {},
        variantId: 'variant',
        experimentId: 'experiment',
        product: PRedemptionPaywallProduct(
          identifier: 'monthly',
          languageCode: 'en',
          locale: 'en_US',
          currencyCode: 'USD',
          currencySymbol: r'$',
          period: 'month',
          periodly: 'monthly',
          localizedPeriod: '1 month',
          periodAlt: '1mo',
          periodDays: 30,
          periodWeeks: 4,
          periodMonths: 1,
          periodYears: 0,
          rawPrice: 4.99,
          price: r'$4.99',
          dailyPrice: r'$0.16',
          weeklyPrice: r'$1.24',
          monthlyPrice: r'$4.99',
          yearlyPrice: r'$59.88',
          rawTrialPeriodPrice: 0,
          trialPeriodPrice: r'$0.00',
          trialPeriodDailyPrice: r'$0.01',
          trialPeriodWeeklyPrice: r'$0.02',
          trialPeriodMonthlyPrice: r'$0.03',
          trialPeriodYearlyPrice: r'$0.04',
          trialPeriodDays: 7,
          trialPeriodWeeks: 1,
          trialPeriodMonths: 0,
          trialPeriodYears: 0,
          trialPeriodText: '7-day',
          trialPeriodEndDate: 'Jan 8, 2026',
        ),
      ));
      final product = info.product!;
      expect(product.identifier, 'monthly');
      expect(product.languageCode, 'en');
      expect(product.locale, 'en_US');
      expect(product.currencyCode, 'USD');
      expect(product.currencySymbol, r'$');
      expect(product.period, 'month');
      expect(product.periodly, 'monthly');
      expect(product.localizedPeriod, '1 month');
      expect(product.periodAlt, '1mo');
      expect(product.periodDays, 30);
      expect(product.periodWeeks, 4);
      expect(product.periodMonths, 1);
      expect(product.periodYears, 0);
      expect(product.rawPrice, 4.99);
      expect(product.price, r'$4.99');
      expect(product.dailyPrice, r'$0.16');
      expect(product.weeklyPrice, r'$1.24');
      expect(product.monthlyPrice, r'$4.99');
      expect(product.yearlyPrice, r'$59.88');
      expect(product.rawTrialPeriodPrice, 0);
      expect(product.trialPeriodPrice, r'$0.00');
      expect(product.trialPeriodDailyPrice, r'$0.01');
      expect(product.trialPeriodWeeklyPrice, r'$0.02');
      expect(product.trialPeriodMonthlyPrice, r'$0.03');
      expect(product.trialPeriodYearlyPrice, r'$0.04');
      expect(product.trialPeriodDays, 7);
      expect(product.trialPeriodWeeks, 1);
      expect(product.trialPeriodMonths, 0);
      expect(product.trialPeriodYears, 0);
      expect(product.trialPeriodText, '7-day');
      expect(product.trialPeriodEndDate, 'Jan 8, 2026');
    });
  });

  group('round 2: events', () {
    test('maps the attribution match payload', () {
      final event = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.attributionMatch,
        attributionMatchInfo: PAttributionMatchInfo(
            provider: 'mmp',
            matched: true,
            source: 'meta',
            confidence: 'high',
            matchScore: 0.9,
            reason: 'click'),
      )).event;
      final info = event.attributionMatchInfo!;
      expect(info.provider, 'mmp');
      expect(info.matched, isTrue);
      expect(info.source, 'meta');
      expect(info.confidence, 'high');
      expect(info.matchScore, 0.9);
      expect(info.reason, 'click');
    });

    test('maps the Customer Center payloads', () {
      final open = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.customerCenterOpen,
        customerCenterScreen: PCustomerCenterScreenType.noPurchases,
        customerCenterPresentationStyle: PCustomerCenterPresentationStyle.sheet,
      )).event;
      expect(open.customerCenterScreen, CustomerCenterScreenType.noPurchases);
      expect(open.customerCenterPresentationStyle,
          CustomerCenterPresentationStyle.sheet);

      final survey = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.customerCenterSurveyResponse,
        customerCenterAction: PCustomerCenterCustomAction(identifier: 'custom'),
        customerCenterPathId: 'path',
        customerCenterProductId: 'monthly',
        customerCenterSurveyId: 'survey',
        customerCenterSurveyOptionId: 'option',
      )).event;
      expect(
          (survey.customerCenterAction as CustomerCenterActionCustom)
              .identifier,
          'custom');
      expect(survey.customerCenterPathId, 'path');
      expect(survey.customerCenterProductId, 'monthly');
      expect(survey.customerCenterSurveyId, 'survey');
      expect(survey.customerCenterSurveyOptionId, 'option');

      final refund = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.customerCenterRefundRequest,
        customerCenterRefundStatus: PCustomerCenterRefundStatus.userCancelled,
      )).event;
      expect(refund.customerCenterRefundStatus,
          CustomerCenterRefundStatus.userCancelled);
      expect(refund.customerCenterAction, isNull);
      expect(refund.customerCenterScreen, isNull);
    });

    test('maps the customer info, resource URL and shimmer payloads', () {
      PCustomerInfo customerInfo(String userId) => PCustomerInfo(
          subscriptions: [],
          nonSubscriptions: [],
          entitlements: [],
          userId: userId);

      final changed = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.customerInfoDidChange,
        fromCustomerInfo: customerInfo('before'),
        toCustomerInfo: customerInfo('after'),
      )).event;
      expect(changed.fromCustomerInfo!.userId, 'before');
      expect(changed.toCustomerInfo!.userId, 'after');

      final resource = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.paywallResourceLoadFail,
        resourceUrl: 'https://example.com/a.png',
      )).event;
      expect(resource.resourceUrl, 'https://example.com/a.png');

      final shimmer = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.shimmerViewComplete,
        shimmerDuration: 1250.5,
      )).event;
      expect(shimmer.shimmerDuration, const Duration(microseconds: 1250500));
      expect(shimmer.fromCustomerInfo, isNull);
      expect(changed.shimmerDuration, isNull);
    });
  });
}
