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

  List<List<Object?>> mockConfigure() {
    final calls = <List<Object?>>[];
    messenger.setMockMessageHandler('$_prefix.configure', (message) async {
      calls.add(_codec.decodeMessage(message) as List<Object?>? ?? []);
      return _codec.encodeMessage(<Object?>[null]);
    });
    return calls;
  }

  setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('PaywallOptions.presentationHost', () {
    test('defaults to activity', () {
      expect(PaywallOptions().presentationHost, PresentationHost.activity);
    });

    test('is passed to configure as activity by default', () async {
      final calls = mockConfigure();
      Superwall.configure('pk_test', options: SuperwallOptions());
      await pumpEventQueue();
      final options = calls.single[2] as PSuperwallOptions;
      expect(options.paywalls!.presentationHost, PPresentationHost.activity);
    });

    test('passes inWindow to configure', () async {
      final calls = mockConfigure();
      Superwall.configure('pk_test',
          options: SuperwallOptions()
            ..paywalls.presentationHost = PresentationHost.inWindow);
      await pumpEventQueue();
      final options = calls.single[2] as PSuperwallOptions;
      expect(options.paywalls!.presentationHost, PPresentationHost.inWindow);
    });

    test('is included in toJson', () {
      final options = PaywallOptions()
        ..presentationHost = PresentationHost.inWindow;
      expect(options.toJson()['presentationHost'], 'in_window');
      expect(PaywallOptions().toJson()['presentationHost'], 'activity');
    });
  });
}
