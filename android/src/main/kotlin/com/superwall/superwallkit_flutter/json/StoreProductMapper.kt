import com.superwall.sdk.analytics.superwall.TransactionProduct
import com.superwall.sdk.store.abstractions.product.StoreProductType
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale

fun StoreProductType.pigeonify(): PStoreProduct {
    val trialPeriodEndDateStr =
        trialPeriodEndDate?.let {
            val instant = it.toInstant()
            instant.atZone(ZoneId.systemDefault()).format(DateTimeFormatter.ISO_DATE_TIME.withLocale(Locale.getDefault()))
        }

    return PStoreProduct(
        entitlements = emptyList(),
        productIdentifier = productIdentifier,
        subscriptionGroupIdentifier = "",
        attributes = attributes,
        localizedPrice = localizedPrice,
        localizedSubscriptionPeriod = localizedSubscriptionPeriod,
        period = period,
        periodly = periodly,
        periodWeeks = periodWeeks.toLong(),
        periodWeeksString = periodWeeksString,
        periodMonths = periodMonths.toLong(),
        periodMonthsString = periodMonthsString,
        periodYears = periodYears.toLong(),
        periodYearsString = periodYearsString,
        periodDays = periodDays.toLong(),
        periodDaysString = periodDaysString,
        dailyPrice = dailyPrice,
        weeklyPrice = weeklyPrice,
        monthlyPrice = monthlyPrice,
        yearlyPrice = yearlyPrice,
        hasFreeTrial = hasFreeTrial,
        trialPeriodEndDate = trialPeriodEndDateStr,
        trialPeriodEndDateString = trialPeriodEndDateString,
        localizedTrialPeriodPrice = localizedTrialPeriodPrice,
        trialPeriodPrice = trialPeriodPrice.toDouble(),
        trialPeriodDays = trialPeriodDays.toLong(),
        trialPeriodDaysString = trialPeriodDaysString,
        trialPeriodWeeks = trialPeriodWeeks.toLong(),
        trialPeriodWeeksString = trialPeriodWeeksString,
        trialPeriodMonths = trialPeriodMonths.toLong(),
        trialPeriodMonthsString = trialPeriodMonthsString,
        trialPeriodYears = trialPeriodYears.toLong(),
        trialPeriodYearsString = trialPeriodYearsString,
        trialPeriodText = trialPeriodText,
        locale = locale,
        languageCode = languageCode,
        currencySymbol = currencySymbol,
        currencyCode = currencyCode,
        isFamilyShareable = false,
        regionCode = regionCode,
        price = price.toDouble(),
    )
}

fun com.superwall.sdk.analytics.superwall.TransactionProduct.pigeonify(): PStoreProduct {
    val trialPeriodEndDateStr =
        this.trialPeriod?.endAt?.let {
            val instant = it.toInstant()
            instant.atZone(ZoneId.systemDefault()).format(DateTimeFormatter.ISO_DATE_TIME.withLocale(Locale.getDefault()))
        }

    return PStoreProduct(
        entitlements = emptyList(),
        productIdentifier = this.id,
        subscriptionGroupIdentifier = "",
        attributes = emptyMap<String, String>(),
        localizedPrice = this.price.localized,
        localizedSubscriptionPeriod = this.period?.alt ?: "",
        period =
            this.period
                ?.unit
                ?.name
                ?.lowercase(Locale.getDefault()) ?: "",
        periodly = this.period?.ly ?: "",
        periodWeeks = this.period?.weeks?.toLong() ?: 0L,
        periodWeeksString =
            this.period
                ?.weeks
                ?.takeIf { it > 0 }
                ?.let { "$it weeks" } ?: "",
        periodMonths = this.period?.months?.toLong() ?: 0L,
        periodMonthsString =
            this.period
                ?.months
                ?.takeIf { it > 0 }
                ?.let { "$it months" } ?: "",
        periodYears = this.period?.years?.toLong() ?: 0L,
        periodYearsString =
            this.period
                ?.years
                ?.takeIf { it > 0 }
                ?.let { "$it years" } ?: "",
        periodDays = this.period?.days?.toLong() ?: 0L,
        periodDaysString =
            this.period
                ?.days
                ?.takeIf { it > 0 }
                ?.let { "$it days" } ?: "",
        dailyPrice = this.price.daily,
        weeklyPrice = this.price.weekly,
        monthlyPrice = this.price.monthly,
        yearlyPrice = this.price.yearly,
        hasFreeTrial = this.trialPeriod != null,
        trialPeriodEndDate = trialPeriodEndDateStr,
        trialPeriodEndDateString = trialPeriodEndDateStr ?: "",
        localizedTrialPeriodPrice = "",
        trialPeriodPrice = 0.0,
        trialPeriodDays = this.trialPeriod?.days?.toLong() ?: 0L,
        trialPeriodDaysString =
            this.trialPeriod
                ?.days
                ?.takeIf { it > 0 }
                ?.let { "$it days" } ?: "",
        trialPeriodWeeks = this.trialPeriod?.weeks?.toLong() ?: 0L,
        trialPeriodWeeksString =
            this.trialPeriod
                ?.weeks
                ?.takeIf { it > 0 }
                ?.let { "$it weeks" } ?: "",
        trialPeriodMonths = this.trialPeriod?.months?.toLong() ?: 0L,
        trialPeriodMonthsString =
            this.trialPeriod
                ?.months
                ?.takeIf { it > 0 }
                ?.let { "$it months" } ?: "",
        trialPeriodYears = this.trialPeriod?.years?.toLong() ?: 0L,
        trialPeriodYearsString =
            this.trialPeriod
                ?.years
                ?.takeIf { it > 0 }
                ?.let { "$it years" } ?: "",
        trialPeriodText = this.trialPeriod?.text ?: "",
        locale = this.locale,
        languageCode = this.languageCode,
        currencySymbol = this.currency.symbol,
        currencyCode = this.currency.code,
        isFamilyShareable = false,
        regionCode = null,
        price = this.price.raw.toDouble(),
    )
}
