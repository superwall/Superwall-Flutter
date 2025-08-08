import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// A request to compute a device property associated with an placement at runtime.
class ComputedPropertyRequest {
  /// The type of device property to compute.
  final ComputedPropertyRequestType type;

  /// The name of the event used to compute the device property.
  final String placememtName;

  ComputedPropertyRequest({
    required this.type,
    required this.placememtName,
  });

  // Factory constructor to create a ComputedPropertyRequest instance from a JSON map
  factory ComputedPropertyRequest.fromJson(Map<dynamic, dynamic> json) {
    return ComputedPropertyRequest(
      type: ComputedPropertyRequestTypeExtension.fromJson(json['type']),
      placememtName: json['placememtName'],
    );
  }

  /// Create a ComputedPropertyRequest from a PComputedPropertyRequest
  static ComputedPropertyRequest fromPigeon(PComputedPropertyRequest request) {
    return ComputedPropertyRequest(
      type: ComputedPropertyRequestTypeExtension.fromPigeon(request.type),
      placememtName: request.eventName,
    );
  }

  /// Convert this ComputedPropertyRequest to a PComputedPropertyRequest
  PComputedPropertyRequest toPigeon() {
    return PComputedPropertyRequest(
      type: ComputedPropertyRequestTypeExtension(type).toPigeon(),
      eventName: placememtName,
    );
  }
}

enum ComputedPropertyRequestType {
  minutesSince,
  hoursSince,
  daysSince,
  monthsSince,
  yearsSince,
  placementsInHour,
  placementsInDay,
  placementsInWeek,
  placementsInMonth,
  placementsSinceInstall,
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
      case ComputedPropertyRequestType.placementsInHour:
        return 'placementsInHour';
      case ComputedPropertyRequestType.placementsInDay:
        return 'placementsInDay';
      case ComputedPropertyRequestType.placementsInWeek:
        return 'placementsInWeek';
      case ComputedPropertyRequestType.placementsInMonth:
        return 'placementsInMonth';
      case ComputedPropertyRequestType.placementsSinceInstall:
        return 'placementsSinceInstall';
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

  /// Convert this ComputedPropertyRequestType to PComputedPropertyRequestType
  PComputedPropertyRequestType toPigeon() {
    switch (this) {
      case ComputedPropertyRequestType.minutesSince:
        return PComputedPropertyRequestType.minutesSince;
      case ComputedPropertyRequestType.hoursSince:
        return PComputedPropertyRequestType.hoursSince;
      case ComputedPropertyRequestType.daysSince:
        return PComputedPropertyRequestType.daysSince;
      case ComputedPropertyRequestType.monthsSince:
        return PComputedPropertyRequestType.monthsSince;
      case ComputedPropertyRequestType.yearsSince:
        return PComputedPropertyRequestType.yearsSince;
      default:
        throw ArgumentError('Invalid ComputedPropertyRequestType value');
    }
  }

  /// Convert a PComputedPropertyRequestType to a ComputedPropertyRequestType
  static ComputedPropertyRequestType fromPigeon(
      PComputedPropertyRequestType type) {
    switch (type) {
      case PComputedPropertyRequestType.minutesSince:
        return ComputedPropertyRequestType.minutesSince;
      case PComputedPropertyRequestType.hoursSince:
        return ComputedPropertyRequestType.hoursSince;
      case PComputedPropertyRequestType.daysSince:
        return ComputedPropertyRequestType.daysSince;
      case PComputedPropertyRequestType.monthsSince:
        return ComputedPropertyRequestType.monthsSince;
      case PComputedPropertyRequestType.yearsSince:
        return ComputedPropertyRequestType.yearsSince;
      case PComputedPropertyRequestType.placementsInHour:
        return ComputedPropertyRequestType.placementsInHour;
      case PComputedPropertyRequestType.placementsInDay:
        return ComputedPropertyRequestType.placementsInDay;
      case PComputedPropertyRequestType.placementsInWeek:
        return ComputedPropertyRequestType.placementsInWeek;
      case PComputedPropertyRequestType.placementsInMonth:
        return ComputedPropertyRequestType.placementsInMonth;
      case PComputedPropertyRequestType.placementsSinceInstall:
        return ComputedPropertyRequestType.placementsSinceInstall;
      default:
        throw ArgumentError('Invalid PComputedPropertyRequestType value');
    }
  }
}
