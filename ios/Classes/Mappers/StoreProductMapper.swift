import Foundation
import SuperwallKit

extension StoreProduct {
  func pigeonify() -> PStoreProduct {
    return PStoreProduct(
      entitlements: entitlements.map { $0.pigeonify() },
      productIdentifier: productIdentifier,
      subscriptionGroupIdentifier: subscriptionGroupIdentifier,
      attributes: attributes,
      localizedPrice: localizedPrice,
      localizedSubscriptionPeriod: localizedSubscriptionPeriod,
      period: period,
      periodly: periodly,
      periodWeeks: Int64(periodWeeks),
      periodWeeksString: periodWeeksString,
      periodMonths: Int64(periodMonths),
      periodMonthsString: periodMonthsString,
      periodYears: Int64(periodYears),
      periodYearsString: periodYearsString,
      periodDays: Int64(periodDays),
      periodDaysString: periodDaysString,
      dailyPrice: dailyPrice,
      weeklyPrice: weeklyPrice,
      monthlyPrice: monthlyPrice,
      yearlyPrice: yearlyPrice,
      hasFreeTrial: hasFreeTrial,
      trialPeriodEndDate: trialPeriodEndDate?.isoString,
      trialPeriodEndDateString: trialPeriodEndDateString,
      localizedTrialPeriodPrice: localizedTrialPeriodPrice,
      trialPeriodPrice: Double(truncating: trialPeriodPrice as NSNumber),
      trialPeriodDays: Int64(trialPeriodDays),
      trialPeriodDaysString: trialPeriodDaysString,
      trialPeriodWeeks: Int64(trialPeriodWeeks),
      trialPeriodWeeksString: trialPeriodWeeksString,
      trialPeriodMonths: Int64(trialPeriodMonths),
      trialPeriodMonthsString: trialPeriodMonthsString,
      trialPeriodYears: Int64(trialPeriodYears),
      trialPeriodYearsString: trialPeriodYearsString,
      trialPeriodText: trialPeriodText,
      locale: locale,
      languageCode: languageCode,
      currencySymbol: currencySymbol,
      currencyCode: currencyCode,
      isFamilyShareable: isFamilyShareable,
      regionCode: regionCode,
      price: Double(truncating: price as NSNumber),
      
    )
  }
}

extension Entitlement {
  func pigeonify() -> PEntitlement {
    return PEntitlement(id: id)
  }
}
