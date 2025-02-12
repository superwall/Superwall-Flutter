package com.superwall.superwallkit_flutter.json

import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.models.entitlements.SubscriptionStatus
import com.superwall.sdk.store.Entitlements

fun Entitlement.toJson(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "type" to type.raw
    )
}

fun Entitlements.toJson(): Map<String, Any> {
    return mapOf(
        "active" to active.map { it.toJson() },
        "inactive" to inactive.map { it.toJson() },
        "all" to all.map { it.toJson() }
    )
}

fun Map<String, Any>.toEntitlement(): Entitlement {
    return Entitlement(
        id = this["id"] as String,
        type = Entitlement.Type.SERVICE_LEVEL
    )
}

/**
 * Serializes a SubscriptionStatus into a JSON map.
 *
 * For an active status, the JSON will include the list of entitlements.
 */
fun SubscriptionStatus.toJson(): Map<String, Any> {
    return when (this) {
        is SubscriptionStatus.Active -> mapOf(
            "type" to "active",
            "entitlements" to entitlements.map { it.toJson() }
        )
        is SubscriptionStatus.Inactive -> mapOf("type" to "inactive")
        is SubscriptionStatus.Unknown -> mapOf("type" to "unknown")
    }
}