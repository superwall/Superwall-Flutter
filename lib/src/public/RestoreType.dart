import 'package:superwallkit_flutter/src/public/StoreTransaction.dart';

/// An enum whose cases describe the type of restore that occurred.
class RestoreType {
  final RestoreTypeCase type;
  final StoreTransaction? storeTransaction;

  RestoreType._({required this.type, this.storeTransaction});

  static RestoreType viaPurchase(StoreTransaction? storeTransaction) => RestoreType._(type: RestoreTypeCase.viaPurchase, storeTransaction: storeTransaction);
  static RestoreType viaRestore = RestoreType._(type: RestoreTypeCase.viaRestore);

  factory RestoreType.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'viaPurchase':
        return RestoreType.viaPurchase(
          json['storeTransaction'] != null
              ? StoreTransaction.fromJson(json['storeTransaction'])
              : null,
        );
      case 'viaRestore':
        return RestoreType.viaRestore;
      default:
        throw ArgumentError('Invalid RestoreType type');
    }
  }
}

enum RestoreTypeCase {
  viaPurchase,
  viaRestore,
}