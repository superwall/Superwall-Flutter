import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final String apiKey = 'pk_6d16c4c892b1e792490ab8bfe831f1ad96e7c18aee7a5257';

  group('Superwall SDK Methods Tests', () {
    setUpAll(() async {
      final options = SuperwallOptions();
      options.logging = Logging()..level = LogLevel.debug;

      final completer = Completer<void>();

      Superwall.configure(apiKey, options: options, completion: () {
        print('Superwall configured for testing');
        completer.complete();
        return;
      });

      await completer.future;
    });

    testWidgets('setUserAttributes and getUserAttributes',
        (WidgetTester tester) async {
      final testAttributes = {
        'testKey1': 'testValue1',
        'testKey2': 123,
        'testKey3': true
      };

      await Superwall.shared.setUserAttributes(testAttributes);

      final attributes = await Superwall.shared.getUserAttributes();

      expect(attributes['testKey1'], 'testValue1');
      expect(attributes['testKey2'], 123);
      expect(attributes['testKey3'], true);
    });

    testWidgets('setLocaleIdentifier and getLocaleIdentifier',
        (WidgetTester tester) async {
      const testLocale = 'fr_FR';

      await Superwall.shared.setLocaleIdentifier(testLocale);

      final locale = await Superwall.shared.getLocaleIdentifier();

      expect(locale, testLocale);

      await Superwall.shared.setLocaleIdentifier(null);
      final resetLocale = await Superwall.shared.getLocaleIdentifier();

      expect(resetLocale != testLocale, true);
    });

    testWidgets('identify, getUserId, and getIsLoggedIn',
        (WidgetTester tester) async {
      const testUserId = 'test_user_123';

      await Superwall.shared.identify(testUserId);

      final userId = await Superwall.shared.getUserId();

      expect(userId, testUserId);

      final isLoggedIn = await Superwall.shared.getIsLoggedIn();

      expect(isLoggedIn, true);
    });

    testWidgets('reset method clears user data', (WidgetTester tester) async {
      const testUserId = 'reset_test_user';
      final testAttributes = {'resetTest': 'value'};

      await Superwall.shared.identify(testUserId);
      await Superwall.shared.setUserAttributes(testAttributes);

      final initialUserId = await Superwall.shared.getUserId();
      final initialAttributes = await Superwall.shared.getUserAttributes();

      expect(initialUserId, testUserId);
      expect(initialAttributes['resetTest'], 'value');

      await Superwall.shared.reset();

      final resetUserId = await Superwall.shared.getUserId();
      final resetAttributes = await Superwall.shared.getUserAttributes();
      final isLoggedIn = await Superwall.shared.getIsLoggedIn();

      expect(resetUserId != testUserId, true);

      expect(resetAttributes['resetTest'], null);

      expect(isLoggedIn, false);
    });

    testWidgets('getIsInitialized', (WidgetTester tester) async {
      final isInitialized = await Superwall.shared.getIsInitialized();

      expect(isInitialized, true);
    });

    testWidgets('getEntitlements', (WidgetTester tester) async {
      final entitlements = await Superwall.shared.getEntitlements();

      expect(entitlements, isNotNull);
      expect(entitlements.all, isNotNull);
      expect(entitlements.active, isNotNull);
      expect(entitlements.inactive, isNotNull);
    });

    testWidgets('getLatestPaywallInfo', (WidgetTester tester) async {
      final paywallInfo = await Superwall.shared.getLatestPaywallInfo();
    });

    testWidgets('getSubscriptionStatus and setSubscriptionStatus',
        (WidgetTester tester) async {
      await Superwall.shared.setSubscriptionStatus(SubscriptionStatus.unknown);

      var status = await Superwall.shared.getSubscriptionStatus();

      expect(status, isNotNull);

      await Superwall.shared.setSubscriptionStatus(SubscriptionStatus.unknown);

      status = await Superwall.shared.getSubscriptionStatus();

      expect(status, isNotNull);
    });

    testWidgets('getIsConfigured', (WidgetTester tester) async {
      await Future.delayed(const Duration(seconds: 3));

      final isConfigured = await Superwall.shared.getIsConfigured();

      expect(isConfigured, true);
    });

    testWidgets('getLogLevel and setLogLevel', (WidgetTester tester) async {
      await Superwall.shared.setLogLevel(LogLevel.info);

      final logLevel = await Superwall.shared.getLogLevel();

      expect(logLevel, LogLevel.info);

      await Superwall.shared.setLogLevel(LogLevel.error);

      final updatedLogLevel = await Superwall.shared.getLogLevel();

      expect(updatedLogLevel, LogLevel.error);
    });

    testWidgets('confirmAllAssignments', (WidgetTester tester) async {
      final assignments = await Superwall.shared.confirmAllAssignments();

      expect(assignments, isNotNull);

      expect(assignments, isA<Set>());
    });
  });
}
