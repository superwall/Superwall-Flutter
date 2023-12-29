import Flutter
import SuperwallKit

extension StoreProduct {
  func toJson() -> [String: Any] {
    var dict = [String: Any]()
    dict["productIdentifier"] = productIdentifier
    dict["localizedPrice"] = localizedPrice
    dict["localizedSubscriptionPeriod"] = localizedSubscriptionPeriod
    dict["period"] = period
    dict["periodWeeks"] = periodWeeks
    dict["periodWeeksString"] = periodWeeksString
    dict["periodMonths"] = periodMonths
    dict["periodMonthsString"] = periodMonthsString
    dict["periodYears"] = periodYears
    dict["periodYearsString"] = periodYearsString
    dict["periodDays"] = periodDays
    dict["periodDaysString"] = periodDaysString
    dict["dailyPrice"] = dailyPrice
    dict["weeklyPrice"] = weeklyPrice
    dict["monthlyPrice"] = monthlyPrice
    dict["yearlyPrice"] = yearlyPrice
    dict["hasFreeTrial"] = hasFreeTrial
    dict["trialPeriodEndDate"] = trialPeriodEndDate?.timeIntervalSince1970
    dict["trialPeriodEndDateString"] = trialPeriodEndDateString
    dict["localizedTrialPeriodPrice"] = localizedTrialPeriodPrice
    dict["trialPeriodPrice"] = trialPeriodPrice
    dict["trialPeriodDays"] = trialPeriodDays
    dict["trialPeriodDaysString"] = trialPeriodDaysString
    dict["trialPeriodWeeks"] = trialPeriodWeeks
    dict["trialPeriodWeeksString"] = trialPeriodWeeksString
    dict["trialPeriodMonths"] = trialPeriodMonths
    dict["trialPeriodMonthsString"] = trialPeriodMonthsString
    dict["trialPeriodYears"] = trialPeriodYears
    dict["trialPeriodYearsString"] = trialPeriodYearsString
    dict["trialPeriodText"] = trialPeriodText
    dict["locale"] = locale
    dict["languageCode"] = languageCode
    dict["currencyCode"] = currencyCode
    dict["currencySymbol"] = currencySymbol
    dict["isFamilyShareable"] = isFamilyShareable
    dict["regionCode"] = regionCode
    dict["price"] = price
    return dict
  }
}
