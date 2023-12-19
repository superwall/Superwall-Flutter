import 'package:flutter/services.dart';

class RestorationResult {
  final _RestorationResultType _type;
  final Object? _data;

  const RestorationResult._(this._type, [this._data]);

  static const RestorationResult restored = RestorationResult._(_RestorationResultType.restored);
  static RestorationResult failed([Object? error]) => RestorationResult._(_RestorationResultType.failed, error);

  Object? get error => _type == _RestorationResultType.failed ? _data : null;

  // Serializes the RestorationResult instance into a map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'type': _type.toString().split('.').last,
    };

    if (_data != null) {
      json['error'] = error?.toString();
    }

    return json;
  }
}

enum _RestorationResultType {
  restored,
  failed,
}
