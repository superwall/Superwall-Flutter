package com.superwall.superwallkit_flutter

import PCustomerCenterDelegateGenerated
import com.superwall.sdk.customercenter.CustomerCenterAction
import com.superwall.sdk.customercenter.CustomerCenterDelegate
import com.superwall.sdk.customercenter.CustomerCenterPurchase
import com.superwall.sdk.customercenter.CustomerCenterRefundStatus
import com.superwall.superwallkit_flutter.utils.CustomerCenterMapper.toPigeon

/**
 * Forwards Customer Center delegate callbacks to the Flutter delegate registered for one
 * presentation. The SDK calls every method on the main thread, which Pigeon requires.
 */
class CustomerCenterDelegateHost(
    private val backingDelegate: PCustomerCenterDelegateGenerated,
) : CustomerCenterDelegate {
    override fun customerCenterShouldRestorePurchases(proceed: (Boolean) -> Unit) {
        backingDelegate.shouldRestorePurchases { result ->
            // Restore by default if Flutter couldn't answer, matching the SDK's default.
            proceed(result.getOrNull() ?: true)
        }
    }

    override fun customerCenterDidSelectAction(
        action: CustomerCenterAction,
        pathId: String,
        purchase: CustomerCenterPurchase?,
    ) {
        backingDelegate.didSelectAction(action.toPigeon(), pathId, purchase?.toPigeon()) {}
    }

    override fun customerCenterDidCompleteSurvey(
        surveyId: String,
        optionId: String,
        action: CustomerCenterAction,
        pathId: String,
    ) {
        backingDelegate.didCompleteSurvey(surveyId, optionId, action.toPigeon(), pathId) {}
    }

    override fun customerCenterDidCompleteRefundRequest(
        productId: String,
        status: CustomerCenterRefundStatus,
    ) {
        backingDelegate.didCompleteRefundRequest(productId, status.toPigeon()) {}
    }

    override fun customerCenterDidDismiss() {
        backingDelegate.didDismiss {}
    }

    fun onDismiss() {
        backingDelegate.onDismiss {}
    }
}
