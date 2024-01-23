import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/src/public/RestoreType.dart';
import 'package:superwallkit_flutter/src/public/StoreProduct.dart';
import 'package:superwallkit_flutter/src/public/StoreTransaction.dart';
import 'package:superwallkit_flutter/src/public/Survey.dart';
import 'package:superwallkit_flutter/src/public/TransactionError.dart';
import 'package:superwallkit_flutter/src/public/TransactionProduct.dart';
import 'package:superwallkit_flutter/src/public/TriggerResult.dart';

class SuperwallEvent {
  final _SuperwallEventType _type;
  final Object? _data;

  const SuperwallEvent._(this._type, [this._data]);

  // When the user is first seen in the app, regardless of whether the user is logged in or not.
  static const SuperwallEvent firstSeen = SuperwallEvent._(_SuperwallEventType.firstSeen);

  // Anytime the app enters the foreground
  static const SuperwallEvent appOpen = SuperwallEvent._(_SuperwallEventType.appOpen);

  // When the app is launched from a cold start
  // The raw value of this event can be added to a campaign to trigger a paywall.
  static const SuperwallEvent appLaunch = SuperwallEvent._(_SuperwallEventType.appLaunch);

  // When the SDK is configured for the first time.
  // The raw value of this event can be added to a campaign to trigger a paywall.
  static const SuperwallEvent appInstall = SuperwallEvent._(_SuperwallEventType.appInstall);

  // When the app is opened at least an hour since last `appClose`.
  // The raw value of this event can be added to a campaign to trigger a paywall.
  static const SuperwallEvent sessionStart = SuperwallEvent._(_SuperwallEventType.sessionStart);

  // When device attributes are sent to the backend.
  static SuperwallEvent deviceAttributes(Map<String, dynamic> attributes) =>
      SuperwallEvent._(_SuperwallEventType.deviceAttributes, attributes);

  // When the user's subscription status changes.
  static const SuperwallEvent subscriptionStatusDidChange = SuperwallEvent._(_SuperwallEventType.subscriptionStatusDidChange);

  // Anytime the app leaves the foreground.
  static const SuperwallEvent appClose = SuperwallEvent._(_SuperwallEventType.appClose);

  // When a user opens the app via a deep link.
  // The raw value of this event can be added to a campaign to trigger a paywall.
  static SuperwallEvent deepLink(String url) =>
      SuperwallEvent._(_SuperwallEventType.deepLink, url);

  // When the tracked event matches an event added as a paywall trigger in a campaign.
  // The result of firing the trigger is accessible in the `result` associated value.
  static SuperwallEvent triggerFire(String eventName, TriggerResult result) =>
      SuperwallEvent._(_SuperwallEventType.triggerFire, {'eventName': eventName, 'result': result});

  // When a paywall is opened.
  static SuperwallEvent paywallOpen(PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallOpen, paywallInfo);

  // When a paywall is closed.
  static SuperwallEvent paywallClose(PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallClose, paywallInfo);

  // When a user manually dismisses a paywall.
  static SuperwallEvent paywallDecline(PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallDecline, paywallInfo);

  // When the payment sheet is displayed to the user.
  static SuperwallEvent transactionStart(StoreProduct product, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.transactionStart, {'product': product, 'paywallInfo': paywallInfo});

  // When the payment sheet fails to complete a transaction (ignores user canceling the transaction).
  static SuperwallEvent transactionFail(TransactionError error, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.transactionFail, {'error': error, 'paywallInfo': paywallInfo});

  // When the user cancels a transaction.
  static SuperwallEvent transactionAbandon(StoreProduct product, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.transactionAbandon, {'product': product, 'paywallInfo': paywallInfo});

  // When the user completes checkout in the payment sheet and any product was purchased.
  // Note: The `transaction` is an optional `StoreTransaction` object. Most of the time
  // this won't be `nil`. However, it could be `nil` if you are using a `PurchaseController`
  // and the transaction object couldn't be detected after you return `.purchased` in `PurchaseController/purchase(product:)`.
  static SuperwallEvent transactionComplete(StoreTransaction? transaction, StoreProduct product, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.transactionComplete, {'transaction': transaction, 'product': product, 'paywallInfo': paywallInfo});

  // When the user successfully completes a transaction for a subscription product with no introductory offers.
  static SuperwallEvent subscriptionStart(StoreProduct product, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.subscriptionStart, {'product': product, 'paywallInfo': paywallInfo});

  // When the user successfully completes a transaction for a subscription product with an introductory offer.
  static SuperwallEvent freeTrialStart(StoreProduct product, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.freeTrialStart, {'product': product, 'paywallInfo': paywallInfo});

  // When the user successfully restores purchases.
  static SuperwallEvent transactionRestore(RestoreType restoreType, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.transactionRestore, {'restoreType': restoreType, 'paywallInfo': paywallInfo});

  // When the transaction took > 5 seconds to show the payment sheet.
  static SuperwallEvent transactionTimeout(PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.transactionTimeout, paywallInfo);

