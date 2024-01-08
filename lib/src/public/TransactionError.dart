import 'package:superwallkit_flutter/src/public/StoreProduct.dart';

class TransactionError {
  // TODO
  // final _TransactionErrorType _type;
  // final String? reason; // For 'pending'
  // final String? message; // For 'failure'
  // final StoreProduct? product; // For 'failure'
  //
  // const TransactionError._(this._type, {this.reason, this.message, this.product});
  //
  // // Static constants for each case
  // static TransactionError pending(String reason) => TransactionError._(_TransactionErrorType.pending, reason: reason);
  // static TransactionError failure(String message, StoreProduct product) => TransactionError._(_TransactionErrorType.failure, message: message, product: product);
}

enum _TransactionErrorType {
  pending,
  failure,
}
