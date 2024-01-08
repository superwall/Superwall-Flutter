import 'package:superwallkit_flutter/src/private/BridgingCreator.dart';
import 'package:superwallkit_flutter/src/private/Utilities.dart';
import 'package:superwallkit_flutter/src/public/ComputedPropertyRequest.dart';
import 'package:superwallkit_flutter/src/public/Experiment.dart';
import 'package:superwallkit_flutter/src/public/FeatureGatingBehavior.dart';
import 'package:superwallkit_flutter/src/public/LocalNotification.dart';
import 'package:superwallkit_flutter/src/public/PaywallCloseReason.dart';
import 'package:superwallkit_flutter/src/public/Product.dart';
import 'package:superwallkit_flutter/src/public/Survey.dart';

/// Contains information about a paywall.
class PaywallInfo {
  final BridgeId bridgeId;

  PaywallInfo({required this.bridgeId});

  /// The identifier set for this paywall in the Superwall dashboard.
  Future<String> get identifier async {
    return await bridgeId.communicator.invokeBridgeMethod('getIdentifier');
  }

  /// The trigger experiment that caused the paywall to present.
  Future<Experiment?> get experiment async {
    final experimentBridgeId = await bridgeId.communicator.invokeBridgeMethod('getExperimentBridgeId');
    return Experiment(bridgeId: bridgeId);
  }

  /// The trigger session ID associated with the paywall.
  Future<String?> get triggerSessionId async {
    return await bridgeId.communicator.invokeBridgeMethod('getTriggerSessionId');
  }

  /// The products associated with the paywall.
  Future<List<Product>> get products async {
    final productBridgeIds = await bridgeId.communicator.invokeBridgeMethod('getProductBridgeIds');
    return productBridgeIds.map((bridgeId) => Product(bridgeId: bridgeId));
  }

  /// An array of product IDs that this paywall is displaying in `[Primary, Secondary, Tertiary]` order.
  Future<List<String>> get productIds async {
    return await bridgeId.communicator.invokeBridgeMethod('getProductIds');
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

  // TODO
  // /// The ISO date string describing when the event triggered this paywall. Defaults to `nil` if `triggeredByEvent` is false.
  // final String? presentedByEventAt;
  //
  // /// How the paywall was presented, either 'programmatically', 'identifier', or 'event'
  // final String presentedBy;
  //
  // /// The source function that retrieved the paywall. Either `implicit`, `getPaywall`, or `register`. `nil` only when preloading.
  // final String? presentationSourceType;
  //
  // /// An iso date string indicating when the paywall response began loading.
  // final String? responseLoadStartTime;
  //
  // /// An iso date string indicating when the paywall response finished loading.
  // final String? responseLoadCompleteTime;
  //
  // /// An iso date string indicating when the paywall response failed to load.
  // final String? responseLoadFailTime;
  //
  // /// The time it took to load the paywall response.
  // final double? responseLoadDuration;
  //
  // /// An iso date string indicating when the paywall webview began loading.
  // final String? webViewLoadStartTime;
  //
  // /// An iso date string indicating when the paywall webview finished loading.
  // final String? webViewLoadCompleteTime;
  //
  // /// An iso date string indicating when the paywall webview failed to load.
  // final String? webViewLoadFailTime;
  //
  // /// The time it took to load the paywall website.
  // final double? webViewLoadDuration;
  //
  // /// An iso date string indicating when the paywall products began loading.
  // final String? productsLoadStartTime;
  //
  // /// An iso date string indicating when the paywall products finished loading.
  // final String? productsLoadCompleteTime;
  //
  // /// An iso date string indicating when the paywall products failed to load.
  // final String? productsLoadFailTime;
  //
  // /// The time it took to load the paywall products.
  // final double? productsLoadDuration;
  //
  // /// The paywall.js version installed on the paywall website.
  // final String? paywalljsVersion;
  //
  // /// Indicates whether the paywall is showing free trial content.
  // final bool isFreeTrialAvailable;
  //
  // /// A `FeatureGatingBehavior` case that indicates whether the `Superwall/register(event:params:handler:feature:)` `feature` block executes or not.
  // final FeatureGatingBehavior featureGatingBehavior;
  //
  // /// An enum describing why this paywall was last closed. `none` if not yet closed.
  // final PaywallCloseReason closeReason;
  //
  // /// The local notifications associated with the paywall.
  // final List<LocalNotification> localNotifications;
  //
  // /// An array of requests to compute a device property associated with an event at runtime.
  // final List<ComputedPropertyRequest> computedPropertyRequests;
  //
  // /// Surveys attached to a paywall.
  // final List<Survey> surveys;

}
