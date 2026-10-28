import 'CustomerInfo.dart';

// Re-export Entitlement from CustomerInfo.dart for backwards compatibility
export 'CustomerInfo.dart' show Entitlement, EntitlementType, ProductStore;

// Wrapper class for entitlement collections
class Entitlements {
  final Set<Entitlement> active;
  final Set<Entitlement> inactive;
  final Set<Entitlement> all;
  final Set<Entitlement> web;

  // Internal callback for native filtering
  final Future<Set<Entitlement>> Function(Set<String>)? _nativeFilterCallback;

  Entitlements({
    required this.active,
    required this.inactive,
    required this.all,
    required this.web,
    Future<Set<Entitlement>> Function(Set<String>)? nativeFilterCallback,
  }) : _nativeFilterCallback = nativeFilterCallback;

  /// Returns all entitlements that contain any of the specified product IDs.
  ///
  /// This method calls the native SDK's byProductIds function to filter entitlements
  /// by product IDs on both iOS and Android, including Android base plan and offer
  /// identifier matching.
  ///
  /// - Parameter productIds: A set of product identifiers to search for.
  /// - Returns: A future that resolves to a set of entitlements that contain any of the specified product IDs.
  ///
  /// Example:
  /// ```dart
  /// final entitlements = await Superwall.shared.getEntitlements();
  /// final filtered = await entitlements.byProductIds({'premium_monthly', 'premium_yearly'});
  /// ```
  Future<Set<Entitlement>> byProductIds(Set<String> productIds) async {
    if (_nativeFilterCallback != null) {
      return await _nativeFilterCallback!(productIds);
    }

    // Fallback to local implementation if no native callback provided
    final Set<Entitlement> result = {};
    for (final productId in productIds) {
      for (final entitlement in all) {
        if (entitlement.productIds.contains(productId)) {
          result.add(entitlement);
        }
      }
    }
    return result;
  }
}
