import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The presentation style of a paywall.
enum PaywallPresentationStyle {
  /// A view presentation animation that uses the modal presentation style.
  modal,

  /// A view presentation style in which the presented paywall slides up to
  /// cover the screen.
  fullscreen,

  /// A view presentation style in which the presented paywall covers the
  /// screen without animation.
  fullscreenNoAnimation,

  /// A view presentation style in which the presented paywall pushes on
  /// screen, as if pushed on to a navigation stack.
  push,

  /// A view presentation style in which the presented paywall slides up to
  /// cover part of the screen.
  drawer,

  /// A view presentation style in which the presented paywall pops up over
  /// the screen.
  popup,

  /// Indicates that the presentation style to use is the modal presentation
  /// style.
  none;

  static PaywallPresentationStyle fromPigeon(PPaywallPresentationStyle pigeon) {
    switch (pigeon) {
      case PPaywallPresentationStyle.modal:
        return PaywallPresentationStyle.modal;
      case PPaywallPresentationStyle.fullscreen:
        return PaywallPresentationStyle.fullscreen;
      case PPaywallPresentationStyle.fullscreenNoAnimation:
        return PaywallPresentationStyle.fullscreenNoAnimation;
      case PPaywallPresentationStyle.push:
        return PaywallPresentationStyle.push;
      case PPaywallPresentationStyle.drawer:
        return PaywallPresentationStyle.drawer;
      case PPaywallPresentationStyle.popup:
        return PaywallPresentationStyle.popup;
      case PPaywallPresentationStyle.none:
        return PaywallPresentationStyle.none;
    }
  }

  PPaywallPresentationStyle toPigeon() {
    switch (this) {
      case PaywallPresentationStyle.modal:
        return PPaywallPresentationStyle.modal;
      case PaywallPresentationStyle.fullscreen:
        return PPaywallPresentationStyle.fullscreen;
      case PaywallPresentationStyle.fullscreenNoAnimation:
        return PPaywallPresentationStyle.fullscreenNoAnimation;
      case PaywallPresentationStyle.push:
        return PPaywallPresentationStyle.push;
      case PaywallPresentationStyle.drawer:
        return PPaywallPresentationStyle.drawer;
      case PaywallPresentationStyle.popup:
        return PPaywallPresentationStyle.popup;
      case PaywallPresentationStyle.none:
        return PPaywallPresentationStyle.none;
    }
  }
}

/// How a paywall is presented.
class PaywallPresentationInfo {
  /// The presentation style of the paywall.
  final PaywallPresentationStyle style;

  /// The delay before the paywall is presented.
  final Duration delay;

  /// The height of a [PaywallPresentationStyle.drawer] or
  /// [PaywallPresentationStyle.popup]. `null` for other styles.
  final double? height;

  /// The width of a [PaywallPresentationStyle.popup]. `null` for other
  /// styles.
  final double? width;

  /// The corner radius of a [PaywallPresentationStyle.drawer] or
  /// [PaywallPresentationStyle.popup]. `null` for other styles.
  final double? cornerRadius;

  PaywallPresentationInfo({
    required this.style,
    this.delay = Duration.zero,
    this.height,
    this.width,
    this.cornerRadius,
  });

  factory PaywallPresentationInfo.fromPigeon(PPaywallPresentationInfo pigeon) {
    return PaywallPresentationInfo(
      style: PaywallPresentationStyle.fromPigeon(pigeon.style),
      delay: Duration(milliseconds: pigeon.delay),
      height: pigeon.height,
      width: pigeon.width,
      cornerRadius: pigeon.cornerRadius,
    );
  }

  PPaywallPresentationInfo toPigeon() {
    return PPaywallPresentationInfo(
      style: style.toPigeon(),
      delay: delay.inMilliseconds,
      height: height,
      width: width,
      cornerRadius: cornerRadius,
    );
  }
}
