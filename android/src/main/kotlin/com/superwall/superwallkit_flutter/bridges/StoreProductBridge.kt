package com.superwall.superwallkit_flutter.bridges

import com.superwall.sdk.store.abstractions.product.StoreProduct

fun StoreProduct.toJson(): Map<String, Any?> {
    return mapOf(
        "productIdentifier" to productIdentifier,
        "localizedPrice" to localizedPrice,
        "localizedSubscriptionPeriod" to localizedSubscriptionPeriod,
        "period" to period,
        "periodWeeks" to periodWeeks,
        "periodWeeksString" to periodWeeksString,
        "periodMonths" to periodMonths,
        "periodMonthsString" to periodMonthsString,
        "periodYears" to periodYears,
        "periodYearsString" to periodYearsString,
        "periodDays" to periodDays,
        "periodDaysString" to periodDaysString,
        "dailyPrice" to dailyPrice,
        "weeklyPrice" to weeklyPrice,
        "monthlyPrice" to monthlyPrice,
        "yearlyPrice" to yearlyPrice,
        "hasFreeTrial" to hasFreeTrial,
        "trialPeriodEndDate" to trialPeriodEndDate?.time,
        "trialPeriodEndDateString" to trialPeriodEndDateString,
        "localizedTrialPeriodPrice" to localizedTrialPeriodPrice,
        "trialPeriodDays" to trialPeriodDays,
        "trialPeriodDaysString" to trialPeriodDaysString,
        "trialPeriodWeeks" to trialPeriodWeeks,
        "trialPeriodWeeksString" to trialPeriodWeeksString,
        "trialPeriodMonths" to trialPeriodMonths,
        "trialPeriodMonthsString" to trialPeriodMonthsString,
        "trialPeriodYears" to trialPeriodYears,
        "trialPeriodYearsString" to trialPeriodYearsString,
        "trialPeriodText" to trialPeriodText,
        "locale" to locale,
        "languageCode" to languageCode,
        "currencyCode" to currencyCode,
        "currencySymbol" to currencySymbol,
        "regionCode" to regionCode,
        "price" to price
    )
}
