import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

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

  /// Create a LocalNotification from a PLocalNotification
  static LocalNotification fromPigeon(PLocalNotification notification) {
    return LocalNotification(
      type: LocalNotificationTypeExtension.fromPigeon(notification.type),
      title: notification.title,
      subtitle: notification.subtitle,
      body: notification.body,
      delay: notification.delay.toDouble(),
    );
  }

  /// Convert this LocalNotification to a PLocalNotification
  PLocalNotification toPigeon() {
    return PLocalNotification(
      id: "", // Default id, this might need adjustment
      type: LocalNotificationTypeExtension(type).toPigeon(),
      title: title,
      subtitle: subtitle,
      body: body,
      delay: delay.toInt(),
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
  unsupported,
}

// Extension on LocalNotificationType for explicit serialization and deserialization
extension LocalNotificationTypeExtension on LocalNotificationType {
  // Converts the enum to a JSON-valid string
  String toJson() {
    switch (this) {
      case LocalNotificationType.trialStarted:
        return 'trialStarted';
      case LocalNotificationType.unsupported:
        return 'unsupported';
      default:
        throw ArgumentError('Invalid LocalNotificationType value');
    }
  }

  // Parses a JSON string to get the corresponding LocalNotificationType enum value
  static LocalNotificationType fromJson(String json) {
    switch (json) {
      case 'trialStarted':
        return LocalNotificationType.trialStarted;
      case 'unsupported':
        return LocalNotificationType.unsupported;
      default:
        throw ArgumentError('Invalid LocalNotificationType value: $json');
    }
  }

  /// Convert this LocalNotificationType to PLocalNotificationType
  PLocalNotificationType toPigeon() {
    switch (this) {
      case LocalNotificationType.trialStarted:
        return PLocalNotificationType.trialStarted;
      case LocalNotificationType.unsupported:
        return PLocalNotificationType.unsupported;
      default:
        throw ArgumentError('Invalid LocalNotificationType value');
    }
  }

  /// Convert a PLocalNotificationType to a LocalNotificationType
  static LocalNotificationType fromPigeon(PLocalNotificationType type) {
    switch (type) {
      case PLocalNotificationType.trialStarted:
        return LocalNotificationType.trialStarted;
      case PLocalNotificationType.unsupported:
        return LocalNotificationType.unsupported;
      default:
        throw ArgumentError('Invalid PLocalNotificationType value');
    }
  }
}
