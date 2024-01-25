/// A wrapper around a store product.
class StoreProduct {
  // The product identifier
  final String productIdentifier;

  // The localized price.
  final String localizedPrice;

  // The localized subscription period.
  final String localizedSubscriptionPeriod;

  // The subscription period unit, e.g., week.
  final String period;

  // The number of weeks in the product's subscription period.
  final int periodWeeks;

  // The string value of the number of weeks in the product's subscription period.
  final String periodWeeksString;

  // The number of months in the product's subscription period.
  final int periodMonths;

  // The string value of the number of months in the product's subscription period.
  final String periodMonthsString;

  // The number of years in the product's subscription period.
  final int periodYears;

  // The string value of the number of years in the product's subscription period.
  final String periodYearsString;

  // The number of days in the product's subscription period.
  final int periodDays;

  // The string value of the number of days in the product's subscription period.
  final String periodDaysString;

  // The product's localized daily price.
  final String dailyPrice;

  // The product's localized weekly price.
  final String weeklyPrice;

  // The product's localized monthly price.
  final String monthlyPrice;

  // The product's localized yearly price.
  final String yearlyPrice;

  // A boolean indicating whether the product has an introductory price.
  final bool hasFreeTrial;

  // The product's trial period end date.
  final DateTime? trialPeriodEndDate;

  // The product's trial period end date formatted using `DateFormatter.Style.medium`
  final String trialPeriodEndDateString;

  // The product's introductory price duration in days.
  final String localizedTrialPeriodPrice;

  // The product's introductory price duration in days.
  final double trialPeriodPrice;

  // The product's introductory price duration in days.
  final int trialPeriodDays;

  // The product's string value of the introductory price duration in days.
  final String trialPeriodDaysString;

  // The product's introductory price duration in weeks.
  final int trialPeriodWeeks;

  // The product's string value of the introductory price duration in weeks.
  final String trialPeriodWeeksString;

  // The product's introductory price duration in months.
  final int trialPeriodMonths;

  // The product's string value of the introductory price duration in months.
  final String trialPeriodMonthsString;

  // The product's introductory price duration in years.
  final int trialPeriodYears;

  // The product's string value of the introductory price duration in years.
  final String trialPeriodYearsString;

  // The product's introductory price duration in days, e.g., 7-day.
  final String trialPeriodText;

  // The product's locale.
  final String locale;

  // The language code of the product's locale.
  final String? languageCode;

  // The currency code of the product's locale.
  final String? currencyCode;

  // The currency symbol of the product's locale.
  final String? currencySymbol;

  // A boolean that indicates whether the product is family shareable.
  final bool isFamilyShareable;

  // The region code of the product's price locale.
  final String? regionCode;

  // The price of the product in the local currency.
  final double price;

  // Constructor
  StoreProduct({
    required this.productIdentifier,
    required this.localizedPrice,
    required this.localizedSubscriptionPeriod,
    required this.period,
    required this.periodWeeks,
    required this.periodWeeksString,
    required this.periodMonths,
    required this.periodMonthsString,
    required this.periodYears,
    required this.periodYearsString,
    required this.periodDays,
    required this.periodDaysString,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.hasFreeTrial,
    this.trialPeriodEndDate,
    required this.trialPeriodEndDateString,
    required this.localizedTrialPeriodPrice,
    required this.trialPeriodPrice,
    required this.trialPeriodDays,
    required this.trialPeriodDaysString,
    required this.trialPeriodWeeks,
    required this.trialPeriodWeeksString,
    required this.trialPeriodMonths,
    required this.trialPeriodMonthsString,
    required this.trialPeriodYears,
    required this.trialPeriodYearsString,
    required this.trialPeriodText,
    required this.locale,
    this.languageCode,
    this.currencyCode,
    this.currencySymbol,
    required this.isFamilyShareable,
    this.regionCode,
    required this.price,
  });

  factory StoreProduct.fromJson(Map<dynamic, dynamic> json) {
    return StoreProduct(
      productIdentifier: json['productIdentifier'] as String,
      localizedPrice: json['localizedPrice'] as String,
      localizedSubscriptionPeriod: json['localizedSubscriptionPeriod'] as String,
      period: json['period'] as String,
      periodWeeks: json['periodWeeks'] as int,
      periodWeeksString: json['periodWeeksString'] as String,
      periodMonths: json['periodMonths'] as int,
      periodMonthsString: json['periodMonthsString'] as String,
      periodYears: json['periodYears'] as int,
      periodYearsString: json['periodYearsString'] as String,
      periodDays: json['periodDays'] as int,
      periodDaysString: json['periodDaysString'] as String,
      dailyPrice: json['dailyPrice'] as String,
      weeklyPrice: json['weeklyPrice'] as String,
      monthlyPrice: json['monthlyPrice'] as String,
      yearlyPrice: json['yearlyPrice'] as String,
      hasFreeTrial: json['hasFreeTrial'] as bool,
      trialPeriodEndDateString: json['trialPeriodEndDateString'] as String,
      localizedTrialPeriodPrice: json['localizedTrialPeriodPrice'] as String,
      trialPeriodPrice: json['trialPeriodPrice'] as double,
      trialPeriodDays: json['trialPeriodDays'] as int,
      trialPeriodDaysString: json['trialPeriodDaysString'] as String,
      trialPeriodWeeks: json['trialPeriodWeeks'] as int,
      trialPeriodWeeksString: json['trialPeriodWeeksString'] as String,
      trialPeriodMonths: json['trialPeriodMonths'] as int,
      trialPeriodMonthsString: json['trialPeriodMonthsString'] as String,
      trialPeriodYears: json['trialPeriodYears'] as int,
      trialPeriodYearsString: json['trialPeriodYearsString'] as String,
      trialPeriodText: json['trialPeriodText'] as String,
      locale: json['locale'] as String,
      languageCode: json['languageCode'] as String?,
      currencyCode: json['currencyCode'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
      isFamilyShareable: json['isFamilyShareable'] as bool? ?? false,
      regionCode: json['regionCode'] as String?,
      price: json['price'] as double,
      trialPeriodEndDate: _parseDate(json['trialPeriodEndDate']),
    );
  }

  // Helper method to parse the trialPeriodEndDate
  static DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    return DateTime.tryParse(dateString);
  }
}
