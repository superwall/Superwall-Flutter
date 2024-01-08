/// A request to compute a device property associated with an event at runtime.
class ComputedPropertyRequest {
  // TODO
  // /// The type of device property to compute.
  // final ComputedPropertyRequestType type;
  //
  // /// The name of the event used to compute the device property.
  // final String eventName;
  //
  // ComputedPropertyRequest({
  //   required this.type,
  //   required this.eventName,
  // });
}

enum ComputedPropertyRequestType {
  minutesSince,
  hoursSince,
  daysSince,
  monthsSince,
  yearsSince,
}
