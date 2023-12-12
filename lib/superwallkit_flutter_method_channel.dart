import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'superwallkit_flutter_platform_interface.dart';

// /// An implementation of [SuperwallkitFlutterPlatform] that uses method channels.
// class MethodChannelSuperwallkitFlutter extends SuperwallkitFlutterPlatform {
//   /// The method channel used to interact with the native platform.
//   @visibleForTesting
//   final methodChannel = const MethodChannel('superwallkit_flutter');
//
//   @override
//   Future<String?> getPlatformVersion() async {
//     final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
//     return version;
//   }
// }
