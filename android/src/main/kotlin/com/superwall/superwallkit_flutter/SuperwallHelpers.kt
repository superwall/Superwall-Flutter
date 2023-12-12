package com.superwall.superwallkit_flutter

import com.superwall.sdk.delegate.SubscriptionStatus

// Extension to convert an integer to a SubscriptionStatus
fun SubscriptionStatus.Companion.fromRawValue(value: Int) = when(value) {
    0 -> SubscriptionStatus.ACTIVE
    1 -> SubscriptionStatus.INACTIVE
    2 -> SubscriptionStatus.UNKNOWN
    else -> throw IllegalArgumentException("Invalid integer for SubscriptionStatus")
}

// Extension to get the integer value of a SubscriptionStatus instance
val SubscriptionStatus.rawValue: Int
    get() = when(this) {
        SubscriptionStatus.ACTIVE -> 0
        SubscriptionStatus.INACTIVE -> 1
        SubscriptionStatus.UNKNOWN -> 2
    }