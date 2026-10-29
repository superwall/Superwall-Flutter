import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

const _prefix = 'dev.flutter.pigeon.superwallkit_flutter.PSuperwallHostApi';
const _codec = PSuperwallHostApi.pigeonChannelCodec;

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

  setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('AdConsent', () {
    test('defaults to granted', () {
      const consent = AdConsent();
      expect(consent.adUserData, AdConsentStatus.granted);
      expect(consent.adPersonalization, AdConsentStatus.granted);
    });

    test('round-trips through Pigeon', () {
      const consent = AdConsent(
          adUserData: AdConsentStatus.granted,
          adPersonalization: AdConsentStatus.denied);
      final pigeon = consent.toPigeon();
      expect(pigeon.adUserData, PAdConsentStatus.granted);
      expect(pigeon.adPersonalization, PAdConsentStatus.denied);
      expect(AdConsent.fromPigeon(pigeon), consent);
    });

    test('iOS: setAdConsent calls native', () async {
      final calls = mockHost('setAdConsent');
      await Superwall.shared.setAdConsent(const AdConsent(
          adUserData: AdConsentStatus.denied,
          adPersonalization: AdConsentStatus.denied));
      final sent = calls.single[0] as PAdConsent;
      expect(sent.adUserData, PAdConsentStatus.denied);
      expect(sent.adPersonalization, PAdConsentStatus.denied);
    });

    test('iOS: getAdConsent returns the native value', () async {
      mockHost('getAdConsent',
          reply: PAdConsent(
              adUserData: PAdConsentStatus.denied,
              adPersonalization: PAdConsentStatus.granted));
      expect(
          await Superwall.shared.getAdConsent(),
          const AdConsent(
              adUserData: AdConsentStatus.denied,
              adPersonalization: AdConsentStatus.granted));
    });

    test('Android: setAdConsent does nothing', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final calls = mockHost('setAdConsent');
      await Superwall.shared.setAdConsent(const AdConsent());
      expect(calls, isEmpty);
    });

    test('Android: getAdConsent throws UnsupportedError', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final calls = mockHost('getAdConsent');
      expect(Superwall.shared.getAdConsent(), throwsA(isA<UnsupportedError>()));
      expect(calls, isEmpty);
    });

    test('SuperwallOptions.adConsent is passed to configure only when set',
        () async {
      final calls = mockHost('configure');
      Superwall.configure('pk_test', options: SuperwallOptions());
      await pumpEventQueue();
      expect((calls.single[2] as PSuperwallOptions).adConsent, isNull);

      Superwall.configure('pk_test',
          options: SuperwallOptions()
            ..adConsent =
                const AdConsent(adPersonalization: AdConsentStatus.denied));
      await pumpEventQueue();
      final consent = (calls.last[2] as PSuperwallOptions).adConsent!;
      expect(consent.adUserData, PAdConsentStatus.granted);
      expect(consent.adPersonalization, PAdConsentStatus.denied);
    });
  });

  test('maps teleport events', () {
    final open = SuperwallEventInfo.fromPEventInfo(
        PSuperwallEventInfo(eventType: PEventType.teleportOpen, params: {}));
    expect(open.event.type, EventType.teleportOpen);

    final returned = SuperwallEventInfo.fromPEventInfo(PSuperwallEventInfo(
        eventType: PEventType.teleportReturn, params: {'reason': 'purchased'}));
    expect(returned.event.type, EventType.teleportReturn);
    expect(returned.event.paywallInfo, isNull);
    expect(returned.params, {'reason': 'purchased'});
  });
}
