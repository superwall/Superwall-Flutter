import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/public/CustomerInfo.dart';

/// Configures the screens, actions, support options and appearance of the
/// Customer Center.
///
/// Set the default via [SuperwallOptions.customerCenter] before calling
/// `configure`, or pass one to `Superwall.shared.presentCustomerCenter()`.
///
/// Android only.
class CustomerCenterConfiguration {
  /// The screen shown when the user has at least one subscription (active or
  /// expired) or purchase.
  final CustomerCenterScreen managementScreen;

  /// The screen shown when the user has no purchases at all.
  final CustomerCenterScreen noPurchasesScreen;

  /// Support-related settings (email, app update warning, web management URL).
  final CustomerCenterSupport support;

  /// Optional color overrides.
  final CustomerCenterAppearance appearance;

  /// Shows the account details section (user ID, original download date).
  /// Defaults to `true`.
  final bool showsAccountDetails;

  /// Warns when both a Google Play and a web subscription are active.
  /// Defaults to `true`.
  final bool warnsAboutDuplicateSubscriptions;

  const CustomerCenterConfiguration({
    required this.managementScreen,
    required this.noPurchasesScreen,
    this.support = const CustomerCenterSupport(),
    this.appearance = const CustomerCenterAppearance(),
    this.showsAccountDetails = true,
    this.warnsAboutDuplicateSubscriptions = true,
  });

  /// The default configuration: restore, change plan, refund, manage
  /// subscription (with a cancellation survey) and contact support on the
  /// management screen; restore on the no-purchases screen.
  static CustomerCenterConfiguration get defaultConfiguration =>
      CustomerCenterConfiguration(
        managementScreen: CustomerCenterScreen(paths: [
          CustomerCenterPath.restore(),
          CustomerCenterPath.changePlan(),
          CustomerCenterPath.refund(),
          CustomerCenterPath.manageSubscription(
              survey: CustomerCenterFeedbackSurvey.cancellation),
          CustomerCenterPath.contactSupport(),
        ]),
        noPurchasesScreen:
            CustomerCenterScreen(paths: [CustomerCenterPath.restore()]),
      );

  PCustomerCenterConfiguration toPigeon() => PCustomerCenterConfiguration(
        managementScreen: managementScreen.toPigeon(),
        noPurchasesScreen: noPurchasesScreen.toPigeon(),
        support: support.toPigeon(),
        accent: appearance.accent?.toPigeon(),
        showsAccountDetails: showsAccountDetails,
        warnsAboutDuplicateSubscriptions: warnsAboutDuplicateSubscriptions,
      );
}

/// A Customer Center screen: a title, optional subtitle and an ordered list of
/// paths.
class CustomerCenterScreen {
  /// Title. `null` uses the localized default for the screen.
  final String? title;

  /// Subtitle. `null` uses the localized default (no-purchases screen) or
  /// none (management screen).
  final String? subtitle;

  /// Ordered paths (actions) shown on the screen.
  final List<CustomerCenterPath> paths;

  const CustomerCenterScreen({this.title, this.subtitle, required this.paths});

  PCustomerCenterScreen toPigeon() => PCustomerCenterScreen(
        title: title,
        subtitle: subtitle,
        paths: paths.map((path) => path.toPigeon()).toList(),
      );
}

/// An action row in the Customer Center.
class CustomerCenterPath {
  /// What the path does.
  final CustomerCenterPathType type;

  /// Row title. `null` uses the localized default for [type].
  final String? title;

  /// Optional survey shown before the action runs.
  final CustomerCenterFeedbackSurvey? survey;

  /// Stable identifier, reported as `path_id` on Customer Center events.
  /// `null` uses the default for [type]: the type's name for the built-in
  /// types, the URL's host and path for a URL path, and the identifier for a
  /// custom path. Only needed to tell apart two paths that would otherwise
  /// share one.
  final String? id;

  const CustomerCenterPath(
      {required this.type, this.title, this.survey, this.id});

  factory CustomerCenterPath.restore(
          {String? id, String? title, CustomerCenterFeedbackSurvey? survey}) =>
      CustomerCenterPath(
          type: const CustomerCenterPathTypeRestore(),
          id: id,
          title: title,
          survey: survey);

  factory CustomerCenterPath.manageSubscription(
          {String? id, String? title, CustomerCenterFeedbackSurvey? survey}) =>
      CustomerCenterPath(
          type: const CustomerCenterPathTypeManageSubscription(),
          id: id,
          title: title,
          survey: survey);

