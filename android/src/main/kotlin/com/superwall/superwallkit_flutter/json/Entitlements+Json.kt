package com.superwall.superwallkit_flutter.json

import com.superwall.sdk.models.entitlements.Entitlement
import com.superwall.sdk.store.Entitlements

fun Entitlement.toJson(): Map<String, Any> {
    return mapOf(
        "id" to id,
        "type" to type
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
        type =  Entitlement.Type.valueOf(this["type"] as String)
    )
}