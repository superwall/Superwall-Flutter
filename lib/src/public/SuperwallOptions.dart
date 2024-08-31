import 'package:superwallkit_flutter/superwallkit_flutter.dart';

/// Options for configuring Superwall, including paywall presentation and appearance.
class SuperwallOptions {
  /// Configures the appearance and behaviour of paywalls.
  PaywallOptions paywalls = PaywallOptions();

  /// Determines which network environment your SDK should use.
  /// Defaults to NetworkEnvironment.release. You should under no circumstance
  /// change this unless you received the go-ahead from the Superwall team.
  NetworkEnvironment networkEnvironment = NetworkEnvironment.release;

  /// Enables the sending of non-Superwall tracked events and properties
  /// back to the Superwall servers.
  /// Defaults to `true`.
  bool isExternalDataCollectionEnabled = true;

  /// Sets the device locale identifier to use when evaluating rules.
  String? localeIdentifier;

  /// Forwards events from the game controller to the paywall.
  /// Defaults to `false`.
  bool isGameControllerEnabled = false;

  /// The log scope and level to print to the console.
  Logging logging = Logging();
}

extension SuperwallOptionsJson on SuperwallOptions {
  Map<dynamic, dynamic> toJson() {
    return {
      'paywalls': paywalls.toJson(),
      'networkEnvironment': networkEnvironment.toJson(),
      'isExternalDataCollectionEnabled': isExternalDataCollectionEnabled,
      'localeIdentifier': localeIdentifier,
      'isGameControllerEnabled': isGameControllerEnabled,
      'logging': logging.toJson(),
    };
  }
}

/// The different network environments that the SDK should use.
/// Only use this enum to set `networkEnvironment` if told so explicitly
/// by the Superwall team.
enum NetworkEnvironment {
  /// Default: Uses the standard latest environment.
  release,
  /// **WARNING**: Uses a release candidate environment. This is not meant
  /// for a production environment.
  releaseCandidate,
  /// **WARNING**: Uses the nightly build environment. This is not meant for
  /// a production environment.
  developer,
}

extension NetworkEnvironmentJson on NetworkEnvironment {
  String toJson() {
    switch (this) {
      case NetworkEnvironment.release:
        return 'release';
      case NetworkEnvironment.releaseCandidate:
        return 'releaseCandidate';
      case NetworkEnvironment.developer:
        return 'developer';
    }
  }
}

/// Configuration for printing to the console.
class Logging {
  /// Defines the minimum log level to print to the console. Defaults to `info`.
  LogLevel level = LogLevel.info;

  /// Defines the scope of logs to print to the console. Defaults to .all.
  Set<LogScope> scopes = { LogScope.all };

  void handleLogRecord(LogLevel level, String message, [Object? error, StackTrace? trace]) {
    if (level.index < this.level.index) {
      return;
    }

    // ignore: avoid_print
    print('[$level] $message');
    if (error != null) {
      // ignore: avoid_print
      print(error);
    }
    if (trace != null) {
      // ignore: avoid_print
      print(trace);
    }
  }

  void debug(String message, [Object? error, StackTrace? trace])
    => handleLogRecord(LogLevel.debug, message, error, trace);
  void info(String message, [Object? error, StackTrace? trace])
    => handleLogRecord(LogLevel.info, message, error, trace);
  void warn(String message, [Object? error, StackTrace? trace])
    => handleLogRecord(LogLevel.warn, message, error, trace);
  void error(String message, [Object? error, StackTrace? trace])
    => handleLogRecord(LogLevel.error, message, error, trace);
}

extension LoggingJson on Logging {
  Map<dynamic, dynamic> toJson() {
    return {
      'level': level.toJson(),
      'scopes': scopes.map((scope) => scope.toJson()).toList(),
    };
  }
}