import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/public/ComputedPropertyRequest.dart';
import 'package:superwallkit_flutter/src/public/Experiment.dart';
import 'package:superwallkit_flutter/src/public/FeatureGatingBehavior.dart';
import 'package:superwallkit_flutter/src/public/LocalNotification.dart';
import 'package:superwallkit_flutter/src/public/PaywallCloseReason.dart';
import 'package:superwallkit_flutter/src/public/Product.dart';
import 'package:superwallkit_flutter/src/public/Survey.dart';

/// Contains information about a paywall.
class PaywallInfo {
  /// Static factory method to create a PaywallInfo from a PPaywallInfo
  static PaywallInfo? fromPigeon(PPaywallInfo? pigeonInfo) {
    if (pigeonInfo == null) return null;

    return PaywallInfo(
      identifier: pigeonInfo.identifier,
      name: pigeonInfo.name,
      experiment: Experiment.fromPigeon(pigeonInfo.experiment),
      productIds: pigeonInfo.productIds,
      products:
          pigeonInfo.products?.map((p) => Product.fromPigeon(p)!).toList(),
      url: pigeonInfo.url,
      presentedByPlacementWithName: pigeonInfo.presentedByPlacementWithName,
      presentedByPlacementWithId: pigeonInfo.presentedByPlacementWithId,
      presentedByPlacementAt: pigeonInfo.presentedByPlacementAt,
      presentedBy: pigeonInfo.presentedBy,
      presentationSourceType: pigeonInfo.presentationSourceType,
      responseLoadStartTime: pigeonInfo.responseLoadStartTime,
      responseLoadCompleteTime: pigeonInfo.responseLoadCompleteTime,
      responseLoadFailTime: pigeonInfo.responseLoadFailTime,
      responseLoadDuration: pigeonInfo.responseLoadDuration,
      webViewLoadStartTime: pigeonInfo.webViewLoadStartTime,
      webViewLoadCompleteTime: pigeonInfo.webViewLoadCompleteTime,
      webViewLoadFailTime: pigeonInfo.webViewLoadFailTime,
      webViewLoadDuration: pigeonInfo.webViewLoadDuration,
      productsLoadStartTime: pigeonInfo.productsLoadStartTime,
      productsLoadCompleteTime: pigeonInfo.productsLoadCompleteTime,
      productsLoadFailTime: pigeonInfo.productsLoadFailTime,
      productsLoadDuration: pigeonInfo.productsLoadDuration,
      paywalljsVersion: pigeonInfo.paywalljsVersion,
      isFreeTrialAvailable: pigeonInfo.isFreeTrialAvailable,
      featureGatingBehavior: pigeonInfo.featureGatingBehavior != null
          ? FeatureGatingBehaviorExtension.fromPigeon(
              pigeonInfo.featureGatingBehavior!)
          : null,
      closeReason: pigeonInfo.closeReason != null
          ? PaywallCloseReasonExtension.fromPigeon(pigeonInfo.closeReason!)
          : null,
      localNotifications: pigeonInfo.localNotifications
          ?.map((ln) => LocalNotification.fromPigeon(ln))
          .toList(),
      computedPropertyRequests: pigeonInfo.computedPropertyRequests
          ?.map((cpr) => ComputedPropertyRequest.fromPigeon(cpr))
          .toList(),
      surveys: pigeonInfo.surveys?.map((s) => Survey.fromPigeon(s)).toList(),
    );
  }

  /// Convert this PaywallInfo to a PPaywallInfo
  PPaywallInfo toPigeon() {
    return PPaywallInfo(
      identifier: identifier,
      name: name,
      experiment: experiment?.toPigeon(),
      productIds: productIds,
      products: products?.map((p) => p.toPigeon()).toList(),
      url: url,
      presentedByPlacementWithName: presentedByPlacementWithName,
      presentedByPlacementWithId: presentedByPlacementWithId,
      presentedByPlacementAt: presentedByPlacementAt,
      presentedBy: presentedBy,
      presentationSourceType: presentationSourceType,
      responseLoadStartTime: responseLoadStartTime,
      responseLoadCompleteTime: responseLoadCompleteTime,
      responseLoadFailTime: responseLoadFailTime,
      responseLoadDuration: responseLoadDuration,
      webViewLoadStartTime: webViewLoadStartTime,
      webViewLoadCompleteTime: webViewLoadCompleteTime,
      webViewLoadFailTime: webViewLoadFailTime,
      webViewLoadDuration: webViewLoadDuration,
      productsLoadStartTime: productsLoadStartTime,
      productsLoadCompleteTime: productsLoadCompleteTime,
      productsLoadFailTime: productsLoadFailTime,
      productsLoadDuration: productsLoadDuration,
      paywalljsVersion: paywalljsVersion,
      isFreeTrialAvailable: isFreeTrialAvailable,
      featureGatingBehavior: featureGatingBehavior?.toPigeon(),
      closeReason: closeReason?.toPigeon(),
      localNotifications:
          localNotifications?.map((ln) => ln.toPigeon()).toList(),
      computedPropertyRequests:
          computedPropertyRequests?.map((cpr) => cpr.toPigeon()).toList(),
      surveys: surveys?.map((s) => s.toPigeon()).toList(),
    );
  }

