import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

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
      presentationCondition:
          SurveyShowConditionExtension.fromJson(json['presentationCondition']),
      presentationProbability: json['presentationProbability'].toDouble(),
      includeOtherOption: json['includeOtherOption'],
      includeCloseOption: json['includeCloseOption'],
    );
  }

  /// Create a Survey from a PSurvey
  static Survey fromPigeon(PSurvey survey) {
    return Survey(
      id: survey.id,
      assignmentKey: survey.assignmentKey,
      title: survey.title,
      message: survey.message,
      options: survey.options.map((o) => SurveyOption.fromPigeon(o)).toList(),
      presentationCondition:
          SurveyShowConditionExtension.fromPigeon(survey.presentationCondition),
      presentationProbability: survey.presentationProbability,
      includeOtherOption: survey.includeOtherOption,
      includeCloseOption: survey.includeCloseOption,
    );
  }

  /// Convert this Survey to a PSurvey
  PSurvey toPigeon() {
    return PSurvey(
      id: id,
      assignmentKey: assignmentKey,
      title: title,
      message: message,
      options: options.map((o) => o.toPigeon()).toList(),
      presentationCondition:
          SurveyShowConditionExtension(presentationCondition).toPigeon(),
      presentationProbability: presentationProbability,
      includeOtherOption: includeOtherOption,
      includeCloseOption: includeCloseOption,
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
  factory SurveyOption.fromJson(Map<dynamic, dynamic> json) {
    return SurveyOption(
      id: json['id'],
      title: json['title'],
    );
  }

  /// Create a SurveyOption from a PSurveyOption
  static SurveyOption fromPigeon(PSurveyOption option) {
    return SurveyOption(
      id: option.id ?? '',
      title: option.text ?? '',
    );
  }

  /// Convert this SurveyOption to a PSurveyOption
  PSurveyOption toPigeon() {
    return PSurveyOption(
      id: id,
      text: title,
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

  /// Convert this SurveyShowCondition to PSurveyShowCondition
  PSurveyShowCondition toPigeon() {
    switch (this) {
      case SurveyShowCondition.onManualClose:
        return PSurveyShowCondition.onManualClose;
      case SurveyShowCondition.onPurchase:
        return PSurveyShowCondition.onPurchase;
      default:
        throw ArgumentError('Invalid SurveyShowCondition value');
    }
  }

  /// Convert a PSurveyShowCondition to a SurveyShowCondition
  static SurveyShowCondition fromPigeon(PSurveyShowCondition condition) {
    switch (condition) {
      case PSurveyShowCondition.onManualClose:
        return SurveyShowCondition.onManualClose;
      case PSurveyShowCondition.onPurchase:
        return SurveyShowCondition.onPurchase;
      default:
        throw ArgumentError('Invalid PSurveyShowCondition value');
    }
  }
}
