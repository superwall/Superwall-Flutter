class Entitlement {
  final String id;
  final String type;

  Entitlement({required this.id, required this.type});

  // Factory constructor for creating an instance from a JSON map
  factory Entitlement.fromJson(Map<String, dynamic> json) {
    return Entitlement(
      id: json['id'],
      type: json['type'],
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}
