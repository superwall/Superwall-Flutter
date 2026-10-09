import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';
import 'package:superwallkit_flutter/src/public/CustomerCenter.dart';

/// A proxy class that bridges between a Flutter [CustomerCenterDelegate] and
/// the generated PCustomerCenterDelegateGenerated interface.
///
/// Each presentation registers its own proxy under a unique host ID, and the
/// proxy unregisters itself once the Customer Center is dismissed.
class CustomerCenterDelegateProxy implements PCustomerCenterDelegateGenerated {
  final CustomerCenterDelegate? delegate;
  final void Function()? onDismissHandler;
  final String hostId;

  CustomerCenterDelegateProxy(
      this.delegate, this.onDismissHandler, this.hostId);

  static int _nextId = 0;

  static String register(
      CustomerCenterDelegate? delegate, void Function()? onDismiss) {
    final hostId = 'customerCenter${_nextId++}';
    PCustomerCenterDelegateGenerated.setUp(
        CustomerCenterDelegateProxy(delegate, onDismiss, hostId),
        messageChannelSuffix: hostId);
    return hostId;
  }

  @override
  Future<bool> shouldRestorePurchases() async {
    return await delegate?.customerCenterShouldRestorePurchases() ?? true;
  }

  @override
  void didSelectAction(PCustomerCenterAction action, String pathId,
      PCustomerCenterPurchase? purchase) {
    delegate?.customerCenterDidSelectAction(
        CustomerCenterAction.fromPigeon(action),
        pathId,
        purchase != null ? CustomerCenterPurchase.fromPigeon(purchase) : null);
  }

  @override
  void didCompleteSurvey(String surveyId, String optionId,
      PCustomerCenterAction action, String pathId) {
    delegate?.customerCenterDidCompleteSurvey(
        surveyId, optionId, CustomerCenterAction.fromPigeon(action), pathId);
  }

  @override
  void didCompleteRefundRequest(
      String productId, PCustomerCenterRefundStatus status) {
    delegate?.customerCenterDidCompleteRefundRequest(
        productId, CustomerCenterRefundStatus.fromPigeon(status));
  }

  @override
  void didDismiss() {
    delegate?.customerCenterDidDismiss();
  }

  @override
  void onDismiss() {
    // Native calls `onDismiss` last, after the delegate, so the channels can be
    // released here.
    PCustomerCenterDelegateGenerated.setUp(null, messageChannelSuffix: hostId);
    onDismissHandler?.call();
  }
}
