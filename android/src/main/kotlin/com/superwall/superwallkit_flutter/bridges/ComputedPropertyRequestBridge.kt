package com.superwall.superwallkit_flutter.bridges

import ComputedPropertyRequest

fun ComputedPropertyRequest.toJson(): Map<String, Any?> {
    return mapOf(
        "type" to type.toJson(),
        "eventName" to eventName
    )
}

fun ComputedPropertyRequest.ComputedPropertyRequestType.toJson(): String {
    return when (this) {
        ComputedPropertyRequest.ComputedPropertyRequestType.MINUTES_SINCE -> "minutesSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.HOURS_SINCE -> "hoursSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.DAYS_SINCE -> "daysSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.MONTHS_SINCE -> "monthsSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.YEARS_SINCE -> "yearsSince"
    }
}