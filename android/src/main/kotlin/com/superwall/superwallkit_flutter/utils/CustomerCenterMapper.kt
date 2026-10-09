package com.superwall.superwallkit_flutter.utils

import PCustomerCenterAction
import PCustomerCenterChangePlanAction
import PCustomerCenterChangePlanPathType
import PCustomerCenterConfiguration
import PCustomerCenterContactSupportAction
import PCustomerCenterContactSupportPathType
import PCustomerCenterCustomAction
import PCustomerCenterCustomPathType
import PCustomerCenterManageSubscriptionAction
import PCustomerCenterManageSubscriptionPathType
import PCustomerCenterOpenMethod
import PCustomerCenterPath
import PCustomerCenterPathType
import PCustomerCenterPurchase
import PCustomerCenterRefundAction
import PCustomerCenterRefundPathType
import PCustomerCenterRefundStatus
import PCustomerCenterRestoreAction
import PCustomerCenterRestorePathType
import PCustomerCenterScreen
import PCustomerCenterSurvey
import PCustomerCenterUrlAction
import PCustomerCenterUrlPathType
import PEntitlement
import PEntitlementType
import PLatestSubscriptionOfferType
import PLatestSubscriptionState
import PNonSubscriptionTransaction
import PProductStore
import PSubscriptionTransaction
import com.superwall.sdk.customercenter.CustomerCenterAction
import com.superwall.sdk.customercenter.CustomerCenterConfiguration
import com.superwall.sdk.customercenter.CustomerCenterPurchase
import com.superwall.sdk.customercenter.CustomerCenterRefundStatus
import com.superwall.sdk.models.customer.NonSubscriptionTransaction
import com.superwall.sdk.models.customer.SubscriptionTransaction
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.product.Store
import com.superwall.sdk.store.abstractions.product.receipt.LatestPeriodType
import com.superwall.sdk.store.abstractions.product.receipt.LatestSubscriptionState

/**
 * Converts between the Pigeon Customer Center models and the Android SDK's.
 */
object CustomerCenterMapper {
    fun PCustomerCenterConfiguration.toSdk(): CustomerCenterConfiguration =
        CustomerCenterConfiguration(
            managementScreen = managementScreen.toSdk(),
            noPurchasesScreen = noPurchasesScreen.toSdk(),
            support =
                CustomerCenterConfiguration.Support(
                    email = support.email,
                    latestAppVersion = support.latestAppVersion,
                    warnsAboutUpdates = support.warnsAboutUpdates,
                    webManagementUrl = support.webManagementUrl,
                ),
            appearance =
                CustomerCenterConfiguration.Appearance(
                    accent =
                        accent?.let {
                            CustomerCenterConfiguration.Appearance.ColorPair(light = it.light, dark = it.dark)
                        },
                ),
            showsAccountDetails = showsAccountDetails,
            warnsAboutDuplicateSubscriptions = warnsAboutDuplicateSubscriptions,
        )

    private fun PCustomerCenterScreen.toSdk(): CustomerCenterConfiguration.Screen =
        CustomerCenterConfiguration.Screen(
            title = title,
            subtitle = subtitle,
            paths = paths.map { it.toSdk() },
        )

    private fun PCustomerCenterPath.toSdk(): CustomerCenterConfiguration.Path {
        val sdkType = type.toSdk()
        return CustomerCenterConfiguration.Path(
            type = sdkType,
            title = title,
            survey = survey?.toSdk(),
            id = id ?: sdkType.defaultId,
        )
    }

    private fun PCustomerCenterPathType.toSdk(): CustomerCenterConfiguration.PathType =
        when (this) {
            is PCustomerCenterRestorePathType -> CustomerCenterConfiguration.PathType.Restore
            is PCustomerCenterManageSubscriptionPathType -> CustomerCenterConfiguration.PathType.ManageSubscription
            is PCustomerCenterRefundPathType -> CustomerCenterConfiguration.PathType.Refund(windowMillis)
            is PCustomerCenterChangePlanPathType -> CustomerCenterConfiguration.PathType.ChangePlan(productIds)
            is PCustomerCenterContactSupportPathType -> CustomerCenterConfiguration.PathType.ContactSupport
            is PCustomerCenterUrlPathType ->
                CustomerCenterConfiguration.PathType.Url(
                    url = url,
                    openMethod =
                        when (openMethod) {
                            PCustomerCenterOpenMethod.IN_APP -> CustomerCenterConfiguration.OpenMethod.IN_APP
                            PCustomerCenterOpenMethod.EXTERNAL -> CustomerCenterConfiguration.OpenMethod.EXTERNAL
                        },
                )
            is PCustomerCenterCustomPathType -> CustomerCenterConfiguration.PathType.Custom(identifier)
        }

