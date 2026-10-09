import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

const _prefix = 'dev.flutter.pigeon.superwallkit_flutter.PSuperwallHostApi';
const _delegatePrefix =
    'dev.flutter.pigeon.superwallkit_flutter.PCustomerCenterDelegateGenerated';
const _codec = PSuperwallHostApi.pigeonChannelCodec;

class _RecordingDelegate extends CustomerCenterDelegate {
  final events = <String>[];
  bool allowRestore = true;
  CustomerCenterAction? action;
  String? pathId;
  CustomerCenterPurchase? purchase;
  CustomerCenterRefundStatus? refundStatus;

  @override
  Future<bool> customerCenterShouldRestorePurchases() async {
    events.add('shouldRestore');
    return allowRestore;
  }

  @override
  void customerCenterDidSelectAction(CustomerCenterAction action, String pathId,
      CustomerCenterPurchase? purchase) {
    events.add('didSelectAction');
    this.action = action;
    this.pathId = pathId;
    this.purchase = purchase;
  }

  @override
  void customerCenterDidCompleteSurvey(String surveyId, String optionId,
      CustomerCenterAction action, String pathId) {
    events.add('didCompleteSurvey:$surveyId:$optionId:$pathId');
  }

  @override
  void customerCenterDidCompleteRefundRequest(
      String productId, CustomerCenterRefundStatus status) {
    events.add('didCompleteRefundRequest:$productId');
    refundStatus = status;
  }

