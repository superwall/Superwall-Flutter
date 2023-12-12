import 'package:flutter/services.dart';

/// An enum that defines the possible outcomes of attempting to restore a product.
///
/// When implementing the ``PurchaseController/restorePurchases()`` delegate
/// method, all cases should be considered.
class PurchaseResult {
  final _PurchaseResultType _type;
  final Object? _data;
  static const MethodChannel _channel = MethodChannel('SWK_PurchaseResultPlugin');

  const PurchaseResult._(this._type, [this._data]);

  /// The purchase was cancelled.
  ///
  /// This is equivalent to various cancellation cases in StoreKit 1 and `.userCancelled` in StoreKit 2.
  /// In the context of RevenueCat, this is when the `userCancelled` boolean returns `true` from the purchase method.
  static const PurchaseResult cancelled = PurchaseResult._(_PurchaseResultType.cancelled);

  /// The product was purchased.
  static const PurchaseResult purchased = PurchaseResult._(_PurchaseResultType.purchased);

  /// The product was restored.
  static const PurchaseResult restored = PurchaseResult._(_PurchaseResultType.restored);

  /// The purchase is pending and requires action from the developer.
  ///
  /// This corresponds to the `.deferred` transaction state in StoreKit 1 and `.paymentPendingError` in RevenueCat.
  static const PurchaseResult pending = PurchaseResult._(_PurchaseResultType.pending);

  /// The purchase failed for a reason other than the user cancelling or the payment pending.
  ///
  /// The associated `Error` should be sent back for further handling.
  static PurchaseResult failed(Object error) => PurchaseResult._(_PurchaseResultType.failed, error);

  bool get isCancelled => _type == _PurchaseResultType.cancelled;
  bool get isPurchased => _type == _PurchaseResultType.purchased;
  bool get isRestored => _type == _PurchaseResultType.restored;
  bool get isPending => _type == _PurchaseResultType.pending;

  /// If the purchase failed, this returns the associated error.
  Object? get error => _type == _PurchaseResultType.failed ? _data : null;

  Future<bool> isEqualTo(PurchaseResult other) async {
    final bool isEqual = await _channel.invokeMethod('isEqualTo', {
      'result1': _type.toString(),
      'result2': other._type.toString(),
      'data1': _data,
      'data2': other._data,
    });
    return isEqual;
  }
}

enum _PurchaseResultType {
  cancelled,
  purchased,
  restored,
  pending,
  failed,
}
