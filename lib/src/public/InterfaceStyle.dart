import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The interface style paywalls are shown with, set via
/// `Superwall.shared.setInterfaceStyle()`.
enum InterfaceStyle {
  /// Paywalls are shown in light mode.
  light,

  /// Paywalls are shown in dark mode.
  dark;

  PInterfaceStyle toPigeon() {
    switch (this) {
      case InterfaceStyle.light:
        return PInterfaceStyle.light;
      case InterfaceStyle.dark:
        return PInterfaceStyle.dark;
    }
  }
}
