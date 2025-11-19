import 'CustomerInfo.dart';

// Re-export Entitlement from CustomerInfo.dart for backwards compatibility
export 'CustomerInfo.dart' show Entitlement, EntitlementType, ProductStore;

// Wrapper class for entitlement collections
class Entitlements {
  final Set<Entitlement> active;
  final Set<Entitlement> inactive;
  final Set<Entitlement> all;
  final Set<Entitlement> web;

  Entitlements({
    required this.active,
    required this.inactive,
    required this.all,
    required this.web,
  });
}
