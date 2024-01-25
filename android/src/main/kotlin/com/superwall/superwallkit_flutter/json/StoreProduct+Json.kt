import com.superwall.sdk.store.abstractions.product.StoreProduct
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale

fun StoreProduct.toJson(): Map<String, Any?> {
    val dateFormatter = DateTimeFormatter.ISO_DATE_TIME.withLocale(Locale.getDefault())

    val json = mutableMapOf<String, Any?>(
        "productIdentifier" to productIdentifier,
        "localizedPrice" to localizedPrice,
        "localizedSubscriptionPeriod" to localizedSubscriptionPeriod,
        "period" to period,
        "periodly" to periodly,
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
        "trialPeriodEndDateString" to trialPeriodEndDateString,
        "localizedTrialPeriodPrice" to localizedTrialPeriodPrice,
        "trialPeriodPrice" to trialPeriodPrice.toDouble(),
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
        "price" to price.toDouble()
    )

    trialPeriodEndDate?.let {
        val instant = it.toInstant()
        json["trialPeriodEndDate"] = instant.atZone(ZoneId.systemDefault()).format(dateFormatter)
    } ?: run {
        json["trialPeriodEndDate"] = null
    }

    return json
}