  /// [window] is how long after purchase a refund may be requested.
  factory CustomerCenterPath.refund(
          {Duration? window,
          String? id,
          String? title,
          CustomerCenterFeedbackSurvey? survey}) =>
      CustomerCenterPath(
          type: CustomerCenterPathTypeRefund(window: window),
          id: id,
          title: title,
          survey: survey);

  /// [productIds] is the subset of plans to offer. `null` offers every plan.
  factory CustomerCenterPath.changePlan(
          {List<String>? productIds,
          String? id,
          String? title,
          CustomerCenterFeedbackSurvey? survey}) =>
      CustomerCenterPath(
          type: CustomerCenterPathTypeChangePlan(productIds: productIds),
          id: id,
          title: title,
          survey: survey);

  factory CustomerCenterPath.contactSupport(
          {String? id, String? title, CustomerCenterFeedbackSurvey? survey}) =>
      CustomerCenterPath(
          type: const CustomerCenterPathTypeContactSupport(),
          id: id,
          title: title,
          survey: survey);

  /// [title] is required: a URL has no name the SDK could give it.
  factory CustomerCenterPath.url(String url,
          {required String title,
          CustomerCenterOpenMethod openMethod = CustomerCenterOpenMethod.inApp,
          String? id,
          CustomerCenterFeedbackSurvey? survey}) =>
      CustomerCenterPath(
          type: CustomerCenterPathTypeUrl(url: url, openMethod: openMethod),
          id: id,
          title: title,
          survey: survey);

  /// [identifier] is passed back in [CustomerCenterActionCustom] when tapped.
  factory CustomerCenterPath.custom(String identifier,
          {String? title, String? id, CustomerCenterFeedbackSurvey? survey}) =>
      CustomerCenterPath(
          type: CustomerCenterPathTypeCustom(identifier: identifier),
          id: id,
          title: title,
          survey: survey);

  PCustomerCenterPath toPigeon() => PCustomerCenterPath(
        type: type.toPigeon(),
        title: title,
        survey: survey?.toPigeon(),
        id: id,
      );
}

/// The kinds of path the Customer Center supports.
sealed class CustomerCenterPathType {
  const CustomerCenterPathType();

  PCustomerCenterPathType toPigeon() {
    final type = this;
    switch (type) {
      case CustomerCenterPathTypeRestore():
        return PCustomerCenterRestorePathType();
      case CustomerCenterPathTypeManageSubscription():
        return PCustomerCenterManageSubscriptionPathType();
      case CustomerCenterPathTypeRefund():
        return PCustomerCenterRefundPathType(
            windowMillis: type.window?.inMilliseconds);
      case CustomerCenterPathTypeChangePlan():
        return PCustomerCenterChangePlanPathType(productIds: type.productIds);
      case CustomerCenterPathTypeContactSupport():
        return PCustomerCenterContactSupportPathType();
      case CustomerCenterPathTypeUrl():
        return PCustomerCenterUrlPathType(
            url: type.url, openMethod: type.openMethod.toPigeon());
      case CustomerCenterPathTypeCustom():
        return PCustomerCenterCustomPathType(identifier: type.identifier);
    }
  }
}

/// Restores purchases.
class CustomerCenterPathTypeRestore extends CustomerCenterPathType {
  const CustomerCenterPathTypeRestore();
}

/// Opens the subscription management page.
class CustomerCenterPathTypeManageSubscription extends CustomerCenterPathType {
  const CustomerCenterPathTypeManageSubscription();
}

/// Requests a refund.
class CustomerCenterPathTypeRefund extends CustomerCenterPathType {
  /// How long after purchase a refund may be requested. `null` for no limit.
  final Duration? window;

  const CustomerCenterPathTypeRefund({this.window});
}

/// Changes the subscription plan.
class CustomerCenterPathTypeChangePlan extends CustomerCenterPathType {
  /// The subset of plans to offer. `null` offers every plan.
  final List<String>? productIds;

  const CustomerCenterPathTypeChangePlan({this.productIds});
}

/// Contacts support by email, using [CustomerCenterSupport.email].
class CustomerCenterPathTypeContactSupport extends CustomerCenterPathType {
  const CustomerCenterPathTypeContactSupport();
}

/// Opens a URL.
class CustomerCenterPathTypeUrl extends CustomerCenterPathType {
  final String url;
  final CustomerCenterOpenMethod openMethod;

  const CustomerCenterPathTypeUrl(
      {required this.url, this.openMethod = CustomerCenterOpenMethod.inApp});
}

/// A custom action, reported to [CustomerCenterDelegate] as a
/// [CustomerCenterActionCustom].
class CustomerCenterPathTypeCustom extends CustomerCenterPathType {
  final String identifier;