    private fun PCustomerCenterSurvey.toSdk(): CustomerCenterConfiguration.FeedbackSurvey =
        CustomerCenterConfiguration.FeedbackSurvey(
            id = id,
            title = title,
            options = options.map { CustomerCenterConfiguration.FeedbackSurvey.Option(id = it.id, title = it.title) },
        )

    fun CustomerCenterAction.toPigeon(): PCustomerCenterAction =
        when (this) {
            CustomerCenterAction.Restore -> PCustomerCenterRestoreAction()
            CustomerCenterAction.ManageSubscription -> PCustomerCenterManageSubscriptionAction()
            CustomerCenterAction.Refund -> PCustomerCenterRefundAction()
            CustomerCenterAction.ChangePlan -> PCustomerCenterChangePlanAction()
            CustomerCenterAction.ContactSupport -> PCustomerCenterContactSupportAction()
            is CustomerCenterAction.Url -> PCustomerCenterUrlAction(url)
            is CustomerCenterAction.Custom -> PCustomerCenterCustomAction(identifier)
        }

    fun CustomerCenterRefundStatus.toPigeon(): PCustomerCenterRefundStatus =
        when (this) {
            CustomerCenterRefundStatus.SUCCESS -> PCustomerCenterRefundStatus.SUCCESS
            CustomerCenterRefundStatus.USER_CANCELLED -> PCustomerCenterRefundStatus.USER_CANCELLED
            CustomerCenterRefundStatus.ERROR -> PCustomerCenterRefundStatus.ERROR
        }

    fun CustomerCenterPurchase.toPigeon(): PCustomerCenterPurchase =
        PCustomerCenterPurchase(
            productId = productId,
            store = store.toPigeon(),
            entitlements = entitlements.map { it.toPigeon() },
            subscription = subscription?.toPigeon(),
            nonSubscription = nonSubscription?.toPigeon(),
        )

    private fun Entitlement.toPigeon(): PEntitlement =
        PEntitlement(
            id = id,
            type = PEntitlementType.SERVICE_LEVEL,
            isActive = isActive,
            productIds = productIds.toList(),
            latestProductId = latestProductId,
            store = store?.toPigeon(),
            startsAt = startsAt?.time,
            renewedAt = renewedAt?.time,
            expiresAt = expiresAt?.time,
            isLifetime = isLifetime,
            willRenew = willRenew,
            state = state?.toPigeon(),
            offerType = offerType?.toPigeon(),
        )

    private fun SubscriptionTransaction.toPigeon(): PSubscriptionTransaction =
        PSubscriptionTransaction(
            transactionId = transactionId,
            productId = productId,
            purchaseDate = purchaseDate.time,
            willRenew = willRenew,
            isRevoked = isRevoked,
            isInGracePeriod = isInGracePeriod,
            isInBillingRetryPeriod = isInBillingRetryPeriod,
            isActive = isActive,
            expirationDate = expirationDate?.time,
            offerType = offerType?.toPigeon(),
            subscriptionGroupId = subscriptionGroupId,
            store = store.toPigeon(),
        )

    private fun NonSubscriptionTransaction.toPigeon(): PNonSubscriptionTransaction =
        PNonSubscriptionTransaction(
            transactionId = transactionId,
            productId = productId,
            purchaseDate = purchaseDate.time,
            isConsumable = isConsumable,
            isRevoked = isRevoked,
            store = store.toPigeon(),
        )

    private fun Store.toPigeon(): PProductStore =
        when (this) {
            Store.PLAY_STORE -> PProductStore.PLAY_STORE
            Store.APP_STORE -> PProductStore.APP_STORE
            Store.STRIPE -> PProductStore.STRIPE
            Store.PADDLE -> PProductStore.PADDLE
            Store.SUPERWALL -> PProductStore.SUPERWALL
            else -> PProductStore.OTHER
        }

    private fun LatestSubscriptionState.toPigeon(): PLatestSubscriptionState? =
        when (this) {
            LatestSubscriptionState.GRACE_PERIOD -> PLatestSubscriptionState.IN_GRACE_PERIOD
            LatestSubscriptionState.EXPIRED -> PLatestSubscriptionState.EXPIRED
            LatestSubscriptionState.SUBSCRIBED -> PLatestSubscriptionState.SUBSCRIBED
            LatestSubscriptionState.BILLING_RETRY -> PLatestSubscriptionState.IN_BILLING_RETRY_PERIOD
            LatestSubscriptionState.REVOKED -> PLatestSubscriptionState.REVOKED
            else -> null
        }

    private fun LatestPeriodType.toPigeon(): PLatestSubscriptionOfferType? =
        when (this) {
            LatestPeriodType.TRIAL -> PLatestSubscriptionOfferType.TRIAL
            LatestPeriodType.CODE -> PLatestSubscriptionOfferType.CODE
            LatestPeriodType.PROMOTIONAL -> PLatestSubscriptionOfferType.PROMOTIONAL
            LatestPeriodType.WINBACK -> PLatestSubscriptionOfferType.WINBACK
            else -> null
        }
}
