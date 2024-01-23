/// A request to compute a device property associated with an event at runtime.
class ComputedPropertyRequest {
  /// The type of device property to compute.
  final ComputedPropertyRequestType type;

  /// The name of the event used to compute the device property.
  final String eventName;

  ComputedPropertyRequest({
    required this.type,
    required this.eventName,
  });

  // Factory constructor to create a ComputedPropertyRequest instance from a JSON map
  factory ComputedPropertyRequest.fromJson(Map<dynamic, dynamic> json) {
    return ComputedPropertyRequest(
      type: ComputedPropertyRequestTypeExtension.fromJson(json['type']),
      eventName: json['eventName'],
    );
  }
}

enum ComputedPropertyRequestType {
  minutesSince,
  hoursSince,
  daysSince,
  monthsSince,
  yearsSince,
}

// Extension on ComputedPropertyRequestType for explicit serialization and deserialization
extension ComputedPropertyRequestTypeExtension on ComputedPropertyRequestType {
  // Converts the enum to a JSON-valid string
  String toJson() {
    switch (this) {
      case ComputedPropertyRequestType.minutesSince:
        return 'minutesSince';
      case ComputedPropertyRequestType.hoursSince:
        return 'hoursSince';
      case ComputedPropertyRequestType.daysSince:
        return 'daysSince';
      case ComputedPropertyRequestType.monthsSince:
        return 'monthsSince';
      case ComputedPropertyRequestType.yearsSince:
        return 'yearsSince';
      default:
        throw ArgumentError('Invalid ComputedPropertyRequestType value');
    }
  }

  // Parses a JSON string to get the corresponding ComputedPropertyRequestType enum value
  static ComputedPropertyRequestType fromJson(String json) {
    switch (json) {
      case 'minutesSince':
        return ComputedPropertyRequestType.minutesSince;
      case 'hoursSince':
        return ComputedPropertyRequestType.hoursSince;
      case 'daysSince':
        return ComputedPropertyRequestType.daysSince;
      case 'monthsSince':
        return ComputedPropertyRequestType.monthsSince;
      case 'yearsSince':
        return ComputedPropertyRequestType.yearsSince;
      default:
        throw ArgumentError('Invalid ComputedPropertyRequestType value: $json');
    }
  }
}
