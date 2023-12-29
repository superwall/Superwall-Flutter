import 'package:superwallkit_flutter/src/public/ComputedPropertyRequest.dart';
import 'package:superwallkit_flutter/src/public/Experiment.dart';
import 'package:superwallkit_flutter/src/public/FeatureGatingBehavior.dart';
import 'package:superwallkit_flutter/src/public/LocalNotification.dart';
import 'package:superwallkit_flutter/src/public/PaywallCloseReason.dart';
import 'package:superwallkit_flutter/src/public/Product.dart';
import 'package:superwallkit_flutter/src/public/Survey.dart';

/// Contains information about a paywall.
class PaywallInfo {
  /// The identifier set for this paywall in the Superwall dashboard.
  final String identifier;

  /// The trigger experiment that caused the paywall to present.
  final Experiment? experiment;

  /// The trigger session ID associated with the paywall.
  final String? triggerSessionId;

  /// The products associated with the paywall.
  final List<Product> products;

  /// An array of product IDs that this paywall is displaying in `[Primary, Secondary, Tertiary]` order.
  final List<String> productIds;

  /// The name set for this paywall in Superwall's web dashboard.
  final String name;

  /// The URL where this paywall is hosted.
  final String url; // URL represented as a string

  /// The name of the event that triggered this Paywall. Defaults to `nil` if `triggeredByEvent` is false.
  final String? presentedByEventWithName;

  /// The Superwall internal id (for debugging) of the event that triggered this Paywall. Defaults to `nil` if `triggeredByEvent` is false.
  final String? presentedByEventWithId;

  /// The ISO date string describing when the event triggered this paywall. Defaults to `nil` if `triggeredByEvent` is false.
  final String? presentedByEventAt;

  /// How the paywall was presented, either 'programmatically', 'identifier', or 'event'
  final String presentedBy;

  /// The source function that retrieved the paywall. Either `implicit`, `getPaywall`, or `register`. `nil` only when preloading.
  final String? presentationSourceType;

  /// An iso date string indicating when the paywall response began loading.
  final String? responseLoadStartTime;

  /// An iso date string indicating when the paywall response finished loading.
  final String? responseLoadCompleteTime;

  /// An iso date string indicating when the paywall response failed to load.
  final String? responseLoadFailTime;

  /// The time it took to load the paywall response.
  final double? responseLoadDuration;

  /// An iso date string indicating when the paywall webview began loading.
  final String? webViewLoadStartTime;

  /// An iso date string indicating when the paywall webview finished loading.
  final String? webViewLoadCompleteTime;

  /// An iso date string indicating when the paywall webview failed to load.
  final String? webViewLoadFailTime;

  /// The time it took to load the paywall website.
  final double? webViewLoadDuration;

  /// An iso date string indicating when the paywall products began loading.
  final String? productsLoadStartTime;

  /// An iso date string indicating when the paywall products finished loading.
  final String? productsLoadCompleteTime;

  /// An iso date string indicating when the paywall products failed to load.
  final String? productsLoadFailTime;

  /// The time it took to load the paywall products.
  final double? productsLoadDuration;

  /// The paywall.js version installed on the paywall website.
  final String? paywalljsVersion;

  /// Indicates whether the paywall is showing free trial content.
  final bool isFreeTrialAvailable;

  /// A `FeatureGatingBehavior` case that indicates whether the `Superwall/register(event:params:handler:feature:)` `feature` block executes or not.
  final FeatureGatingBehavior featureGatingBehavior;

  /// An enum describing why this paywall was last closed. `none` if not yet closed.
  final PaywallCloseReason closeReason;

  /// The local notifications associated with the paywall.
  final List<LocalNotification> localNotifications;

  /// An array of requests to compute a device property associated with an event at runtime.
  final List<ComputedPropertyRequest> computedPropertyRequests;

  /// Surveys attached to a paywall.
  final List<Survey> surveys;

  PaywallInfo({
    required this.identifier,
    this.experiment,
    this.triggerSessionId,
    required this.products,
    required this.productIds,
    required this.name,
    required this.url,
    this.presentedByEventWithName,
    this.presentedByEventWithId,
    this.presentedByEventAt,
    required this.presentedBy,
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
    required this.isFreeTrialAvailable,
    required this.featureGatingBehavior,
    required this.closeReason,
    required this.localNotifications,
    required this.computedPropertyRequests,
    required this.surveys,
  });

  factory PaywallInfo.fromJson(Map<dynamic, dynamic> json) {
    return PaywallInfo(
      identifier: json['identifier'],
      experiment: json['experiment'] != null ? Experiment.fromJson(json['experiment']) : null,
      triggerSessionId: json['triggerSessionId'],
      products: (json['products'] as List<dynamic>).map((e) => Product.fromJson(e)).toList(),
      productIds: List<String>.from(json['productIds']),
      name: json['name'],
      url: json['url'],
      presentedByEventWithName: json['presentedByEventWithName'],
      presentedByEventWithId: json['presentedByEventWithId'],
      presentedByEventAt: json['presentedByEventAt'],
      presentedBy: json['presentedBy'],
      presentationSourceType: json['presentationSourceType'],
      responseLoadStartTime: json['responseLoadStartTime'],
      responseLoadCompleteTime: json['responseLoadCompleteTime'],
      responseLoadFailTime: json['responseLoadFailTime'],
      responseLoadDuration: json['responseLoadDuration']?.toDouble(),
      webViewLoadStartTime: json['webViewLoadStartTime'],
      webViewLoadCompleteTime: json['webViewLoadCompleteTime'],
      webViewLoadFailTime: json['webViewLoadFailTime'],
      webViewLoadDuration: json['webViewLoadDuration']?.toDouble(),
      productsLoadStartTime: json['productsLoadStartTime'],
      productsLoadCompleteTime: json['productsLoadCompleteTime'],
      productsLoadFailTime: json['productsLoadFailTime'],
      productsLoadDuration: json['productsLoadDuration']?.toDouble(),
      paywalljsVersion: json['paywalljsVersion'],
      isFreeTrialAvailable: json['isFreeTrialAvailable'],
      featureGatingBehavior: FeatureGatingBehaviorExtension.fromJson(json['featureGatingBehavior']),
      closeReason: PaywallCloseReasonExtension.fromJson(json['closeReason']),
      localNotifications: [],
      computedPropertyRequests: [],
      // TODO: add back when added to Android / safety checks
      // localNotifications: (json['localNotifications'] as List<dynamic>).map((e) => LocalNotification.fromJson(e)).toList(),
      // computedPropertyRequests: (json['computedPropertyRequests'] as List<dynamic>).map((e) => ComputedPropertyRequest.fromJson(e)).toList(),
      surveys: (json['surveys'] as List<dynamic>).map((e) => Survey.fromJson(e)).toList(),
    );
  }
}
