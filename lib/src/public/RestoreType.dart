import 'package:superwallkit_flutter/src/public/StoreTransaction.dart';

/// An enum whose cases describe the type of restore that occurred.
class RestoreType {
  final RestoreTypeCase type;
  final StoreTransaction? transaction;

  const RestoreType._(this.type, {this.transaction});

  // Static constants for each case
  static RestoreType viaPurchase(StoreTransaction? transaction) => RestoreType._(RestoreTypeCase.viaPurchase, transaction: transaction);
  static const RestoreType viaRestore = RestoreType._(RestoreTypeCase.viaRestore);

  factory RestoreType.fromJson(Map<dynamic, dynamic> json) {
    RestoreTypeCase type = RestoreTypeCaseExtension.fromJson(json['type']);
    StoreTransaction? transaction;

    if (type == RestoreTypeCase.viaPurchase) {
      transaction = json['transaction'] != null ? StoreTransaction.fromJson(json['transaction']) : null;
    }

    return RestoreType._(type, transaction: transaction);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'transaction': transaction?.toJson(), // null for viaRestore case
    };
  }
}

enum RestoreTypeCase {
  viaPurchase,
  viaRestore,
}

extension RestoreTypeCaseExtension on RestoreTypeCase {
  String toJson() {
    switch (this) {
      case RestoreTypeCase.viaPurchase:
        return 'viaPurchase';
      case RestoreTypeCase.viaRestore:
        return 'viaRestore';
      default:
        throw ArgumentError('Invalid RestoreTypeCase value');
    }
  }

  static RestoreTypeCase fromJson(String json) {
    switch (json) {
      case 'viaPurchase':
        return RestoreTypeCase.viaPurchase;
      case 'viaRestore':
        return RestoreTypeCase.viaRestore;
      default:
        throw ArgumentError('Invalid RestoreTypeCase value: $json');
    }
  }
}