  const CustomerCenterPathTypeCustom({required this.identifier});
}

/// How a URL path opens.
enum CustomerCenterOpenMethod {
  /// In an in-app browser tab, when the URL is `http` or `https`.
  inApp,

  /// Handed to whichever app handles the URL.
  external;

  PCustomerCenterOpenMethod toPigeon() {
    switch (this) {
      case CustomerCenterOpenMethod.inApp:
        return PCustomerCenterOpenMethod.inApp;
      case CustomerCenterOpenMethod.external:
        return PCustomerCenterOpenMethod.external;
    }
  }
}

/// A single-choice survey shown before a path's action runs.
class CustomerCenterFeedbackSurvey {
  final String id;

  /// Question text. `null` uses the localized "Why are you cancelling?" on a
  /// manage-subscription path, and no title on any other path.
  final String? title;

  final List<CustomerCenterSurveyOption> options;

  const CustomerCenterFeedbackSurvey(
      {required this.id, this.title, required this.options});

  /// The built-in cancellation survey: "Why are you cancelling?" with the
  /// three built-in options, all localized.
  static const CustomerCenterFeedbackSurvey cancellation =
      CustomerCenterFeedbackSurvey(id: 'cancel_survey', options: [
    CustomerCenterSurveyOption.tooExpensive,
    CustomerCenterSurveyOption.dontUse,
    CustomerCenterSurveyOption.boughtByMistake,
  ]);

  PCustomerCenterSurvey toPigeon() => PCustomerCenterSurvey(
        id: id,
        title: title,
        options: options.map((option) => option.toPigeon()).toList(),
      );
}

/// An option in a [CustomerCenterFeedbackSurvey].
class CustomerCenterSurveyOption {
  final String id;

  /// Option text. `null` uses the localized default for the built-in options.
  final String? title;

  const CustomerCenterSurveyOption({required this.id, this.title});

  /// "Too expensive", localized.
  static const CustomerCenterSurveyOption tooExpensive =
      CustomerCenterSurveyOption(id: 'too_expensive');

  /// "Don't use the app", localized.
  static const CustomerCenterSurveyOption dontUse =
      CustomerCenterSurveyOption(id: 'dont_use');

  /// "Bought by mistake", localized.
  static const CustomerCenterSurveyOption boughtByMistake =
      CustomerCenterSurveyOption(id: 'bought_by_mistake');

  PCustomerCenterSurveyOption toPigeon() =>
      PCustomerCenterSurveyOption(id: id, title: title);
}

/// Support-related settings for the Customer Center.
class CustomerCenterSupport {
  /// Support email for the "Contact support" path. `null` hides that path.
  final String? email;

  /// Latest published app version. When set and newer than the installed
  /// version, an update banner shows.
  final String? latestAppVersion;

  /// Whether to show the update banner. Defaults to `true`.
  final bool warnsAboutUpdates;

  /// Overrides the web subscription management page URL used for web-store
  /// subscriptions.
  final String? webManagementUrl;

  const CustomerCenterSupport({
    this.email,
    this.latestAppVersion,
    this.warnsAboutUpdates = true,
    this.webManagementUrl,
  });

  PCustomerCenterSupport toPigeon() => PCustomerCenterSupport(
        email: email,
        latestAppVersion: latestAppVersion,
        warnsAboutUpdates: warnsAboutUpdates,
        webManagementUrl: webManagementUrl,
      );
}

/// Color overrides for the Customer Center.
class CustomerCenterAppearance {
  /// Tints buttons and links. `null` uses the theme's accent.
  final CustomerCenterColorPair? accent;

  const CustomerCenterAppearance({this.accent});
}

/// A light/dark color pair stored as hex strings (`#RRGGBB` or `#RRGGBBAA`).
class CustomerCenterColorPair {
  final String light;
  final String dark;

  const CustomerCenterColorPair({required this.light, required this.dark});

  PCustomerCenterColorPair toPigeon() =>
      PCustomerCenterColorPair(light: light, dark: dark);
}

/// An action the user selected in the Customer Center.
sealed class CustomerCenterAction {
  const CustomerCenterAction();

  static CustomerCenterAction fromPigeon(PCustomerCenterAction action) {
    switch (action) {
      case PCustomerCenterRestoreAction():
        return const CustomerCenterActionRestore();
      case PCustomerCenterManageSubscriptionAction():
        return const CustomerCenterActionManageSubscription();
      case PCustomerCenterRefundAction():
        return const CustomerCenterActionRefund();
      case PCustomerCenterChangePlanAction():
        return const CustomerCenterActionChangePlan();
      case PCustomerCenterContactSupportAction():
        return const CustomerCenterActionContactSupport();
      case PCustomerCenterUrlAction():
        return CustomerCenterActionUrl(action.url);
      case PCustomerCenterCustomAction():
        return CustomerCenterActionCustom(action.identifier);
    }
  }
}