  @override
  void customerCenterDidDismiss() {
    events.add('didDismiss');
  }
}

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

  /// Sends a message from "native" to the Flutter delegate registered under
  /// [hostId] and returns the decoded reply envelope.
  Future<List<Object?>?> callDelegate(
      String hostId, String method, List<Object?> args) async {
    final completer = <List<Object?>?>[];
    await messenger.handlePlatformMessage(
      '$_delegatePrefix.$method.$hostId',
      _codec.encodeMessage(args),
      (reply) => completer.add(
          reply == null ? null : _codec.decodeMessage(reply) as List<Object?>?),
    );
    return completer.single;
  }

  setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('presentCustomerCenter', () {
    test('converts the configuration for the native SDK', () async {
      final calls = mockHost('presentCustomerCenter');

      await Superwall.shared.presentCustomerCenter(
        configuration: CustomerCenterConfiguration(
          managementScreen: CustomerCenterScreen(title: 'Manage', paths: [
            CustomerCenterPath.restore(),
            CustomerCenterPath.refund(window: const Duration(days: 2)),
            CustomerCenterPath.changePlan(productIds: ['pro_yearly']),
            CustomerCenterPath.manageSubscription(
                survey: CustomerCenterFeedbackSurvey.cancellation),
            CustomerCenterPath.url('https://example.com/faq',
                title: 'FAQ', openMethod: CustomerCenterOpenMethod.external),
            CustomerCenterPath.custom('chat', title: 'Chat', id: 'chat_path'),
          ]),
          noPurchasesScreen: CustomerCenterScreen(
              subtitle: 'Nothing here',
              paths: [CustomerCenterPath.contactSupport()]),
          support: const CustomerCenterSupport(
              email: 'help@example.com', warnsAboutUpdates: false),
          appearance: const CustomerCenterAppearance(
              accent:
                  CustomerCenterColorPair(light: '#FF0000', dark: '#00FF00')),
          showsAccountDetails: false,
        ),
      );

      final config = calls.single[0] as PCustomerCenterConfiguration;
      expect(calls.single[1], isA<PCustomerCenterDelegateHost>());
      expect(config.managementScreen.title, 'Manage');
      final paths = config.managementScreen.paths;
      expect(paths[0].type, isA<PCustomerCenterRestorePathType>());
      expect(paths[0].id, isNull);
      expect((paths[1].type as PCustomerCenterRefundPathType).windowMillis,
          const Duration(days: 2).inMilliseconds);
      expect((paths[2].type as PCustomerCenterChangePlanPathType).productIds,
          ['pro_yearly']);
      expect(paths[3].survey!.id, 'cancel_survey');
      expect(paths[3].survey!.options.map((o) => o.id),
          ['too_expensive', 'dont_use', 'bought_by_mistake']);
      final url = paths[4].type as PCustomerCenterUrlPathType;
      expect(url.url, 'https://example.com/faq');
      expect(url.openMethod, PCustomerCenterOpenMethod.external);
      expect(paths[4].title, 'FAQ');
      expect(
          (paths[5].type as PCustomerCenterCustomPathType).identifier, 'chat');
      expect(paths[5].id, 'chat_path');
      expect(config.noPurchasesScreen.subtitle, 'Nothing here');
      expect(config.noPurchasesScreen.paths.single.type,
          isA<PCustomerCenterContactSupportPathType>());
      expect(config.support.email, 'help@example.com');
      expect(config.support.warnsAboutUpdates, isFalse);
      expect(config.accent!.light, '#FF0000');
      expect(config.accent!.dark, '#00FF00');
      expect(config.showsAccountDetails, isFalse);
      expect(config.warnsAboutDuplicateSubscriptions, isTrue);
    });

    test('passes no configuration when none is given', () async {
      final calls = mockHost('presentCustomerCenter');
      await Superwall.shared.presentCustomerCenter();
      expect(calls.single[0], isNull);
    });

    test('forwards native delegate callbacks and onDismiss', () async {
      final calls = mockHost('presentCustomerCenter');
      final delegate = _RecordingDelegate()..allowRestore = false;
      var dismissed = 0;

      await Superwall.shared.presentCustomerCenter(
          delegate: delegate, onDismiss: () => dismissed++);
      final hostId = (calls.single[1] as PCustomerCenterDelegateHost).hostId!;

      final restoreReply =
          await callDelegate(hostId, 'shouldRestorePurchases', []);
      expect(restoreReply, [false]);

      await callDelegate(hostId, 'didSelectAction', [
        PCustomerCenterRefundAction(),
        'refund',
        PCustomerCenterPurchase(
          productId: 'pro_monthly',
          store: PProductStore.playStore,
          entitlements: [
            PEntitlement(
                id: 'pro',
                type: PEntitlementType.serviceLevel,
                isActive: true,
                productIds: ['pro_monthly']),
          ],
          subscription: PSubscriptionTransaction(
            transactionId: 'GPA.1',
            productId: 'pro_monthly',
            purchaseDate: 1700000000000,
            willRenew: true,
            isRevoked: false,
            isInGracePeriod: false,
            isInBillingRetryPeriod: false,
            isActive: true,
          ),
        ),
      ]);
      expect(delegate.action, isA<CustomerCenterActionRefund>());
      expect(delegate.pathId, 'refund');
      expect(delegate.purchase!.productId, 'pro_monthly');
      expect(delegate.purchase!.store, ProductStore.playStore);
      expect(delegate.purchase!.entitlements.single.id, 'pro');
      expect(delegate.purchase!.subscription!.transactionId, 'GPA.1');
      expect(delegate.purchase!.nonSubscription, isNull);

      await callDelegate(hostId, 'didSelectAction',
          [PCustomerCenterCustomAction(identifier: 'chat'), 'chat', null]);
      expect(
          (delegate.action as CustomerCenterActionCustom).identifier, 'chat');
      expect(delegate.purchase, isNull);

      await callDelegate(hostId, 'didCompleteSurvey', [
        'cancel_survey',
        'too_expensive',
        PCustomerCenterManageSubscriptionAction(),
        'manage_subscription'
      ]);
      await callDelegate(hostId, 'didCompleteRefundRequest',
          ['pro_monthly', PCustomerCenterRefundStatus.success]);
      expect(delegate.refundStatus, CustomerCenterRefundStatus.success);

      await callDelegate(hostId, 'didDismiss', []);
      await callDelegate(hostId, 'onDismiss', []);
      expect(dismissed, 1);
      expect(delegate.events, [
        'shouldRestore',
        'didSelectAction',
        'didSelectAction',
        'didCompleteSurvey:cancel_survey:too_expensive:manage_subscription',
        'didCompleteRefundRequest:pro_monthly',
        'didDismiss',
      ]);

      // The delegate is released once the Customer Center has been dismissed.
      expect(await callDelegate(hostId, 'didDismiss', []), isNull);
      expect(delegate.events.last, 'didDismiss');
      expect(delegate.events.where((e) => e == 'didDismiss'), hasLength(1));
    });

    test('restores by default without a delegate', () async {
      final calls = mockHost('presentCustomerCenter');
      await Superwall.shared.presentCustomerCenter();
      final hostId = (calls.single[1] as PCustomerCenterDelegateHost).hostId!;
      expect(await callDelegate(hostId, 'shouldRestorePurchases', []), [true]);
    });

    test('each presentation gets its own delegate channel', () async {
      final calls = mockHost('presentCustomerCenter');
      await Superwall.shared.presentCustomerCenter();
      await Superwall.shared.presentCustomerCenter();
      final ids = calls
          .map((c) => (c[1] as PCustomerCenterDelegateHost).hostId)
          .toSet();
      expect(ids, hasLength(2));
    });

    test('throws UnsupportedError on iOS without calling native', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final calls = mockHost('presentCustomerCenter');
      expect(Superwall.shared.presentCustomerCenter(),
          throwsA(isA<UnsupportedError>()));
      expect(calls, isEmpty);
    });
  });

  group('dismissCustomerCenter', () {
    test('Android: calls native', () async {
      final calls = mockHost('dismissCustomerCenter');
      await Superwall.shared.dismissCustomerCenter();
      expect(calls, hasLength(1));
    });

    test('throws UnsupportedError on iOS without calling native', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final calls = mockHost('dismissCustomerCenter');
      expect(Superwall.shared.dismissCustomerCenter(),
          throwsA(isA<UnsupportedError>()));
      expect(calls, isEmpty);
    });
  });

  test('SuperwallOptions.customerCenter is passed to configure', () async {
    final calls = mockHost('configure');
    Superwall.configure('pk_test',
        options: SuperwallOptions()
          ..customerCenter = CustomerCenterConfiguration(
            managementScreen:
                CustomerCenterScreen(paths: [CustomerCenterPath.restore()]),
            noPurchasesScreen:
                CustomerCenterScreen(paths: [CustomerCenterPath.restore()]),
            support: const CustomerCenterSupport(email: 'help@example.com'),
          ));
    await pumpEventQueue();

    final options = calls.single[2] as PSuperwallOptions;
    expect(options.customerCenter!.support.email, 'help@example.com');
    expect(options.customerCenter!.managementScreen.paths.single.type,
        isA<PCustomerCenterRestorePathType>());
  });

  test('default configuration matches the native default', () {
    final config = CustomerCenterConfiguration.defaultConfiguration;
    expect(config.managementScreen.paths.map((p) => p.type.runtimeType), [
      CustomerCenterPathTypeRestore,
      CustomerCenterPathTypeChangePlan,
      CustomerCenterPathTypeRefund,
      CustomerCenterPathTypeManageSubscription,
      CustomerCenterPathTypeContactSupport,
    ]);
    expect(config.managementScreen.paths[3].survey,
        CustomerCenterFeedbackSurvey.cancellation);
    expect(config.noPurchasesScreen.paths.single.type,
        isA<CustomerCenterPathTypeRestore>());
  });

  test('maps Customer Center events', () {
    final cases = {
      PEventType.customerCenterOpen: EventType.customerCenterOpen,
      PEventType.customerCenterClose: EventType.customerCenterClose,
      PEventType.customerCenterAction: EventType.customerCenterAction,
      PEventType.customerCenterSurveyResponse:
          EventType.customerCenterSurveyResponse,
      PEventType.customerCenterRefundRequest:
          EventType.customerCenterRefundRequest,
    };
    cases.forEach((native, expected) {
      final info = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
          eventType: native, params: {'path_id': 'refund'}));
      expect(info.event.type, expected);
      expect(info.params, {'path_id': 'refund'});
    });
  });
}
