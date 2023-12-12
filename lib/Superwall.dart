// import 'package:flutter/services.dart';
// import 'package:superwallkit_flutter/LogLevel.dart';
// import 'package:superwallkit_flutter/PaywallInfo.dart';
// import 'package:superwallkit_flutter/PurchaseController.dart';
// import 'package:superwallkit_flutter/SuperwallOptions.dart';
// import 'SuperwallDelegate.dart';
//
// class Superwall {
//   static const MethodChannel _channel = MethodChannel('SuperwallPlugin');
//
//   // Singleton pattern to provide a single instance of Superwall.
//   static final Superwall _instance = Superwall._internal();
//
//   // Named constructor made private to prevent external instantiation.
//   Superwall._internal();
//
//   // Provides a globally accessible instance of Superwall.
//   static Superwall get shared => _instance;
//
//   /// The delegate that handles Superwall lifecycle events.
//   SuperwallDelegate? delegate;
//
//   /// Specifies the detail of the logs returned from the SDK to the console.
//   LogLevel get logLevel => _logLevel;
//   set logLevel(LogLevel level) {
//     _logLevel = level;
//     _channel.invokeMethod('setLogLevel', level.toString());
//   }
//   late LogLevel _logLevel;
//
//   /// Properties stored about the user, set using `setUserAttributes`.
//   Future<Map<String, dynamic>> get userAttributes async {
//     final result = await _channel.invokeMethod('getUserAttributes');
//     return Map<String, dynamic>.from(result);
//   }
//
//   /// The current user's id.
//   Future<String> get userId async {
//     return await _channel.invokeMethod('getUserId');
//   }
//
//   /// Indicates whether the user is logged in to Superwall.
//   Future<bool> get isLoggedIn async {
//     return await _channel.invokeMethod('isLoggedIn');
//   }
//
//   // TODO
//   /// The presented paywall view controller.
//   // Future<UIViewController?> get presentedViewController async {
//   //   // Implementation depends on native side.
//   // }
//
//   // TODO
//   /// The `PaywallInfo` object of the most recently presented view controller.
//   // Future<PaywallInfo?> get latestPaywallInfo async {
//   //   // Implementation depends on native side.
//   // }
//
//   // TODO use a ValueNotifier instead
//   // /// A published property that indicates the subscription status of the user.
//   // SubscriptionStatus get subscriptionStatus => _subscriptionStatus;
//   // set subscriptionStatus(SubscriptionStatus status) {
//   //   _subscriptionStatus = status;
//   //   _channel.invokeMethod('setSubscriptionStatus', status.toString());
//   // }
//   // late SubscriptionStatus _subscriptionStatus;
//
//   // TODO use a ValueNotifier instead
//   /// A published property that is `true` when Superwall has finished configuring.
//   // Future<bool> get isConfigured async {
//   //   return await _channel.invokeMethod('isConfigured');
//   // }
//
//   /// A variable that is only `true` if `shared` is available for use.
//   static Future<bool> get isInitialized async {
//     return await _channel.invokeMethod('isInitialized');
//   }
//
//   /// Configures a shared instance of `Superwall` for use throughout your app.
//   static Future<Superwall> configure({
//     required String apiKey,
//     PurchaseController? purchaseController,
//     SuperwallOptions? options,
//     Function()? completion,
//   }) async {
//     // TODO
//     await _channel.invokeMethod('configure', {
//       'apiKey': apiKey,
//       // Other parameters...
//     });
//     return Superwall._internal();
//   }
//
//   /// Preloads all paywalls.
//   Future<void> preloadAllPaywalls() async {
//     await _channel.invokeMethod('preloadAllPaywalls');
//   }
//
//   /// Preloads paywalls for specific event names.
//   Future<void> preloadPaywallsForEvents(Set<String> eventNames) async {
//     await _channel.invokeMethod('preloadPaywallsForEvents', eventNames.toList());
//   }
//
//   /// Handles a deep link sent to your app.
//   Future<bool> handleDeepLink(Uri url) async {
//     return await _channel.invokeMethod('handleDeepLink', url.toString());
//   }
//
//   /// Toggles the paywall loading spinner.
//   Future<void> togglePaywallSpinner({required bool isHidden}) async {
//     await _channel.invokeMethod('togglePaywallSpinner', isHidden);
//   }
//
//   /// Resets the `userId` and other data.
//   Future<void> reset() async {
//     await _channel.invokeMethod('reset');
//   }
// }

import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/LogLevel.dart';
import 'package:superwallkit_flutter/PaywallInfo.dart';
import 'package:superwallkit_flutter/PurchaseController.dart';
import 'package:superwallkit_flutter/SubscriptionStatus.dart';
import 'package:superwallkit_flutter/SuperwallDelegate.dart';
import 'package:superwallkit_flutter/SuperwallOptions.dart';

import 'package:flutter/services.dart';

/// The primary class for integrating Superwall into your application.
/// After configuring via `configure(apiKey: purchaseController: options: completion:)`,
/// it provides access to all its features via instance functions and variables.
class Superwall {
  static final MethodChannel _channel = const MethodChannel('SWK_SuperwallPlugin');

