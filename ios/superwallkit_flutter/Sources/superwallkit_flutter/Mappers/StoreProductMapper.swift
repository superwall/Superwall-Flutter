import Foundation
import SuperwallKit

extension StoreProduct {
  func pigeonify() -> PStoreProduct {

    let familyShareable: Bool
    if #available(iOS 14.0, *) {
      familyShareable = isFamilyShareable
    } else {
      familyShareable = false
    }

    #if SWIFT_PACKAGE
    let customTransactionId = self.customTransactionId
    #else
    // CocoaPods builds use SuperwallKit 4.18.3, which doesn't expose this.
    let customTransactionId: String? = nil
    #endif

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
      isFamilyShareable: familyShareable,
      regionCode: regionCode,
      price: Double(truncating: price as NSNumber),
      subscriptionPeriod: subscriptionPeriod?.pigeonify(),
      customTransactionId: customTransactionId,
      introductoryDiscount: introductoryDiscount?.pigeonify(),
      discounts: discounts.map { $0.pigeonify() },
      billingPlanType: billingPlanType?.pigeonify(),
      isBillingPlanAvailable: isBillingPlanAvailable
    )
  }
}

extension StoreProductDiscount {
  func pigeonify() -> PStoreProductDiscount {
    let pPaymentMode: PStoreProductDiscountPaymentMode
    switch paymentMode {
    case .payAsYouGo:
      pPaymentMode = .payAsYouGo
    case .payUpFront:
      pPaymentMode = .payUpFront
    case .freeTrial:
      pPaymentMode = .freeTrial
    @unknown default:
      pPaymentMode = .payAsYouGo
    }

    let pType: PStoreProductDiscountType
    switch self.type {
    case .introductory:
      pType = .introductory
    case .promotional:
      pType = .promotional
    @unknown default:
      pType = .introductory
    }

    return PStoreProductDiscount(
      offerIdentifier: offerIdentifier,
      currencyCode: currencyCode,
      price: Double(truncating: price as NSNumber),
      localizedPriceString: localizedPriceString,
      paymentMode: pPaymentMode,
      subscriptionPeriod: subscriptionPeriod.pigeonify(),
      numberOfPeriods: Int64(numberOfPeriods),
      type: pType
    )
  }
}

extension AppStoreProduct.BillingPlanType {
  func pigeonify() -> PBillingPlanType {
    switch self {
    case .upFront:
      return .upFront
    case .monthly:
      return .monthly
    @unknown default:
      return .upFront
    }
  }
}

extension SubscriptionPeriod {
  func pigeonify() -> PSubscriptionPeriod {
    let pUnit: PSubscriptionPeriodUnit
    switch unit {
    case .day:
      pUnit = .day
    case .week:
      pUnit = .week
    case .month:
      pUnit = .month
    case .year:
      pUnit = .year
    }

    return PSubscriptionPeriod(value: Int64(value), unit: pUnit)
  }
}

// Entitlement.pigeonify() is now defined in CustomerInfo+Pigeonify.swift
