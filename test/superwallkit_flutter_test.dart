// import 'package:flutter_test/flutter_test.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockSuperwallkitFlutterPlatform
//     with MockPlatformInterfaceMixin
//     implements SuperwallkitFlutterPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final SuperwallkitFlutterPlatform initialPlatform = SuperwallkitFlutterPlatform.instance;
//
//   test('$MethodChannelSuperwallkitFlutter is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSuperwallkitFlutter>());
//   });
//
//   test('getPlatformVersion', () async {
//     SuperwallkitFlutter superwallkitFlutterPlugin = SuperwallkitFlutter();
//     MockSuperwallkitFlutterPlatform fakePlatform = MockSuperwallkitFlutterPlatform();
//     SuperwallkitFlutterPlatform.instance = fakePlatform;
//
//     expect(await superwallkitFlutterPlugin.getPlatformVersion(), '42');
//   });
// }