  // Asynchronous method to get the delegate
  Future<SuperwallDelegate?> getDelegate() async {
    final delegateResult = await _channel.invokeMethod('getDelegate');
    // TODO: Convert delegateResult to SuperwallDelegate
    return delegateResult as SuperwallDelegate?;
  }

  // Method to set the delegate
  void setDelegate(SuperwallDelegate? newDelegate) {
    _channel.invokeMethod('setDelegate', {'delegate': newDelegate});
  }

  // Asynchronous method to get logLevel
  Future<LogLevel> getLogLevel() async {
    final logLevelResult = await _channel.invokeMethod('getLogLevel');
    // TODO: Convert logLevelResult to LogLevel enum
    return LogLevel.values.firstWhere((element) => element.toString() == logLevelResult);
  }

  // Method to set logLevel
  void setLogLevel(LogLevel newLogLevel) {
    _channel.invokeMethod('setLogLevel', {'logLevel': newLogLevel.toString()});
  }

  // Asynchronous method to get userAttributes
  Future<Map<String, dynamic>> getUserAttributes() async {
    final attributes = await _channel.invokeMethod('getUserAttributes');
    return Map<String, dynamic>.from(attributes);
  }

  // Asynchronous method to get the current user's id
  Future<String> getUserId() async {
    return await _channel.invokeMethod('getUserId');
  }

  // Asynchronous method to check if the user is logged in to Superwall
  Future<bool> getIsLoggedIn() async {
    return await _channel.invokeMethod('getIsLoggedIn');
  }

  // Asynchronous method to get the presented paywall view controller
  // TODO:This is a placeholder implementation as Dart does not have a direct equivalent for UIViewController
  Future<dynamic> getPresentedViewController() async {
    return await _channel.invokeMethod('getPresentedViewController');
  }

  // Asynchronous method to get the latest PaywallInfo object
  Future<PaywallInfo?> getLatestPaywallInfo() async {
    final paywallInfo = await _channel.invokeMethod('getLatestPaywallInfo');
    // TODO: Convert paywallInfo to PaywallInfo
    return paywallInfo as PaywallInfo?;
  }

  // Asynchronous method to get the subscription status of the user
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final rawValue = await _channel.invokeMethod('getSubscriptionStatus');
    return SubscriptionStatus.fromRawValue(rawValue);
  }

  // Asynchronous method to set the subscription status of the user
  Future<void> setSubscriptionStatus(SubscriptionStatus status) async {
    await _channel.invokeMethod('setSubscriptionStatus', {'status': status.rawValue });
  }

  // Asynchronous method to check if Superwall has finished configuring
  Future<bool> getIsConfigured() async {
    return await _channel.invokeMethod('getIsConfigured');
  }

  // Asynchronous method to set the configured state of Superwall
  Future<void> setIsConfigured(bool configured) async {
    await _channel.invokeMethod('setIsConfigured', {'configured': configured});
  }

  // Asynchronous method to check if a paywall is currently being presented
  Future<bool> getIsPaywallPresented() async {
    return await _channel.invokeMethod('getIsPaywallPresented');
  }

  // Asynchronous method to preload all paywalls
  Future<void> preloadAllPaywalls() async {
    await _channel.invokeMethod('preloadAllPaywalls');
  }

  // Asynchronous method to preload paywalls for specific event names
  Future<void> preloadPaywallsForEvents(Set<String> eventNames) async {
    await _channel.invokeMethod('preloadPaywallsForEvents', {'eventNames': eventNames.toList()});
  }

  // Asynchronous method to handle deep links for paywall previews
  Future<bool> handleDeepLink(Uri url) async {
    return await _channel.invokeMethod('handleDeepLink', {'url': url.toString()});
  }

  // Asynchronous method to toggle the paywall loading spinner
  Future<void> togglePaywallSpinner(bool isHidden) async {
    await _channel.invokeMethod('togglePaywallSpinner', {'isHidden': isHidden});
  }

  // Asynchronous method to reset the user ID, on-device paywall assignments, and stored data
  Future<void> reset() async {
    await _channel.invokeMethod('reset');
  }

  // Asynchronous method to configure the Superwall instance
  static Future<Superwall> configure(APIKey apiKey, {PurchaseController? purchaseController, SuperwallOptions? options, Function? completion}) async {
    // TODO: Pass purchase controller and options as primitives
    await _channel.invokeMethod('configure', {
      'apiKey_iOS': apiKey.iosApiKey,
      'apiKey_android': apiKey.androidApiKey,
      'purchaseController': purchaseController,
      'options': options,
    });

    // TODO: is this the best way to handle completion handlers?
    if (completion != null) {
      completion();
    }
    return _instance;
  }

  // Private constructor for the singleton pattern
  Superwall._privateConstructor();

  // Static instance for the singleton
  static final Superwall _instance = Superwall._privateConstructor();

  // Getter for the shared instance
  static Superwall get shared => _instance;
}

class APIKey {
  String? iosApiKey;
  String? androidApiKey;

  // Constructor for iOS API key only
  APIKey.ios({required this.iosApiKey});

  // Constructor for Android API key only
  APIKey.android({required this.androidApiKey});

  // Constructor for both iOS and Android API keys
  APIKey.crossPlatform({required this.iosApiKey, required this.androidApiKey});

  // Check if at least one API key exists
  bool isValid() {
    return iosApiKey != null || androidApiKey != null;
  }
}


