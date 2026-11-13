import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/private/PaywallViewCallbackProxy.dart';
import 'package:superwallkit_flutter/src/public/CustomCallback.dart';
import 'package:superwallkit_flutter/src/public/PaywallInfo.dart';
import 'package:superwallkit_flutter/src/public/PaywallResult.dart';
import 'package:superwallkit_flutter/src/public/PaywallSkippedReason.dart';
import 'package:uuid/uuid.dart';

/// The loading state of the paywall in a [PaywallView].
enum PaywallLoadingState {
  /// The loading state isn't known yet.
  unknown,

  /// The paywall is waiting on a purchase or a restoration.
  loadingPurchase,

  /// The paywall is loading its web page.
  loadingUrl,

  /// The paywall was told to show its loading indicator.
  manualLoading,

  /// The paywall is ready for the user to interact with.
  ready;

  static PaywallLoadingState fromPigeon(PPaywallLoadingState pigeon) {
    switch (pigeon) {
      case PPaywallLoadingState.unknown:
        return PaywallLoadingState.unknown;
      case PPaywallLoadingState.loadingPurchase:
        return PaywallLoadingState.loadingPurchase;
      case PPaywallLoadingState.loadingUrl:
        return PaywallLoadingState.loadingUrl;
      case PPaywallLoadingState.manualLoading:
        return PaywallLoadingState.manualLoading;
      case PPaywallLoadingState.ready:
        return PaywallLoadingState.ready;
    }
  }
}

/// Embeds the paywall of a placement in your own widget tree, instead of
/// presenting it over the app as `Superwall.shared.registerPlacement()` does.
///
/// The paywall for [placement] is retrieved when the widget is first built.
/// While it loads, [loadingBuilder] is shown over the view. If the user
/// shouldn't see a paywall, [skippedBuilder] is shown instead, and if the
/// paywall couldn't be retrieved, [errorBuilder] is.
///
/// ```dart
/// SizedBox(
///   height: 500,
///   child: PaywallView(
///     placement: 'onboarding',
///     loadingBuilder: (context) =>
///         const Center(child: CircularProgressIndicator()),
///     onFinished: (paywallInfo, result, shouldDismiss) {
///       if (result is PurchasedPaywallResult) {
///         // Unlock the feature.
///       }
///       if (shouldDismiss) {
///         setState(() => _showPaywall = false);
///       }
///     },
///   ),
/// )
/// ```
///
/// Things to know:
///
/// - Call `Superwall.configure()` before building a `PaywallView`.
/// - Give it a bounded size. It fills the space its parent gives it.
/// - Use a different placement for each `PaywallView` that's mounted at the
///   same time. The native SDK shares one paywall instance per paywall, so
///   two views can't show the same paywall at once.
/// - There is no `feature` block. The result of the paywall, such as a
///   purchase, a restoration or the user declining it, arrives via
///   [onFinished], where you decide whether to unlock your feature.
/// - One native view shows one [placement] with one set of [params]. When
///   either changes, the native view is recreated and the paywall is
///   retrieved again.
///
/// Available on Android and iOS. On other platforms the error state is shown.
class PaywallView extends StatefulWidget {
  /// The name of the placement, as you have defined on the Superwall
  /// dashboard, whose paywall is shown.
  final String placement;

  /// Optional parameters to pass with the placement. They can be referenced
  /// in the audience filters of your campaign.
  final Map<String, Object>? params;

  /// Called when the paywall was retrieved and added to the view.
  final void Function(PaywallInfo paywallInfo)? onPresent;

  /// Called when the paywall finished with a [PaywallResult]: the user
  /// purchased, restored or declined the paywall.
  ///
  /// When `shouldDismiss` is `true` the paywall has been removed from the
  /// view, which now renders nothing, and your app should remove the
  /// `PaywallView` from its widget tree. When it's `false`, the paywall
  /// stays on screen, for example when
  /// `PaywallOptions.automaticallyDismiss` is off.
  final void Function(
          PaywallInfo paywallInfo, PaywallResult result, bool shouldDismiss)?
      onFinished;

  /// Called when no paywall is shown, for example because the user is in a
  /// holdout or didn't match an audience. [skippedBuilder] is shown instead.
  final void Function(PaywallSkippedReason reason)? onSkip;

  /// Called when the paywall couldn't be retrieved. [errorBuilder] is shown
  /// instead.
  final void Function(String error)? onError;

  /// Builds the widget shown over the view while the paywall loads. `null`
  /// (the default) shows nothing over the view.
  final WidgetBuilder? loadingBuilder;

  /// Builds the widget shown when no paywall is shown. `null` (the default)
  /// renders nothing.
  final Widget Function(BuildContext context, PaywallSkippedReason reason)?
      skippedBuilder;

  /// Builds the widget shown when the paywall couldn't be retrieved. `null`
  /// (the default) renders nothing.
  final Widget Function(BuildContext context, String error)? errorBuilder;

  /// Called when the paywall's loading state changes.
  ///
  /// Note: iOS only. It's never called on Android.
  final void Function(PaywallLoadingState state)? onLoadingStateChanged;

  /// Called when the paywall requests a custom callback. See
  /// `PaywallPresentationHandler.onCustomCallback`. Without it, custom
  /// callbacks are answered with a failure.
  ///
  /// Note: iOS only. It's never called on Android.
  final Future<CustomCallbackResult> Function(CustomCallback callback)?
      onCustomCallback;

