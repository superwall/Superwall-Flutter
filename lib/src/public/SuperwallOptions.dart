import 'package:flutter/services.dart';
import 'package:superwallkit_flutter/src/public/LogLevel.dart';

/// Options for configuring Superwall, including paywall presentation and appearance.
class SuperwallOptions {
  // TODO
  /// Configures the appearance and behaviour of paywalls.
  // PaywallOptions paywalls;

  /// The different network environments that the SDK should use.
  /// Only use this enum to set `networkEnvironment` if told so explicitly by the Superwall team.
  NetworkEnvironment networkEnvironment;

  /// Enables the sending of non-Superwall tracked events and properties back to the Superwall servers.
  /// Defaults to `true`.
  /// Set this to `false` to stop external data collection. This will not affect
  /// your ability to create triggers based on properties.
  bool isExternalDataCollectionEnabled;

  /// Sets the device locale identifier to use when evaluating rules.
  /// This defaults to the `autoupdatingCurrent` locale identifier. However, you can set
  /// this to any locale identifier to override it. E.g. `en_GB`. This is typically used for testing
  /// purposes.
  /// You can also preview your paywall in different locales using
  /// [In-App Previews](https://docs.superwall.com/docs/in-app-paywall-previews).
  String? localeIdentifier;

  /// Forwards events from the game controller to the paywall. Defaults to `false`.
  /// Set this to `true` to forward events from the Game Controller to the Paywall.
  bool isGameControllerEnabled;

  /// The log scope and level to print to the console.
  Logging logging;

  SuperwallOptions({
    // required this.paywalls,
    this.networkEnvironment = NetworkEnvironment.release,
    this.isExternalDataCollectionEnabled = true,
    this.localeIdentifier,
    this.isGameControllerEnabled = false,
    required this.logging,
  });
}

enum NetworkEnvironment {
  /// Default: Uses the standard latest environment.
  release,

  /// Uses a release candidate environment. This is not meant for a production environment.
  releaseCandidate,

  /// Uses the nightly build environment. This is not meant for a production environment.
  developer,
}

class Logging {
  /// Defines the minimum log level to print to the console. Defaults to `warn`.
  LogLevel level;

  /// Defines the scope of logs to print to the console. Defaults to .all.
  Set<LogScope> scopes;

  Logging({this.level = LogLevel.warn, this.scopes = const {LogScope.all}});
}

// TODO
enum LogScope {
  all,
  // Define additional log scopes
}
