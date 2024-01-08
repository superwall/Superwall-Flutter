/// A survey attached to a paywall.
class Survey {
  // TODO
  // /// The id of the survey.
  // final String id;
  //
  // /// The assigned key for the survey.
  // ///
  // /// A user will only see one survey per assignment key.
  // final String assignmentKey;
  //
  // /// The title of the survey's alert controller.
  // final String title;
  //
  // /// The message of the survey's alert controller.
  // final String message;
  //
  // /// The options to display in the alert controller.
  // final List<SurveyOption> options;
  //
  // /// An enum whose cases indicate when the survey should show.
  // final SurveyShowCondition presentationCondition;
  //
  // /// The probability that the survey will present to the user.
  // final double presentationProbability;
  //
  // /// Whether the "Other" option should appear to allow a user to provide a custom
  // /// response.
  // final bool includeOtherOption;
  //
  // /// Whether a close button should appear to allow users to skip the survey.
  // final bool includeCloseOption;
}

/// An option to display in a paywall survey.
class SurveyOption {
  // TODO
  // /// The id of the survey option.
  // final String id;
  //
  // /// The title of the survey option.
  // final String title;
  //
  // SurveyOption({
  //   required this.id,
  //   required this.title,
  // });
}

/// An enum whose cases indicate when a survey should show.
enum SurveyShowCondition {
  onManualClose,
  onPurchase,
}