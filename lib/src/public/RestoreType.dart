import 'package:superwallkit_flutter/src/public/StoreTransaction.dart';

/// An enum whose cases describe the type of restore that occurred.
class RestoreType {
  final RestoreTypeCase type;
  final StoreTransaction? transaction;

  const RestoreType._(this.type, {this.transaction});

  // Static constants for each case
  static RestoreType viaPurchase(StoreTransaction? transaction) => RestoreType._(RestoreTypeCase.viaPurchase, transaction: transaction);
  static const RestoreType viaRestore = RestoreType._(RestoreTypeCase.viaRestore);
}

enum RestoreTypeCase {
  viaPurchase,
  viaRestore,
}