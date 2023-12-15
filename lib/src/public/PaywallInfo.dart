import 'package:flutter/services.dart';

// TODO
class PaywallInfo {
  final String identifier;
  final String? experiment; // Replace with the proper type if you have an Experiment class
  final String? triggerSessionId;
  final List<String> products; // Replace with List<Product> if you have a Product class
  final List<String> productIds;
  final String name;
  final String url; // URL as a String
  // ... other properties like presentedByEventWithName, presentedByEventWithId, etc.
  final String? presentedBy; // TODO: Remove optional
  final String? presentationSourceType;
  // ... more properties for responseLoadStartTime, webViewLoadStartTime, etc.
  final bool isFreeTrialAvailable;
  // ... featureGatingBehavior, closeReason, localNotifications, etc.
  final List<String> surveys; // Replace with List<Survey> if you have a Survey class

  PaywallInfo({
    required this.identifier,
    this.experiment,
    this.triggerSessionId,
    required this.products,
    required this.productIds,
    required this.name,
    required this.url,
    // ... initialize other fields
    this.presentedBy,
    this.presentationSourceType,
    // ... more fields initialization
    required this.isFreeTrialAvailable,
    required this.surveys,
    // ... initialize remaining fields
  });

  static Future<PaywallInfo?> getPaywallInfo() async {
    final MethodChannel _channel = MethodChannel('SWK_PaywallInfo');
    final Map<dynamic, dynamic>? data = await _channel.invokeMethod('getPaywallInfo');

    if (data != null) {
      return PaywallInfo(
        identifier: data['identifier'],
        experiment: data['experiment'],
        triggerSessionId: data['triggerSessionId'],
        products: List<String>.from(data['products']),
        productIds: List<String>.from(data['productIds']),
        name: data['name'],
        url: data['url'],
        // ... map other fields
        presentedBy: data['presentedBy'],
        presentationSourceType: data['presentationSourceType'],
        // ... map more fields
        isFreeTrialAvailable: data['isFreeTrialAvailable'],
        surveys: List<String>.from(data['surveys']), // Assuming surveys are represented as a list of strings or some simple type
        // ... map remaining fields
      );
    }

    return null;
  }
}