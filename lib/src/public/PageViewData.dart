import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// Describes a page view in a multi-page paywall, carried by the
/// `paywallPageView` event.
class PageViewData {
  /// The identifier of the page that was viewed.
  final String pageNodeId;

  /// The position of the page in the paywall's flow.
  final int flowPosition;

  /// The name of the page.
  final String pageName;

  /// The identifier of the navigation node the page belongs to.
  final String navigationNodeId;

  /// The identifier of the page the user came from, if there was one.
  final String? previousPageNodeId;

  /// The flow position of the page the user came from, if there was one.
  final int? previousFlowPosition;

  /// How the user got to the page.
  final String navigationType;

  /// How long the user spent on the previous page, in milliseconds.
  final int? timeOnPreviousPageMs;

  PageViewData({
    required this.pageNodeId,
    required this.flowPosition,
    required this.pageName,
    required this.navigationNodeId,
    this.previousPageNodeId,
    this.previousFlowPosition,
    required this.navigationType,
    this.timeOnPreviousPageMs,
  });

  factory PageViewData.fromPigeon(PPageViewData pigeon) {
    return PageViewData(
      pageNodeId: pigeon.pageNodeId,
      flowPosition: pigeon.flowPosition,
      pageName: pigeon.pageName,
      navigationNodeId: pigeon.navigationNodeId,
      previousPageNodeId: pigeon.previousPageNodeId,
      previousFlowPosition: pigeon.previousFlowPosition,
      navigationType: pigeon.navigationType,
      timeOnPreviousPageMs: pigeon.timeOnPreviousPageMs,
    );
  }
}
