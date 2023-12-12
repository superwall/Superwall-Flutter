import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'superwallkit_flutter_method_channel.dart';

// abstract class SuperwallkitFlutterPlatform extends PlatformInterface {
//   /// Constructs a SuperwallkitFlutterPlatform.
//   SuperwallkitFlutterPlatform() : super(token: _token);
//
//   static final Object _token = Object();
//
//   static SuperwallkitFlutterPlatform _instance = MethodChannelSuperwallkitFlutter();
//
//   /// The default instance of [SuperwallkitFlutterPlatform] to use.
//   ///
//   /// Defaults to [MethodChannelSuperwallkitFlutter].
//   static SuperwallkitFlutterPlatform get instance => _instance;
//
//   /// Platform-specific implementations should set this with their own
//   /// platform-specific class that extends [SuperwallkitFlutterPlatform] when
//   /// they register themselves.
//   static set instance(SuperwallkitFlutterPlatform instance) {
//     PlatformInterface.verifyToken(instance, _token);
//     _instance = instance;
//   }
//
//   Future<String?> getPlatformVersion() {
//     throw UnimplementedError('platformVersion() has not been implemented.');
//   }
// }
