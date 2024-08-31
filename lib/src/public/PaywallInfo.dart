import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/public/ComputedPropertyRequest.dart';
import 'package:superwallkit_flutter/src/public/Experiment.dart';
import 'package:superwallkit_flutter/src/public/FeatureGatingBehavior.dart';
import 'package:superwallkit_flutter/src/public/LocalNotification.dart';
import 'package:superwallkit_flutter/src/public/PaywallCloseReason.dart';
import 'package:superwallkit_flutter/src/public/Product.dart';
import 'package:superwallkit_flutter/src/public/Survey.dart';

/// Contains information about a paywall.
class PaywallInfo extends BridgeIdInstantiable {
  static const BridgeClass bridgeClass = 'PaywallInfoBridge';
  PaywallInfo({super.bridgeId}): super(bridgeClass: bridgeClass);

  /// The identifier set for this paywall in the Superwall dashboard.
  Future<String> get identifier async {
    return await bridgeId.communicator.invokeBridgeMethod('getIdentifier');
  }

  /// The trigger experiment that caused the paywall to present.
  Future<Experiment?> get experiment async {
    final experimentBridgeId = await bridgeId.communicator.invokeBridgeMethod('getExperimentBridgeId');
    return Experiment(bridgeId: experimentBridgeId);
  }

  /// The trigger session ID associated with the paywall.
  Future<String?> get triggerSessionId async {
    return await bridgeId.communicator.invokeBridgeMethod('getTriggerSessionId');
  }

  /// The products associated with the paywall.
  Future<List<Product>> get products async {
    List<dynamic> products = await bridgeId.communicator.invokeBridgeMethod('getProducts');
    return products.map((json) => Product.fromJson(json)).toList();
  }

  /// An array of product IDs that this paywall is displaying in `[Primary, Secondary, Tertiary]` order.
  Future<List<String>> get productIds async {
    List<dynamic> productIds = await bridgeId.communicator.invokeBridgeMethod('getProductIds');
    return productIds.map((value) => value.toString()).toList();
  }

  /// The name set for this paywall in Superwall's web dashboard.
  Future<String> get name async {
    return await bridgeId.communicator.invokeBridgeMethod('getName');
  }

  /// The URL where this paywall is hosted.
  Future<String> get url async {
    return await bridgeId.communicator.invokeBridgeMethod('getUrl');
  }

  /// The name of the event that triggered this Paywall. Defaults to `nil` if `triggeredByEvent` is false.
  Future<String?> get presentedByEventWithName async {
    return await bridgeId.communicator.invokeBridgeMethod('getPresentedByEventWithName');
  }

  /// The Superwall internal id (for debugging) of the event that triggered this Paywall. Defaults to `nil` if `triggeredByEvent` is false.
  Future<String?> get presentedByEventWithId async {
    return await bridgeId.communicator.invokeBridgeMethod('getPresentedByEventWithId');
  }

  /// The ISO date string describing when the event triggered this paywall. Defaults to `nil` if `triggeredByEvent` is false.
  Future<String?> get presentedByEventAt async {
    return await bridgeId.communicator.invokeBridgeMethod('getPresentedByEventAt');
  }

  /// How the paywall was presented, either 'programmatically', 'identifier', or 'event'
  Future<String> get presentedBy async {
    return await bridgeId.communicator.invokeBridgeMethod('getPresentedBy');
  }

  /// The source function that retrieved the paywall. Either `implicit`, `getPaywall`, or `register`. `nil` only when preloading.
  Future<String?> get presentationSourceType async {
    return await bridgeId.communicator.invokeBridgeMethod('getPresentationSourceType');
  }

  /// An ISO date string indicating when the paywall response began loading.
  Future<String?> get responseLoadStartTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getResponseLoadStartTime');
  }

  /// An ISO date string indicating when the paywall response finished loading.
  Future<String?> get responseLoadCompleteTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getResponseLoadCompleteTime');
  }

  /// An ISO date string indicating when the paywall response failed to load.
  Future<String?> get responseLoadFailTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getResponseLoadFailTime');
  }

  /// The time it took to load the paywall response.
  Future<double?> get responseLoadDuration async {
    return await bridgeId.communicator.invokeBridgeMethod('getResponseLoadDuration');
  }

  /// An ISO date string indicating when the paywall webview began loading.
  Future<String?> get webViewLoadStartTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getWebViewLoadStartTime');
  }

  /// An ISO date string indicating when the paywall webview finished loading.
  Future<String?> get webViewLoadCompleteTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getWebViewLoadCompleteTime');
  }

  /// An ISO date string indicating when the paywall webview failed to load.
  Future<String?> get webViewLoadFailTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getWebViewLoadFailTime');
  }

  /// The time it took to load the paywall website.
  Future<double?> get webViewLoadDuration async {
    return await bridgeId.communicator.invokeBridgeMethod('getWebViewLoadDuration');
  }

  /// An ISO date string indicating when the paywall products began loading.
  Future<String?> get productsLoadStartTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getProductsLoadStartTime');
  }

  /// An ISO date string indicating when the paywall products finished loading.
  Future<String?> get productsLoadCompleteTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getProductsLoadCompleteTime');
  }

  /// An ISO date string indicating when the paywall products failed to load.
  Future<String?> get productsLoadFailTime async {
    return await bridgeId.communicator.invokeBridgeMethod('getProductsLoadFailTime');
  }

  /// The time it took to load the paywall products.
  Future<double?> get productsLoadDuration async {
    return await bridgeId.communicator.invokeBridgeMethod('getProductsLoadDuration');
  }

  /// The paywall.js version installed on the paywall website.
  Future<String?> get paywalljsVersion async {
    return await bridgeId.communicator.invokeBridgeMethod('getPaywalljsVersion');
  }

  /// Indicates whether the paywall is showing free trial content.
  Future<bool> get isFreeTrialAvailable async {
    return await bridgeId.communicator.invokeBridgeMethod('getIsFreeTrialAvailable');
  }

  /// A `FeatureGatingBehavior` case that indicates whether the `Superwall/register(event:params:handler:feature:)` `feature` block executes or not.
  Future<FeatureGatingBehavior> get featureGatingBehavior async {
    final featureGatingBehavior = await bridgeId.communicator.invokeBridgeMethod('getFeatureGatingBehavior');
    return FeatureGatingBehaviorExtension.fromJson(featureGatingBehavior);
  }

  /// An enum describing why this paywall was last closed. `none` if not yet closed.
  Future<PaywallCloseReason> get closeReason async {
    final closeReason = await bridgeId.communicator.invokeBridgeMethod('getCloseReason');
    return PaywallCloseReasonExtension.fromJson(closeReason);
  }

  /// The local notifications associated with the paywall.
  Future<List<LocalNotification>> get localNotifications async {
    List<dynamic> localNotifications = await bridgeId.communicator.invokeBridgeMethod('getLocalNotifications');
    return localNotifications.map((json) => LocalNotification.fromJson(json)).toList();
  }

  /// An array of requests to compute a device property associated with an event at runtime.
  Future<List<ComputedPropertyRequest>> get computedPropertyRequests async {
    List<dynamic> computedPropertyRequests = await bridgeId.communicator.invokeBridgeMethod('getComputedPropertyRequests');
    return computedPropertyRequests.map((json) => ComputedPropertyRequest.fromJson(json)).toList();
  }

  /// Surveys attached to a paywall.
  Future<List<Survey>> get surveys async {
    List<dynamic> surveys = await bridgeId.communicator.invokeBridgeMethod('getSurveys');
    return surveys.map((json) => Survey.fromJson(json)).toList();
  }
}
