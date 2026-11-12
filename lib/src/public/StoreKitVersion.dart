import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// The StoreKit version the SDK uses, set via
/// `SuperwallOptions.storeKitVersion`.
///
/// iOS only.
enum StoreKitVersion {
  /// StoreKit 1.
  storeKit1,

  /// StoreKit 2.
  storeKit2;

  PStoreKitVersion toPigeon() {
    switch (this) {
      case StoreKitVersion.storeKit1:
        return PStoreKitVersion.storeKit1;
      case StoreKitVersion.storeKit2:
        return PStoreKitVersion.storeKit2;
    }
  }
}

extension StoreKitVersionJson on StoreKitVersion {
  String toJson() {
    switch (this) {
      case StoreKitVersion.storeKit1:
        return 'storeKit1';
      case StoreKitVersion.storeKit2:
        return 'storeKit2';
    }
  }
}