  // When the user attributes are set.
  static SuperwallEvent userAttributes(Map<String, dynamic> attributes) =>
      SuperwallEvent._(_SuperwallEventType.userAttributes, attributes);

  // When the user purchased a non recurring product.
  static SuperwallEvent nonRecurringProductPurchase(TransactionProduct product, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.nonRecurringProductPurchase, {'product': product, 'paywallInfo': paywallInfo});

  // When a paywall's request to Superwall's servers has started.
  static SuperwallEvent paywallResponseLoadStart(String? triggeredEventName) =>
      SuperwallEvent._(_SuperwallEventType.paywallResponseLoadStart, triggeredEventName);

  // When a paywall's request to Superwall's servers returned a 404 error.
  static SuperwallEvent paywallResponseLoadNotFound(String? triggeredEventName) =>
      SuperwallEvent._(_SuperwallEventType.paywallResponseLoadNotFound, triggeredEventName);

  // When a paywall's request to Superwall's servers produced an error.
  static SuperwallEvent paywallResponseLoadFail(String? triggeredEventName) =>
      SuperwallEvent._(_SuperwallEventType.paywallResponseLoadFail, triggeredEventName);

  // When a paywall's request to Superwall's servers is complete.
  static SuperwallEvent paywallResponseLoadComplete(String? triggeredEventName, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallResponseLoadComplete, {'triggeredEventName': triggeredEventName, 'paywallInfo': paywallInfo});

  // When a paywall's website begins to load.
  static SuperwallEvent paywallWebviewLoadStart(PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallWebviewLoadStart, paywallInfo);

  // When a paywall's website fails to load.
  static SuperwallEvent paywallWebviewLoadFail(PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallWebviewLoadFail, paywallInfo);

  // When a paywall's website completes loading.
  static SuperwallEvent paywallWebviewLoadComplete(PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallWebviewLoadComplete, paywallInfo);

  // When the loading of a paywall's website times out.
  static SuperwallEvent paywallWebviewLoadTimeout(PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallWebviewLoadTimeout, paywallInfo);

  // When the request to load the paywall's products started.
  static SuperwallEvent paywallProductsLoadStart(String? triggeredEventName, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallProductsLoadStart, {'triggeredEventName': triggeredEventName, 'paywallInfo': paywallInfo});

  // When the request to load the paywall's products failed.
  static SuperwallEvent paywallProductsLoadFail(String? triggeredEventName, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.paywallProductsLoadFail, {'triggeredEventName': triggeredEventName, 'paywallInfo': paywallInfo});

  // When the request to load the paywall's products completed.
  static SuperwallEvent paywallProductsLoadComplete(String? triggeredEventName) =>
      SuperwallEvent._(_SuperwallEventType.paywallProductsLoadComplete, triggeredEventName);

  // When the response to a paywall survey is recorded.
  static SuperwallEvent surveyResponse(Survey survey, SurveyOption selectedOption, String? customResponse, PaywallInfo paywallInfo) =>
      SuperwallEvent._(_SuperwallEventType.surveyResponse, {'survey': survey, 'selectedOption': selectedOption, 'customResponse': customResponse, 'paywallInfo': paywallInfo});

  // TODO
  // // Information about the paywall presentation request
  // static SuperwallEvent paywallPresentationRequest(PaywallPresentationRequestStatus status, PaywallPresentationRequestStatusReason? reason) =>
  //     SuperwallEvent._(_SuperwallEventType.paywallPresentationRequest, {'status': status, 'reason': reason});

  // When the first touch was detected on the UIWindow of the app.
  // This is only registered if there's an active `touches_began` trigger on your dashboard.
  static const SuperwallEvent touchesBegan = SuperwallEvent._(_SuperwallEventType.touchesBegan);

  // When the user chose the close button on a survey instead of responding.
  static const SuperwallEvent surveyClose = SuperwallEvent._(_SuperwallEventType.surveyClose);
}

enum _SuperwallEventType {
  firstSeen,
  appOpen,
  appLaunch,
  appInstall,
  sessionStart,
  deviceAttributes,
  subscriptionStatusDidChange,
  appClose,
  deepLink,
  triggerFire,
  paywallOpen,
  paywallClose,
  paywallDecline,
  transactionStart,
  transactionFail,
  transactionAbandon,
  transactionComplete,
  subscriptionStart,
  freeTrialStart,
  transactionRestore,
  transactionTimeout,
  userAttributes,
  nonRecurringProductPurchase,
  paywallResponseLoadStart,
  paywallResponseLoadNotFound,
  paywallResponseLoadFail,
  paywallResponseLoadComplete,
  paywallWebviewLoadStart,
  paywallWebviewLoadFail,
  paywallWebviewLoadComplete,
  paywallWebviewLoadTimeout,
  paywallProductsLoadStart,
  paywallProductsLoadFail,
  paywallProductsLoadComplete,
  surveyResponse,
  touchesBegan,
  surveyClose,
}
