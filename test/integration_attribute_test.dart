import 'package:flutter_test/flutter_test.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/superwallkit_flutter.dart';

const _prefix = 'dev.flutter.pigeon.superwallkit_flutter.PSuperwallHostApi';
const _codec = PSuperwallHostApi.pigeonChannelCodec;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  List<List<Object?>> mockHost(String method) {
    final calls = <List<Object?>>[];
    messenger.setMockMessageHandler('$_prefix.$method', (message) async {
      calls.add(_codec.decodeMessage(message) as List<Object?>? ?? []);
      return _codec.encodeMessage(<Object?>[null]);
    });
    return calls;
  }

  group('IntegrationAttribute', () {
    test('every case maps to the Pigeon case with the same name', () {
      for (final attribute in IntegrationAttribute.values) {
        expect(attribute.toPigeon().name, attribute.name);
      }
    });

    test('airbridgeId maps to PIntegrationAttribute.airbridgeId', () {
      expect(IntegrationAttribute.airbridgeId.toPigeon(),
          PIntegrationAttribute.airbridgeId);
    });

    test('setIntegrationAttribute sends airbridgeId to native', () async {
      final calls = mockHost('setIntegrationAttribute');
      await Superwall.shared
          .setIntegrationAttribute(IntegrationAttribute.airbridgeId, 'abc');
      expect(calls.single, [PIntegrationAttribute.airbridgeId, 'abc']);
    });

    test('setIntegrationAttributes sends airbridgeId alongside others',
        () async {
      final calls = mockHost('setIntegrationAttributes');
      await Superwall.shared.setIntegrationAttributes({
        IntegrationAttribute.airbridgeId: 'abc',
        IntegrationAttribute.adjustId: null,
      });
      expect(calls.single[0], {
        PIntegrationAttribute.airbridgeId: 'abc',
        PIntegrationAttribute.adjustId: null,
      });
    });
  });
}
