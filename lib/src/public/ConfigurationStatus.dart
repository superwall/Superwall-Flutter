import 'package:superwallkit_flutter/src/generated/superwallhost.g.dart';

/// An enum representing the subscription status of the user.
enum ConfigurationStatus {
  pending,
  configured,
  failed;

  static ConfigurationStatus createConfigurationStatusFromPConfigurationStatus(
      PConfigurationStatus pConfigurationStatus) {
    switch (pConfigurationStatus) {
      case PConfigurationStatus.pending:
        return ConfigurationStatus.pending;
      case PConfigurationStatus.configured:
        return ConfigurationStatus.configured;
      case PConfigurationStatus.failed:
        return ConfigurationStatus.failed;
      default:
        return ConfigurationStatus.failed;
    }
  }
}
