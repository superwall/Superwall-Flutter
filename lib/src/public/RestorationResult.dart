import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

sealed class RestorationResult {
  const RestorationResult();
  static const RestorationResult restored = RestorationResultRestored();
  static RestorationResult failed(String error) =>
      RestorationResultFailed(error: error);

  static RestorationResult fromPRestorationResult(dynamic result) {
    if (result is PRestorationRestored) {
      return RestorationResultRestored();
    } else if (result is PRestoreFailed) {
      return RestorationResultFailed(error: result.message ?? 'Unknown error');
    } else {
      throw ArgumentError('Unknown PRestorationResult type');
    }
  }
}

class RestorationResultRestored extends RestorationResult {
  const RestorationResultRestored();
}

class RestorationResultFailed extends RestorationResult {
  final String error;
  const RestorationResultFailed({required this.error});
}
