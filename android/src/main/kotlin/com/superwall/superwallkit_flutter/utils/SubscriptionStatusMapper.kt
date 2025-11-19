package com.superwall.superwallkit_flutter.utils

import PActive
import PEntitlement
import PEntitlementType
import PInactive
import PSubscriptionStatus
import PUnknown
import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.entitlements.SubscriptionStatus

object SubscriptionStatusMapper {
    fun SubscriptionStatus.toPigeon(): PSubscriptionStatus =
        when (this) {
            is SubscriptionStatus.Active ->
                PActive(
                    entitlements.map {
                        PEntitlement(
                            id = it.id!!,
                            type = PEntitlementType.SERVICE_LEVEL,
                            isActive = true,
                            productIds = emptyList()
                        )
                    },
                )

            is SubscriptionStatus.Inactive -> PInactive(false)
            is SubscriptionStatus.Unknown -> PUnknown(false)
        }

    fun PSubscriptionStatus.fromPigeon(): SubscriptionStatus =
        when (this) {
            is PActive ->
                SubscriptionStatus.Active(
                    this.entitlements
                        .map {
                            Entitlement(it.id!!)
                        }.toSet(),
                )

            is PInactive -> SubscriptionStatus.Inactive
            else -> SubscriptionStatus.Unknown
        }
}