  /// Which gestures the paywall takes from the widgets around it, such as a
  /// scroll view it's placed in.
  ///
  /// Paywalls scroll, so by default the paywall claims every gesture that
  /// starts on it, with an [EagerGestureRecognizer]. Pass your own set, or an
  /// empty one, to change that.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  const PaywallView({
    super.key,
    required this.placement,
    this.params,
    this.onPresent,
    this.onFinished,
    this.onSkip,
    this.onError,
    this.loadingBuilder,
    this.skippedBuilder,
    this.errorBuilder,
    this.onLoadingStateChanged,
    this.onCustomCallback,
    this.gestureRecognizers,
  });

  @override
  State<PaywallView> createState() => _PaywallViewState();
}

enum _Status { loading, presented, skipped, error, dismissed }

class _PaywallViewState extends State<PaywallView> {
  static const _viewType = 'superwallkit_flutter/paywall_view';
  static const _unsupportedError =
      'PaywallView is only available on Android and iOS.';
  static final Set<Factory<OneSequenceGestureRecognizer>>
      _eagerGestureRecognizers = {
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  // Identifies the current platform view and its callback channel. `null` on
  // unsupported platforms.
  String? _hostId;
  _Status _status = _Status.loading;
  PaywallSkippedReason? _skippedReason;
  String? _error;

  bool get _isSupported =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    _createHost();
  }

  @override
  void didUpdateWidget(PaywallView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A platform view shows one placement with one set of params for its
    // whole life, so a change means starting again with a new one.
    if (oldWidget.placement != widget.placement ||
        !_deepEquals(oldWidget.params, widget.params)) {
      _disposeHost();
      _createHost();
    }
  }

  @override
  void dispose() {
    _disposeHost();
    super.dispose();
  }

  void _createHost() {
    _skippedReason = null;
    if (!_isSupported) {
      _hostId = null;
      _status = _Status.error;
      _error = _unsupportedError;
      return;
    }
    _status = _Status.loading;
    _error = null;
    final hostId = const Uuid().v4();
    _hostId = hostId;
    PaywallViewCallbackProxy(
      onLoadStartHandler: () => _update(() => _status = _Status.loading),
      onPresentHandler: (paywallInfo) {
        _update(() => _status = _Status.presented);
        widget.onPresent?.call(paywallInfo);
      },
      onFinishedHandler: (paywallInfo, result, shouldDismiss) {
        if (shouldDismiss) {
          _update(() => _status = _Status.dismissed);
        }
        widget.onFinished?.call(paywallInfo, result, shouldDismiss);
      },
      onSkipHandler: (reason) {
        _update(() {
          _status = _Status.skipped;
          _skippedReason = reason;
        });
        widget.onSkip?.call(reason);
      },
      onErrorHandler: (error) {
        _update(() {
          _status = _Status.error;
          _error = error;
        });
        widget.onError?.call(error);
      },
      onLoadingStateChangedHandler: (state) =>
          widget.onLoadingStateChanged?.call(state),
      customCallbackHandler: () => widget.onCustomCallback,
    ).register(hostId);
  }

  void _disposeHost() {
    final hostId = _hostId;
    if (hostId != null) {
      PaywallViewCallbackProxy.unregister(hostId);
      _hostId = null;
    }
  }

  void _update(VoidCallback change) {
    if (mounted) {
      setState(change);
    }
  }

  static bool _deepEquals(Object? a, Object? b) {
    if (a is Map && b is Map) {
      if (a.length != b.length) return false;
      for (final key in a.keys) {
        if (!b.containsKey(key) || !_deepEquals(a[key], b[key])) return false;
      }
      return true;
    }
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (var i = 0; i < a.length; i++) {
        if (!_deepEquals(a[i], b[i])) return false;
      }
      return true;
    }
    return a == b;
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _Status.skipped:
        return widget.skippedBuilder?.call(context, _skippedReason!) ??
            const SizedBox.shrink();
      case _Status.error:
        return widget.errorBuilder?.call(context, _error!) ??
            const SizedBox.shrink();
      case _Status.dismissed:
        return const SizedBox.shrink();
      case _Status.loading:
      case _Status.presented:
        break;
    }

    // The platform view stays mounted while loading: the native side starts
    // retrieving the paywall when its view is attached.
    final loading = _status == _Status.loading
        ? widget.loadingBuilder?.call(context)
        : null;
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildPlatformView(context),
        if (loading != null) loading,
      ],
    );
  }

  Widget _buildPlatformView(BuildContext context) {
    final hostId = _hostId!;
    final creationParams = <String, Object?>{
      'hostId': hostId,
      'placement': widget.placement,
      if (widget.params != null) 'params': widget.params,
    };
    final gestureRecognizers =
        widget.gestureRecognizers ?? _eagerGestureRecognizers;
    // The key makes Flutter create a new platform view for each host ID.
    final key = ValueKey<String>(hostId);

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: key,
        viewType: _viewType,
        layoutDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: gestureRecognizers,
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      );
    }
    return UiKitView(
      key: key,
      viewType: _viewType,
      layoutDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      gestureRecognizers: gestureRecognizers,
      hitTestBehavior: PlatformViewHitTestBehavior.opaque,
    );
  }
}
