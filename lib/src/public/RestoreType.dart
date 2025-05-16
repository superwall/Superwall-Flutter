import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/public/StoreTransaction.dart';

/// An enum whose cases describe the type of restore that occurred.
class RestoreType {
  final RestoreTypeCase type;
  final StoreTransaction? storeTransaction;

  RestoreType._({required this.type, this.storeTransaction});

  static RestoreType viaPurchase(StoreTransaction? storeTransaction) =>
      RestoreType._(
          type: RestoreTypeCase.viaPurchase,
          storeTransaction: storeTransaction);
  static RestoreType viaRestore =
      RestoreType._(type: RestoreTypeCase.viaRestore);

  factory RestoreType.fromPigeon(PRestoreType reason) {
    if (reason is PViaPurchase) {
      final storeTransaction = reason.storeTransaction;
      return RestoreType.viaPurchase(storeTransaction != null
          ? StoreTransaction.fromPigeon(storeTransaction)
          : null);
    } else {
      return RestoreType.viaRestore;
    }
  }
}

enum RestoreTypeCase {
  viaPurchase,
  viaRestore,
}
