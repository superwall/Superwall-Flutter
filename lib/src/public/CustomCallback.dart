import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// Represents a custom callback request from the paywall.
///
/// Custom callbacks allow paywalls to request arbitrary actions from the app
/// and receive results that determine which branch (onSuccess/onFailure)
/// executes in the paywall.
class CustomCallback {
  /// The name of the callback being requested.
  final String name;

  /// Optional key-value pairs passed from the paywall.
  /// Values are type-preserved (string/number/boolean).
  final Map<String, Object>? variables;

  CustomCallback({
    required this.name,
    this.variables,
  });

  /// Create from Pigeon type
  static CustomCallback fromPigeon(PCustomCallback pigeon) {
    return CustomCallback(
      name: pigeon.name,
      variables: pigeon.variables,
    );
  }

  /// Convert to Pigeon type
  PCustomCallback toPigeon() {
    return PCustomCallback(
      name: name,
      variables: variables,
    );
  }
}

/// The result status of a custom callback.
enum CustomCallbackResultStatus {
  /// The callback completed successfully.
  success,

  /// The callback failed.
  failure,
}

/// The result to return from a custom callback handler.
///
/// The status determines which branch (onSuccess/onFailure) executes in the paywall.
/// Optional data can be returned and accessed as `callbacks.<name>.data.<key>` in the paywall.
class CustomCallbackResult {
  /// Whether the callback succeeded or failed.
  final CustomCallbackResultStatus status;

  /// Optional key-value pairs to return to the paywall.
  final Map<String, Object>? data;

  CustomCallbackResult({
    required this.status,
    this.data,
  });

  /// Creates a success result with optional data.
  factory CustomCallbackResult.success([Map<String, Object>? data]) {
    return CustomCallbackResult(
      status: CustomCallbackResultStatus.success,
      data: data,
    );
  }

  /// Creates a failure result with optional data.
  factory CustomCallbackResult.failure([Map<String, Object>? data]) {
    return CustomCallbackResult(
      status: CustomCallbackResultStatus.failure,
      data: data,
    );
  }

  /// Create from Pigeon type
  static CustomCallbackResult fromPigeon(PCustomCallbackResult pigeon) {
    return CustomCallbackResult(
      status: pigeon.status == PCustomCallbackResultStatus.success
          ? CustomCallbackResultStatus.success
          : CustomCallbackResultStatus.failure,
      data: pigeon.data,
    );
  }

  /// Convert to Pigeon type
  PCustomCallbackResult toPigeon() {
    return PCustomCallbackResult(
      status: status == CustomCallbackResultStatus.success
          ? PCustomCallbackResultStatus.success
          : PCustomCallbackResultStatus.failure,
      data: data,
    );
  }
}
