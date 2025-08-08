package com.superwall.superwallkit_flutter.bridges
import com.superwall.sdk.models.config.ComputedPropertyRequest

fun ComputedPropertyRequest.toJson(): Map<String, Any> =
    mapOf(
        "type" to this.type.toJson(),
        "placementName" to this.eventName,
    )

fun ComputedPropertyRequest.ComputedPropertyRequestType.toJson(): String =
    when (this) {
        ComputedPropertyRequest.ComputedPropertyRequestType.MINUTES_SINCE -> "minutesSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.HOURS_SINCE -> "hoursSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.DAYS_SINCE -> "daysSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.MONTHS_SINCE -> "monthsSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.YEARS_SINCE -> "yearsSince"
        ComputedPropertyRequest.ComputedPropertyRequestType.PLACEMENTS_IN_DAY -> "placementsInDay"
        ComputedPropertyRequest.ComputedPropertyRequestType.PLACEMENTS_IN_HOUR -> "placementsInHour"
        ComputedPropertyRequest.ComputedPropertyRequestType.PLACEMENTS_IN_WEEK -> "placementsInWeek"
        ComputedPropertyRequest.ComputedPropertyRequestType.PLACEMENTS_IN_MONTH -> "placementsInMonth"
        ComputedPropertyRequest.ComputedPropertyRequestType.PLACEMENTS_SINCE_INSTALL -> "placementsSinceInstall"
    }
