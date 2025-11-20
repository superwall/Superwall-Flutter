import '../generated/superwallhost.g.dart';

/// Attributes for third-party integrations with Superwall.
///
/// Use these attributes to sync user identifiers from your analytics and attribution
/// providers with Superwall. This enables better user tracking and attribution.
enum IntegrationAttribute {
  /// The unique Adjust identifier for the user.
  adjustId,

  /// The Amplitude device identifier.
  amplitudeDeviceId,

  /// The Amplitude user identifier.
  amplitudeUserId,

  /// The unique Appsflyer identifier for the user.
  appsflyerId,

  /// The Braze `alias_name` in User Alias Object.
  brazeAliasName,

  /// The Braze `alias_label` in User Alias Object.
  brazeAliasLabel,

  /// The OneSignal Player identifier for the user.
  onesignalId,

  /// The Facebook Anonymous identifier for the user.
  fbAnonId,

  /// The Firebase instance identifier.
  firebaseAppInstanceId,

  /// The Iterable identifier for the user.
  iterableUserId,

  /// The Iterable campaign identifier.
  iterableCampaignId,

  /// The Iterable template identifier.
  iterableTemplateId,

  /// The Mixpanel user identifier.
  mixpanelDistinctId,

  /// The unique mParticle user identifier (mpid).
  mparticleId,

  /// The CleverTap user identifier.
  clevertapId,

  /// The Airship channel identifier for the user.
  airshipChannelId,

  /// The unique Kochava device identifier.
  kochavaDeviceId,

  /// The Tenjin identifier.
  tenjinId,

  /// The PostHog User identifier.
  posthogUserId,

  /// The Customer.io person's identifier (`id`).
  customerioId;

  PIntegrationAttribute toPigeon() {
    switch (this) {
      case IntegrationAttribute.adjustId:
        return PIntegrationAttribute.adjustId;
      case IntegrationAttribute.amplitudeDeviceId:
        return PIntegrationAttribute.amplitudeDeviceId;
      case IntegrationAttribute.amplitudeUserId:
        return PIntegrationAttribute.amplitudeUserId;
      case IntegrationAttribute.appsflyerId:
        return PIntegrationAttribute.appsflyerId;
      case IntegrationAttribute.brazeAliasName:
        return PIntegrationAttribute.brazeAliasName;
      case IntegrationAttribute.brazeAliasLabel:
        return PIntegrationAttribute.brazeAliasLabel;
      case IntegrationAttribute.onesignalId:
        return PIntegrationAttribute.onesignalId;
      case IntegrationAttribute.fbAnonId:
        return PIntegrationAttribute.fbAnonId;
      case IntegrationAttribute.firebaseAppInstanceId:
        return PIntegrationAttribute.firebaseAppInstanceId;
      case IntegrationAttribute.iterableUserId:
        return PIntegrationAttribute.iterableUserId;
      case IntegrationAttribute.iterableCampaignId:
        return PIntegrationAttribute.iterableCampaignId;
      case IntegrationAttribute.iterableTemplateId:
        return PIntegrationAttribute.iterableTemplateId;
      case IntegrationAttribute.mixpanelDistinctId:
        return PIntegrationAttribute.mixpanelDistinctId;
      case IntegrationAttribute.mparticleId:
        return PIntegrationAttribute.mparticleId;
      case IntegrationAttribute.clevertapId:
        return PIntegrationAttribute.clevertapId;
      case IntegrationAttribute.airshipChannelId:
        return PIntegrationAttribute.airshipChannelId;
      case IntegrationAttribute.kochavaDeviceId:
        return PIntegrationAttribute.kochavaDeviceId;
      case IntegrationAttribute.tenjinId:
        return PIntegrationAttribute.tenjinId;
      case IntegrationAttribute.posthogUserId:
        return PIntegrationAttribute.posthogUserId;
      case IntegrationAttribute.customerioId:
        return PIntegrationAttribute.customerioId;
    }
  }
}