class CustomerCenterActionRestore extends CustomerCenterAction {
  const CustomerCenterActionRestore();
}

class CustomerCenterActionManageSubscription extends CustomerCenterAction {
  const CustomerCenterActionManageSubscription();
}

class CustomerCenterActionRefund extends CustomerCenterAction {
  const CustomerCenterActionRefund();
}

class CustomerCenterActionChangePlan extends CustomerCenterAction {
  const CustomerCenterActionChangePlan();
}

class CustomerCenterActionContactSupport extends CustomerCenterAction {
  const CustomerCenterActionContactSupport();
}

class CustomerCenterActionUrl extends CustomerCenterAction {
  final String url;

  const CustomerCenterActionUrl(this.url);
}

class CustomerCenterActionCustom extends CustomerCenterAction {
  final String identifier;

  const CustomerCenterActionCustom(this.identifier);
}

/// Outcome of a refund request made from the Customer Center.
///
/// Google Play takes refund requests on its own pages, so the SDK can't see
/// how one ends: [success] means the request was handed to Google Play,
/// [error] that it couldn't be. [userCancelled] isn't reported on Android.
enum CustomerCenterRefundStatus {
  success,
  userCancelled,
  error;

  static CustomerCenterRefundStatus fromPigeon(
      PCustomerCenterRefundStatus status) {
    switch (status) {
      case PCustomerCenterRefundStatus.success:
        return CustomerCenterRefundStatus.success;
      case PCustomerCenterRefundStatus.userCancelled:
        return CustomerCenterRefundStatus.userCancelled;
      case PCustomerCenterRefundStatus.error:
        return CustomerCenterRefundStatus.error;
    }
  }
}

/// The purchase a Customer Center action applies to.
class CustomerCenterPurchase {
  /// The product purchased. `null` for an entitlement with no product behind
  /// it, such as a manually granted one.
  final String? productId;

  /// Where the purchase was made.
  final ProductStore store;

  /// The entitlements the purchase unlocks, including any it no longer
  /// grants, so check [Entitlement.isActive] before treating one as current.
  final Set<Entitlement> entitlements;

  /// The subscription, when the purchase is one.
  final SubscriptionTransaction? subscription;

  /// The one-time purchase, when the purchase is one.
  final NonSubscriptionTransaction? nonSubscription;

  const CustomerCenterPurchase({
    this.productId,
    required this.store,
    required this.entitlements,
    this.subscription,
    this.nonSubscription,
  });

  factory CustomerCenterPurchase.fromPigeon(PCustomerCenterPurchase purchase) =>
      CustomerCenterPurchase(
        productId: purchase.productId,
        store: ProductStore.fromPigeon(purchase.store),
        entitlements: purchase.entitlements.map(Entitlement.fromPigeon).toSet(),
        subscription: purchase.subscription != null
            ? SubscriptionTransaction.fromPigeon(purchase.subscription!)
            : null,
        nonSubscription: purchase.nonSubscription != null
            ? NonSubscriptionTransaction.fromPigeon(purchase.nonSubscription!)
            : null,
      );
}

/// Receives Customer Center events. All methods have default implementations.
///
/// Pass one to `Superwall.shared.presentCustomerCenter()`. It's only called
/// while that Customer Center is presented.
///
/// Android only.
abstract class CustomerCenterDelegate {
  /// Called before purchases are restored. Return `false` to cancel, for
  /// example after the user declines to sign in. The restore waits until the
  /// returned future completes.
  Future<bool> customerCenterShouldRestorePurchases() async => true;

  /// Called whenever the user taps a path, including custom and URL paths,
  /// before the action runs. [pathId] is the tapped path's
  /// [CustomerCenterPath.id], and [purchase] the purchase it applies to, or
  /// `null` for a screen-level action such as restore.
  void customerCenterDidSelectAction(CustomerCenterAction action, String pathId,
      CustomerCenterPurchase? purchase) {}

  /// Called when the user answers a survey attached to a path.
  void customerCenterDidCompleteSurvey(String surveyId, String optionId,
      CustomerCenterAction action, String pathId) {}

  /// Called when a refund request finishes. See [CustomerCenterRefundStatus].
  void customerCenterDidCompleteRefundRequest(
      String productId, CustomerCenterRefundStatus status) {}

  /// Called when the Customer Center is dismissed.
  void customerCenterDidDismiss() {}
}
