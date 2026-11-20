import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';
import 'package:superwallkit_flutter_example/delegate/TestDelegate.dart';
import 'package:superwallkit_flutter_example/delegate/TestDelegateEvent.dart';

/// Records every Superwall event the delegate receives.
class _RecordingDelegate extends TestDelegate {
  List<SuperwallEventInfo> get superwallEvents => events
      .whereType<HandleSuperwallEventEvent>()
      .map((e) => e.eventInfo)
      .toList();

  Set<EventType> get types => superwallEvents.map((e) => e.event.type).toSet();
}

/// Pumps real frames until [condition] holds or [timeout] passes.
Future<bool> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    if (condition()) return true;
    await tester.pump(const Duration(milliseconds: 100));
  }
  return condition();
}

/// Smoke tests for what the 2.9.0 release added or fixed.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final apiKey = Platform.isIOS
      ? 'pk_25605698906751f5383385f9976e21f840d44aa11cd4639c'
      : 'pk_6d16c4c892b1e792490ab8bfe831f1ad96e7c18aee7a5257';

  final delegate = _RecordingDelegate();

  setUpAll(() async {
    final options = SuperwallOptions();
    // Not the default (info) and not debug, so a forced level shows up.
    options.logging = Logging()..level = LogLevel.warn;

    final completer = Completer<void>();
    Superwall.configure(apiKey, options: options, completion: () {
      completer.complete();
    });
    await completer.future;
    Superwall.shared.setDelegate(delegate);
  });

  testWidgets('the configured log level is respected', (tester) async {
    expect(await Superwall.shared.getLogLevel(), LogLevel.warn);
  });

  testWidgets('getAssignments', (tester) async {
    final confirmed = await Superwall.shared.confirmAllAssignments();
    final assignments = await Superwall.shared.getAssignments();
    expect(assignments, isA<Set<ConfirmedAssignment>>());
    print('confirmed=${confirmed.length} assignments=${assignments.length}');
  });

  testWidgets('refreshConfiguration', (tester) async {
    await Superwall.shared.refreshConfiguration();
    expect(await Superwall.shared.getIsConfigured(), true);
  });

  testWidgets('refreshCustomerInfo', (tester) async {
    final cached = await Superwall.shared.getCustomerInfo();
    final fresh = await Superwall.shared.refreshCustomerInfo();
    expect(fresh, isA<CustomerInfo>());
    print('cached userId=${cached.userId} fresh userId=${fresh.userId} '
        'subscriptions=${fresh.subscriptions.length} '
        'entitlements=${fresh.entitlements.length}');
  });

  testWidgets('setEventTrackingBehavior round-trips', (tester) async {
    for (final behavior in [
      EventTrackingBehavior.superwallOnly,
      EventTrackingBehavior.none,
      EventTrackingBehavior.all,
    ]) {
      await Superwall.shared.setEventTrackingBehavior(behavior);
      expect(await Superwall.shared.getEventTrackingBehavior(), behavior);
    }
  });

  testWidgets('setInterfaceStyle light, dark and null', (tester) async {
    await Superwall.shared.setInterfaceStyle(InterfaceStyle.light);
    await Superwall.shared.setInterfaceStyle(InterfaceStyle.dark);
    await Superwall.shared.setInterfaceStyle(null);
  });

  testWidgets('setUserAttributes with null removes the attribute',
      (tester) async {
    await Superwall.shared
        .setUserAttributes({'removeMe': 'value', 'keepMe': 'kept'});
    var attributes = await Superwall.shared.getUserAttributes();
    expect(attributes['removeMe'], 'value');

    await Superwall.shared.setUserAttributes({'removeMe': null});
    attributes = await Superwall.shared.getUserAttributes();
    print('removeMe after null: present=${attributes.containsKey('removeMe')} '
        'value=${attributes['removeMe']}');
    expect(attributes.containsKey('removeMe'), false);
    expect(attributes['keepMe'], 'kept');
  });

  testWidgets('integration attributes reach the SDK', (tester) async {
    await Superwall.shared.setIntegrationAttribute(
        IntegrationAttribute.mixpanelDistinctId, 'mixpanel_123');
    await Superwall.shared.setIntegrationAttributes({
      IntegrationAttribute.amplitudeUserId: 'amp_456',
      IntegrationAttribute.adjustId: 'adjust_789',
    });

    var attributes = await Superwall.shared.getIntegrationAttributes();
    print('integration attributes straight after setting: $attributes');
    // The native SDKs may apply these off the calling thread.
    for (var i = 0; i < 30 && attributes.length < 3; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      attributes = await Superwall.shared.getIntegrationAttributes();
    }
    print('integration attributes: $attributes');
    expect(attributes.values,
        containsAll(['mixpanel_123', 'amp_456', 'adjust_789']));

    await Superwall.shared
        .setIntegrationAttribute(IntegrationAttribute.adjustId, null);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    attributes = await Superwall.shared.getIntegrationAttributes();
    print('after removing adjustId: $attributes');
    expect(attributes.values, isNot(contains('adjust_789')));
    expect(attributes.values, containsAll(['mixpanel_123', 'amp_456']));
  });

  testWidgets('granted entitlements round-trip and survive reset',
      (tester) async {
    await Superwall.shared
        .setGrantedEntitlements({Entitlement(id: 'granted_pro')});
    var granted = await Superwall.shared.getGrantedEntitlements();
    expect(granted.map((e) => e.id), contains('granted_pro'));

    await Superwall.shared.reset();
    granted = await Superwall.shared.getGrantedEntitlements();
    expect(granted.map((e) => e.id), contains('granted_pro'));

    await Superwall.shared.setGrantedEntitlements({});
    expect(await Superwall.shared.getGrantedEntitlements(), isEmpty);
  }, skip: !Platform.isIOS);

  testWidgets('push calls do not throw', (tester) async {
    await Superwall.shared.setPushToken('test_fcm_token');
    await Superwall.shared.handleNotificationOpen({'unrelated': 'payload'});
    await Superwall.shared.optOutOfNotifications();
    await Superwall.shared.optInToNotifications();
  });

  testWidgets('showAlert resolves false when no paywall is showing',
      (tester) async {
    final result = await Superwall.shared
        .showAlert(title: 'Title', message: 'Message', actionTitle: 'OK')
        .timeout(const Duration(seconds: 5));
    expect(result, false);
  });

  testWidgets('embedded PaywallView presents with nested map params',
      (tester) async {
    PaywallInfo? presented;
    String? error;
    PaywallSkippedReason? skipped;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PaywallView(
          placement: 'non_gated_paywall',
          params: const {
            'flat': 'value',
            'count': 3,
            'nested': {
              'inner': 'value',
              'deeper': {'flag': true, 'n': 1.5},
              'list': [
                1,
                'two',
                {'three': 3}
              ],
            },
          },
          onPresent: (info) => presented = info,
          onError: (e) => error = e,
          onSkip: (reason) => skipped = reason,
        ),
      ),
    ));

    await pumpUntil(
        tester, () => presented != null || error != null || skipped != null);
    expect(error, isNull);
    expect(skipped, isNull);
    expect(presented, isNotNull);

    // Removing the widget while the paywall is up must not crash.
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump(const Duration(seconds: 1));
    expect(await Superwall.shared.getIsConfigured(), true);
  });

  testWidgets('embedded PaywallView shows the skipped builder', (tester) async {
    PaywallSkippedReason? skipped;
    String? error;
    PaywallInfo? presented;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PaywallView(
          placement: 'skip_audience',
          onSkip: (reason) => skipped = reason,
          onError: (e) => error = e,
          onPresent: (info) => presented = info,
          skippedBuilder: (context, reason) => const Text('SKIPPED_BUILDER'),
        ),
      ),
    ));

    await pumpUntil(
        tester, () => skipped != null || error != null || presented != null);
    await tester.pump(const Duration(milliseconds: 300));
    print('skip reason: ${skipped.runtimeType} error: $error '
        'presented: ${presented?.identifier}');
    expect(skipped, isNotNull);
    expect(find.text('SKIPPED_BUILDER'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
  });

  testWidgets('a subscribed user skips a gated paywall as UserIsSubscribed',
      (tester) async {
    await Superwall.shared.setSubscriptionStatus(SubscriptionStatusActive(
        entitlements: {
          Entitlement(id: 'pro'),
          Entitlement(id: 'test_entitlement')
        }));

    await tester.pump(const Duration(seconds: 1));
    final status = await Superwall.shared.getSubscriptionStatus();
    print('status before register: ${status.runtimeType}');

    PaywallSkippedReason? skipped;
    PaywallInfo? presented;
    String? error;
    final handler = PaywallPresentationHandler()
      ..onSkip((reason) => skipped = reason)
      ..onPresent((info) => presented = info)
      ..onError((e) => error = e);

    unawaited(
        Superwall.shared.registerPlacement('gated_paywall', handler: handler));
    await pumpUntil(
        tester, () => skipped != null || presented != null || error != null);

    final wasPresented = presented != null;
    print('subscribed result: skipped=${skipped.runtimeType} '
        'presented=${presented?.identifier} error=$error');
    if (wasPresented) await Superwall.shared.dismiss();
    await Superwall.shared.setSubscriptionStatus(SubscriptionStatusInactive());

    expect(error, isNull);
    expect(wasPresented, false);
    expect(skipped, isA<PaywallSkippedReasonUserIsSubscribed>());
    // The test dashboard has no placement that skips for subscribers:
    // `gated_paywall` still presents and `non_gated_paywall` reports
    // NoAudienceMatch. Enable once a placement is set up for it.
  }, skip: true);

  testWidgets('delegate events arrive under their own types', (tester) async {
    await tester.pump(const Duration(seconds: 2));
    final types = delegate.types;
    final names = delegate.superwallEvents
        .where((e) => e.event.type == EventType.customPlacement)
        .map((e) => e.event.name ?? e.event.placementName)
        .toSet();
    print('event types seen: ${types.map((t) => t.name).toList()..sort()}');
    print('customPlacement names seen: $names');

    // Nothing in this run tracks a custom placement, so any customPlacement
    // event is a native event that fell through the type mapping.
    expect(names, isEmpty);
  });
}
