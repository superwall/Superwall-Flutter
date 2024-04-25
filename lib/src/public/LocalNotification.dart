/// A local notification.
class LocalNotification {
  /// The type of the notification.
  final LocalNotificationType type;

  /// The title text of the notification.
  final String title;

  /// The subtitle text of the notification.
  final String? subtitle;

  /// The body text of the notification.
  final String body;

  /// The delay to the notification in milliseconds.
  final double delay;

  LocalNotification({
    required this.type,
    required this.title,
    this.subtitle,
    required this.body,
    required this.delay,
  });

  factory LocalNotification.fromJson(Map<dynamic, dynamic> json) {
    return LocalNotification(
      type: LocalNotificationTypeExtension.fromJson(json['type']),
      title: json['title'],
      subtitle: json['subtitle'],
      body: json['body'],
      delay: json['delay'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'delay': delay,
    };
  }
}

enum LocalNotificationType {
  trialStarted,
}

// Extension on LocalNotificationType for explicit serialization and deserialization
extension LocalNotificationTypeExtension on LocalNotificationType {
  // Converts the enum to a JSON-valid string
  String toJson() {
    switch (this) {
      case LocalNotificationType.trialStarted:
        return 'trialStarted';
      default:
        throw ArgumentError('Invalid LocalNotificationType value');
    }
  }

  // Parses a JSON string to get the corresponding LocalNotificationType enum value
  static LocalNotificationType fromJson(String json) {
    switch (json) {
      case 'trialStarted':
        return LocalNotificationType.trialStarted;
      default:
        throw ArgumentError('Invalid LocalNotificationType value: $json');
    }
  }
}