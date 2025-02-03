class Entitlement {
  final String id;
  final String type;

  Entitlement({required this.id, this.type = 'SERVICE_LEVEL'});

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

class Entitlements {
  final Set<Entitlement> active;
  final Set<Entitlement> inactive;
  final Set<Entitlement> all;

  Entitlements({
    required this.active,
    required this.inactive,
    required this.all,
  });

  factory Entitlements.fromJson(Map<String, dynamic> json) {
    return Entitlements(
      active: json['active'],
      inactive: json['inactive'],
      all: json['all'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active.map((e) => e.toJson()).toList(),
      'inactive': inactive.map((e) => e.toJson()).toList(),
      'all': all.map((e) => e.toJson()).toList(),
    };
  }
}
