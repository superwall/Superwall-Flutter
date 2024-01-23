/// A survey attached to a paywall.
class Survey {
  /// The id of the survey.
  final String id;

  /// The assigned key for the survey.
  ///
  /// A user will only see one survey per assignment key.
  final String assignmentKey;

  /// The title of the survey's alert controller.
  final String title;

  /// The message of the survey's alert controller.
  final String message;

  /// The options to display in the alert controller.
  final List<SurveyOption> options;

  /// An enum whose cases indicate when the survey should show.
  final SurveyShowCondition presentationCondition;

  /// The probability that the survey will present to the user.
  final double presentationProbability;

  /// Whether the "Other" option should appear to allow a user to provide a custom
  /// response.
  final bool includeOtherOption;

  /// Whether a close button should appear to allow users to skip the survey.
  final bool includeCloseOption;

  Survey({
    required this.id,
    required this.assignmentKey,
    required this.title,
    required this.message,
    required this.options,
    required this.presentationCondition,
    required this.presentationProbability,
    required this.includeOtherOption,
    required this.includeCloseOption,
  });

  // Factory constructor to create a Survey instance from a JSON map
  factory Survey.fromJson(Map<dynamic, dynamic> json) {
    return Survey(
      id: json['id'],
      assignmentKey: json['assignmentKey'],
      title: json['title'],
      message: json['message'],
      options: (json['options'] as List)
          .map((optionJson) => SurveyOption.fromJson(optionJson))
          .toList(),
      presentationCondition: SurveyShowConditionExtension.fromJson(json['presentationCondition']),
      presentationProbability: json['presentationProbability'].toDouble(),
      includeOtherOption: json['includeOtherOption'],
      includeCloseOption: json['includeCloseOption'],
    );
  }
}

/// An option to display in a paywall survey.
class SurveyOption {
  /// The id of the survey option.
  final String id;

  /// The title of the survey option.
  final String title;

  SurveyOption({
    required this.id,
    required this.title,
  });

  // Factory constructor to create a SurveyOption instance from a JSON map
  factory SurveyOption.fromJson(Map<String, dynamic> json) {
    return SurveyOption(
      id: json['id'],
      title: json['title'],
    );
  }
}

/// An enum whose cases indicate when a survey should show.
enum SurveyShowCondition {
  onManualClose,
  onPurchase,
}

// Extension on SurveyShowCondition for explicit serialization and deserialization
extension SurveyShowConditionExtension on SurveyShowCondition {
  // Converts the enum to a JSON-valid string
  String toJson() {
    switch (this) {
      case SurveyShowCondition.onManualClose:
        return 'onManualClose';
      case SurveyShowCondition.onPurchase:
        return 'onPurchase';
      default:
        throw ArgumentError('Invalid SurveyShowCondition value');
    }
  }

  // Parses a JSON string to get the corresponding SurveyShowCondition enum value
  static SurveyShowCondition fromJson(String json) {
    switch (json) {
      case 'onManualClose':
        return SurveyShowCondition.onManualClose;
      case 'onPurchase':
        return SurveyShowCondition.onPurchase;
      default:
        throw ArgumentError('Invalid SurveyShowCondition value: $json');
    }
  }
}
