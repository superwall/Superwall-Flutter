import 'package:flutter/services.dart';

class RestorationResult {
  final _RestorationResultType _type;
  final Object? _data;
  static const MethodChannel _channel = MethodChannel('SWK_RestorationResultPlugin');

  const RestorationResult._(this._type, [this._data]);

  static const RestorationResult restored = RestorationResult._(_RestorationResultType.restored);
  static RestorationResult failed([Object? error]) => RestorationResult._(_RestorationResultType.failed, error);

  bool get isRestored => _type == _RestorationResultType.restored;
  Object? get error => _type == _RestorationResultType.failed ? _data : null;

  Future<bool> isEqualTo(RestorationResult other) async {
    final bool isEqual = await _channel.invokeMethod('isEqualTo', {
      'result1': _type.toString(),
      'result2': other._type.toString(),
      'data1': _data,
      'data2': other._data,
    });
    return isEqual;
  }
}

enum _RestorationResultType {
  restored,
  failed,
}
