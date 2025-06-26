import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

sealed class RestorationResult {
  const RestorationResult();
  static const RestorationResult restored = RestorationResultRestored();
  static RestorationResult failed(String error) =>
      RestorationResultFailed(error: error);

  static RestorationResult fromPRestorationResult(dynamic result) {
    if (result is PRestorationRestored) {
      return const RestorationResultRestored();
    } else if (result is PRestorationFailed) {
      return RestorationResultFailed(error: result.error ?? 'Unknown error');
    } else {
      throw ArgumentError('Unknown PRestorationResult type');
    }
  }

  static PRestorationResult toPRestorationResult(RestorationResult result) {
    try {
      final restorationResult = result;
      if (restorationResult is RestorationResultRestored) {
        return PRestorationRestored();
      } else if (restorationResult is RestorationResultFailed) {
        return PRestorationFailed(error: restorationResult.error);
      } else {
        throw ArgumentError('Unknown RestorationResult type');
      }
    } catch (e) {
      return PRestorationFailed(error: e.toString());
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
