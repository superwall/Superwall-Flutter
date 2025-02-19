package com.superwall.superwallkit_flutter.json

import com.superwall.sdk.models.product.ProductItem
import com.superwall.superwallkit_flutter.json.toJson

fun ProductItem.toJson(): Map<String, Any> {
    return mapOf(
        "type" to this.name,
        "entitlements" to this.entitlements.map { it.toJson() }
    )
}