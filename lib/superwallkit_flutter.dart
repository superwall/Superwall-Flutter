import 'package:flutter/services.dart';

// /// The primary class for integrating Superwall into your Flutter application.
// /// After configuring via `configure`, it provides access to all its features via instance functions and variables.
// class Superwall {
//   /// The MethodChannel that will the communication between Dart and native platforms.
//   static const MethodChannel _channel = MethodChannel('SuperwallkitFlutterPlugin');
//
//   // Singleton pattern to provide a single instance of Superwall.
//   static final Superwall _instance = Superwall._internal();
//
//   factory Superwall() => _instance;
//
//   Superwall._internal();
//
//   // /// The delegate that handles Superwall lifecycle events.
//   // public var delegate: SuperwallDelegate? { ... }
//   //
//   // /// Properties stored about the user, set using ``setUserAttributes(_:)-1wql2``.
//   // public var userAttributes: [String: Any] { ... }
//   //
//   // /// The presented paywall view controller.
//   // public var presentedViewController: UIViewController? { ... }
//   //
//   // /// The configured shared instance of ``Superwall``.
//   // @objc(sharedInstance)
//   // public static var shared: Superwall { ... }
//   //
//   // /// A variable that is only `true` if ``shared`` is available for use.
//   // @DispatchQueueBacked
//   // public private(set) static var isInitialized = false
//
//
//
//
//   // The current user's ID.
//   Future<String> get userId async {
//     return await _channel.invokeMethod('getUserId');
//   }
//
//   // Indicates whether the user is logged in to Superwall.
//   Future<bool> get isLoggedIn async {
//     return await _channel.invokeMethod('isLoggedIn');
//   }
//
//   // Properties stored about the user.
//   Future<Map<String, dynamic>> get userAttributes async {
//     final attributes = await _channel.invokeMethod('getUserAttributes');
//     return Map<String, dynamic>.from(attributes);
//   }
//
//   // The subscription status of the user.
//   Future<String> get subscriptionStatus async {
//     return await _channel.invokeMethod('getSubscriptionStatus');
//   }
//
//   // Indicates whether Superwall is configured.
//   Future<bool> get isConfigured async {
//     return await _channel.invokeMethod('isConfigured');
//   }
//
//   // Indicates whether a paywall is being presented.
//   Future<bool> get isPaywallPresented async {
//     return await _channel.invokeMethod('isPaywallPresented');
//   }
//
//   // Retrieves the latest PaywallInfo.
//   Future<Map<String, dynamic>> get latestPaywallInfo async {
//     final info = await _channel.invokeMethod('getLatestPaywallInfo');
//     return Map<String, dynamic>.from(info);
//   }
//
//   // Setter for log level
//   Future<void> setLogLevel(String logLevel) async {
//     await _channel.invokeMethod('setLogLevel', {'logLevel': logLevel});
//   }
//
//   // MARK: - Functions
//
//   // Configures a shared instance of `Superwall` for use throughout your app.
//   static Future<void> configure({
//     required String apiKey,
//     String? purchaseController, // Note: Handling this might depend on your specific implementation
//     Map<String, dynamic>? options,
//     Function? completion,
//   }) async {
//     await _channel.invokeMethod('configure', {
//       'apiKey': apiKey,
//       'purchaseController': purchaseController, // May need to be handled specially in native code
//       'options': options,
//     });
//     completion?.call();
//   }
//
//   // Preloads all paywalls.
//   Future<void> preloadAllPaywalls() async {
//     await _channel.invokeMethod('preloadAllPaywalls');
//   }
//
//   // Preloads paywalls for specific event names.
//   Future<void> preloadPaywallsForEvents(Set<String> eventNames) async {
//     await _channel.invokeMethod('preloadPaywallsForEvents', {
//       'eventNames': eventNames.toList(),
//     });
//   }
//
//   // Handles a deep link sent to your app.
//   Future<bool> handleDeepLink(String url) async {
//     final bool result = await _channel.invokeMethod('handleDeepLink', {
//       'url': url,
//     });
//     return result;
//   }
//
//   // Toggles the paywall loading spinner on and off.
//   Future<void> togglePaywallSpinner(bool isHidden) async {
//     await _channel.invokeMethod('togglePaywallSpinner', {
//       'isHidden': isHidden,
//     });
//   }
//
//   // Resets the `userId`, paywall assignments, and data stored by Superwall.
//   Future<void> reset() async {
//     await _channel.invokeMethod('reset');
//   }
//
//   /// MARK: - PublicPresentation
//
// // Dismisses the presented paywall.
//   static Future<void> dismiss({Function? completion}) async {
//     await _channel.invokeMethod('dismiss');
//     completion?.call();
//   }
//
//   // Registers an event to access a feature.
//   static Future<void> register({
//     required String event,
//     Map<String, dynamic>? params,
//     Function? handler, // Note: Adapt this based on how you want to handle events in Dart
//     Function? feature,
//   }) async {
//     await _channel.invokeMethod('register', {
//       'event': event,
//       'params': params,
//       // Handler and feature are not directly implementable as in Swift. You might want to handle these differently.
//     });
//     feature?.call();
//   }
//
//   // Registers an event which can show a paywall.
//   // Note: This is similar to the above method but without the 'handler' parameter.
//   static Future<void> registerSimple({
//     required String event,
//     Map<String, dynamic>? params,
//   }) async {
//     await _channel.invokeMethod('registerSimple', {
//       'event': event,
//       'params': params,
//     });
//   }
//
// // // Returns a publisher for an event registration.
// // // Note: The concept of publishers does not exist in Dart in the same way as in Swift.
// // // This method might be adapted or omitted based on your specific implementation needs.
// // static Future<PaywallState> publisherForEvent({
// //   required String event,
// //   Map<String, dynamic>? params,
// //   Map<String, dynamic>? paywallOverrides, // Assuming PaywallOverrides can be represented as a Map
// //   bool isFeatureGatable,
// // }) async {
// //   final result = await _channel.invokeMethod('publisherForEvent', {
// //     'event': event,
// //     'params': params,
// //     'paywallOverrides': paywallOverrides,
// //     'isFeatureGatable': isFeatureGatable,
// //   });
// //   return PaywallState.fromMap(Map<String, dynamic>.from(result));
// // }
//
// }