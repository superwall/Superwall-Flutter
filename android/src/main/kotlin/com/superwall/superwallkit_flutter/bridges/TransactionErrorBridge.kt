package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.store.transactions.TransactionError

fun TransactionError.toJson(): Map<String, Any?> {
    return when (this) {
        is TransactionError.Pending -> {
            mapOf("type" to "pending", "reason" to message)
        }
        is TransactionError.Failure -> {
            mapOf("type" to "failure", "message" to message, "product" to product.toJson())
        }
    }
}

