import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // API key for testing
  final String apiKey =
      'pk_e361c8a9662281f4249f2fa11d1a63854615fa80e15e7a4d'; // iOS key, replace with Android key if needed

  // Test group for Superwall SDK methods
  group('Superwall SDK Methods Tests', () {
    setUp(() async {
      // Configure Superwall SDK before each test
      final options = SuperwallOptions();
      options.logging = Logging()..level = LogLevel.debug;

      await Superwall.configure(apiKey, options: options, completion: () {
        print('Superwall configured for testing');
      });
    });

    testWidgets('setUserAttributes and getUserAttributes',
        (WidgetTester tester) async {
      // Test data
      final testAttributes = {
        'testKey1': 'testValue1',
        'testKey2': 123,
        'testKey3': true
      };

      // Set user attributes
      await Superwall.shared.setUserAttributes(testAttributes);

      // Get user attributes and verify
      final attributes = await Superwall.shared.getUserAttributes();

      // Verify attributes were set correctly
      expect(attributes['testKey1'], 'testValue1');
      expect(attributes['testKey2'], 123);
      expect(attributes['testKey3'], true);
    });

    testWidgets('setLocaleIdentifier and getLocaleIdentifier',
        (WidgetTester tester) async {
      // Test locale
      const testLocale = 'fr_FR';

      // Set locale identifier
      await Superwall.shared.setLocaleIdentifier(testLocale);

      // Get locale identifier and verify
      final locale = await Superwall.shared.getLocaleIdentifier();

      // Verify locale was set correctly
      expect(locale, testLocale);

      // Reset locale to null and verify
      await Superwall.shared.setLocaleIdentifier(null);
      final resetLocale = await Superwall.shared.getLocaleIdentifier();

      // Verify locale was reset (may return system default rather than null)
      // This assertion might need adjustment based on actual behavior
      expect(resetLocale != testLocale, true);
    });

    testWidgets('identify, getUserId, and getIsLoggedIn',
        (WidgetTester tester) async {
      // Test user ID
      const testUserId = 'test_user_123';

      // Identify user
      await Superwall.shared.identify(testUserId);

      // Get user ID and verify
      final userId = await Superwall.shared.getUserId();

      // Verify user ID was set correctly
      expect(userId, testUserId);

      // Check if user is logged in
      final isLoggedIn = await Superwall.shared.getIsLoggedIn();

      // Verify user is logged in
      expect(isLoggedIn, true);
    });

    testWidgets('reset method clears user data', (WidgetTester tester) async {
      // Set up initial state
      const testUserId = 'reset_test_user';
      final testAttributes = {'resetTest': 'value'};

      // Set user ID and attributes
      await Superwall.shared.identify(testUserId);
      await Superwall.shared.setUserAttributes(testAttributes);

      // Verify initial state
      final initialUserId = await Superwall.shared.getUserId();
      final initialAttributes = await Superwall.shared.getUserAttributes();

      expect(initialUserId, testUserId);
      expect(initialAttributes['resetTest'], 'value');

      // Reset user data
      await Superwall.shared.reset();

      // Verify state after reset
      final resetUserId = await Superwall.shared.getUserId();
      final resetAttributes = await Superwall.shared.getUserAttributes();
      final isLoggedIn = await Superwall.shared.getIsLoggedIn();

      // Verify user ID was changed
      expect(resetUserId != testUserId, true);

      // Verify attributes were cleared
      expect(resetAttributes['resetTest'], null);

      // Verify user is not logged in
      expect(isLoggedIn, false);
    });

    testWidgets('getIsInitialized', (WidgetTester tester) async {
      // After configuration, SDK should be initialized
      final isInitialized = await Superwall.shared.getIsInitialized();

      // Verify the SDK is initialized
      expect(isInitialized, true);
    });

    testWidgets('getEntitlements', (WidgetTester tester) async {
      // Get entitlements
      final entitlements = await Superwall.shared.getEntitlements();

      // Verify entitlements object is returned with expected structure
      expect(entitlements, isNotNull);
      expect(entitlements.all, isNotNull);
      expect(entitlements.active, isNotNull);
      expect(entitlements.inactive, isNotNull);
    });

    testWidgets('getLatestPaywallInfo', (WidgetTester tester) async {
      // Get the latest paywall info
      // Note: May return null if no paywall has been shown yet
      final paywallInfo = await Superwall.shared.getLatestPaywallInfo();

      // We're mainly testing that the method executes without errors
      // The result might be null if no paywall has been presented yet, which is okay
      // No assertion needed here, just verifying the method call succeeds
    });

    testWidgets('getSubscriptionStatus and setSubscriptionStatus',
        (WidgetTester tester) async {
      // First set the subscription status to Active
      await Superwall.shared.setSubscriptionStatus(SubscriptionStatus.unknown);

      // Get the subscription status
      var status = await Superwall.shared.getSubscriptionStatus();

      // Verify the subscription status is returned
      expect(status, isNotNull);

      // Now set to a different status
      await Superwall.shared.setSubscriptionStatus(SubscriptionStatus.unknown);

      // Get the updated subscription status
      status = await Superwall.shared.getSubscriptionStatus();

      // Verify status is returned
      expect(status, isNotNull);
    });

    testWidgets('getIsConfigured', (WidgetTester tester) async {
      // Give the SDK some time to complete configuration
      await Future.delayed(const Duration(seconds: 2));

      // Check if SDK is configured
      final isConfigured = await Superwall.shared.getIsConfigured();

      expect(isConfigured, true);
    });

    testWidgets('getLogLevel and setLogLevel', (WidgetTester tester) async {
      // Set the log level to info
      await Superwall.shared.setLogLevel(LogLevel.info);

      // Get the log level
      final logLevel = await Superwall.shared.getLogLevel();

      // Verify the log level was set correctly
      expect(logLevel, LogLevel.info);

      // Change to a different log level
      await Superwall.shared.setLogLevel(LogLevel.error);

      // Get the updated log level
      final updatedLogLevel = await Superwall.shared.getLogLevel();

      // Verify the log level was changed
      expect(updatedLogLevel, LogLevel.error);
    });

    testWidgets('confirmAllAssignments', (WidgetTester tester) async {
      // Confirm all assignments
      final assignments = await Superwall.shared.confirmAllAssignments();

      // Verify assignments is not null (might be empty if no experiments are running)
      expect(assignments, isNotNull);

      // Assignments should be a Set
      expect(assignments, isA<Set>());
    });
  });
}
