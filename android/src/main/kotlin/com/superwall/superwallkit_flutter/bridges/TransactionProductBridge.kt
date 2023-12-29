package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.analytics.superwall.TransactionProduct

fun TransactionProduct.toJson(): Map<String, Any?> {
    return mapOf("id" to id)
}