  /// The identifier set for this paywall in the Superwall dashboard.
  final String? identifier;

  /// The name set for this paywall in Superwall's web dashboard.
  final String? name;

  /// The trigger experiment that caused the paywall to present.
  final Experiment? experiment;

  /// An array of product IDs that this paywall is displaying in `[Primary, Secondary, Tertiary]` order.
  final List<String>? productIds;

  /// The products associated with the paywall.
  final List<Product>? products;

  /// The URL where this paywall is hosted.
  final String? url;

  /// The name of the placement that triggered this Paywall. Defaults to `nil` if `triggeredByPlacement` is false.
  final String? presentedByPlacementWithName;

  /// The Superwall internal id (for debugging) of the placement that triggered this Paywall. Defaults to `nil` if `triggeredByPlacement` is false.
  final String? presentedByPlacementWithId;

  /// The ISO date string describing when the placement triggered this paywall. Defaults to `nil` if `triggeredByPlacement` is false.
  final String? presentedByPlacementAt;

  /// How the paywall was presented, either 'programmatically', 'identifier', or 'placement'
  final String? presentedBy;

  /// The source function that retrieved the paywall. Either `implicit`, `getPaywall`, or `register`. `nil` only when preloading.
  final String? presentationSourceType;

  /// An ISO date string indicating when the paywall response began loading.
  final String? responseLoadStartTime;

  /// An ISO date string indicating when the paywall response finished loading.
  final String? responseLoadCompleteTime;

  /// An ISO date string indicating when the paywall response failed to load.
  final String? responseLoadFailTime;

  /// The time it took to load the paywall response.
  final double? responseLoadDuration;

  /// An ISO date string indicating when the paywall webview began loading.
  final String? webViewLoadStartTime;

  /// An ISO date string indicating when the paywall webview finished loading.
  final String? webViewLoadCompleteTime;

  /// An ISO date string indicating when the paywall webview failed to load.
  final String? webViewLoadFailTime;

  /// The time it took to load the paywall website.
  final double? webViewLoadDuration;

  /// An ISO date string indicating when the paywall products began loading.
  final String? productsLoadStartTime;

  /// An ISO date string indicating when the paywall products finished loading.
  final String? productsLoadCompleteTime;

  /// An ISO date string indicating when the paywall products failed to load.
  final String? productsLoadFailTime;

  /// The time it took to load the paywall products.
  final double? productsLoadDuration;

  /// The paywall.js version installed on the paywall website.
  final String? paywalljsVersion;

  /// Indicates whether the paywall is showing free trial content.
  final bool? isFreeTrialAvailable;

  /// A `FeatureGatingBehavior` case that indicates whether the `Superwall/register(placement:params:handler:feature:)` `feature` block executes or not.
  final FeatureGatingBehavior? featureGatingBehavior;

  /// An enum describing why this paywall was last closed. `none` if not yet closed.
  final PaywallCloseReason? closeReason;

  /// The local notifications associated with the paywall.
  final List<LocalNotification>? localNotifications;

  /// An array of requests to compute a device property associated with an placement at runtime.
  final List<ComputedPropertyRequest>? computedPropertyRequests;

  /// Surveys attached to a paywall.
  final List<Survey>? surveys;

  PaywallInfo({
    this.identifier,
    this.name,
    this.experiment,
    this.productIds,
    this.products,
    this.url,
    this.presentedByPlacementWithName,
    this.presentedByPlacementWithId,
    this.presentedByPlacementAt,
    this.presentedBy,
    this.presentationSourceType,
    this.responseLoadStartTime,
    this.responseLoadCompleteTime,
    this.responseLoadFailTime,
    this.responseLoadDuration,
    this.webViewLoadStartTime,
    this.webViewLoadCompleteTime,
    this.webViewLoadFailTime,
    this.webViewLoadDuration,
    this.productsLoadStartTime,
    this.productsLoadCompleteTime,
    this.productsLoadFailTime,
    this.productsLoadDuration,
    this.paywalljsVersion,
    this.isFreeTrialAvailable,
    this.featureGatingBehavior,
    this.closeReason,
    this.localNotifications,
    this.computedPropertyRequests,
    this.surveys,
  });
}
