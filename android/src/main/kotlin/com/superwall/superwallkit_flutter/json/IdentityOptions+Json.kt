package com.superwall.superwallkit_flutter.json

import com.superwall.sdk.identity.IdentityOptions

fun JsonExtensions.Companion.identityOptionsFromJson(json: Map<String, Any?>): IdentityOptions? {
    val restorePaywallAssignments = json["restorePaywallAssignments"] as? Boolean
    restorePaywallAssignments?.let {
        return IdentityOptions(restorePaywallAssignments = it)
    } ?: run {
        return IdentityOptions()
    }
}