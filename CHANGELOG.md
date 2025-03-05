# CHANGELOG

The changelog for `Superwall`. Also see the [releases](https://github.com/superwall/Superwall-Flutter/releases) on GitHub.

## 1.3.11

### Fixes

- Fixes BridgeInstance crashes
- Adds awaiting on shared instance of BridgeCreator to avoid crashes when plugin is yet to attach


## 1.3.10

### Fixes

- Fixes an issue on iOS where the plugin could get registered multiple times resulting in a `MissingPluginException`.

## 1.3.9

### Fixes

- Fixes a compatibility issue with `WorkManager` and other isolate-running libraries where the plugin would detach and cause a `Missing Activity` or `BridgeCreator` exception

### Enhancements

- Updates Android SDK to 1.5.4 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.5.4)

## 1.3.8

### Fixes

- Removes unnecessary date comparison from PurchaseController example code.

## 1.3.7

### Enhancements

- Upgrades iOS SDK to 3.12.1 [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.12.1)

## 1.3.6

### Enhancements

- Updates Android SDK to 1.5.1 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.5.1)

## 1.3.5

### Enhancements

- Upgrades iOS SDK to 3.12.0 [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.12.0)
- Updates Android SDK to 1.5.0 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.5.0)

### Fixes

- Fixes issue with `PaywallInfoBridge` and other bridges throwing NPE when reattaching to activities from deep sleep.

## 1.3.4

### Enhancements

- Adds `setLocaleIdentifier(_:)` and `getLocaleIdentifier()`.

## 1.3.3

- Upgrades Android SDK to 1.3.1 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.3.1)
- This fixes the issue when using Superwall with some SDK's would cause a crash (i.e. Smartlook SDK)

## 1.3.2

- Updates project linting and formatting to be consistent with the Flutter style
- Removes rogue logging statements by matching them with the provided Log level
- Adds `passIdentifiersToPlayStore` to `SuperwallOptions` which allows you to pass user identifiers to the Play Store purchases as account identifiers. This is useful for tracking user purchases in the Play Store console.

## 1.3.1

### Enhancements

- Upgrades Android SDK to 1.3.0 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.3.0)
- Upgrades iOS SDK to 3.10.1 [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.10.1)
- Adds `confirmAllAssignments` method to `Superwall` which confirms assignments for all placements and returns an array of all confirmed experiment assignments. Note that the assignments may be different when a placement is registered due to changes in user, placement, or device parameters used in audience filters.

## 1.3.0

### Enhancements

- Upgrades iOS SDK to 3.9.1. [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.9.1)
- Upgrades Android SDK to 1.2.7 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.2.7)
- Exposes the `SuperwallOption` `collectAdServicesAttribution` for iOS. When `true`, this collects the AdServices attribute token, which will be process by our backend. Adds `adServicesTokenRequest_start`, `adServicesTokenRequest_complete`, and `adServicesTokenRequest_fail`.
- Exposes `getConfigurationStatus()`, which replaces `getIsConfigured()`. This returns either `ConfigurationStatusPending`, `ConfigurationStatusConfigured`, or `ConfigurationStatusFailed`.

## 1.2.2

### Enhancements

- Upgrades Android SDK to 1.2.4 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.2.4)

### Fixes

- Reapply the single bridge instance limit to fix issues with `setDelegate` where plugins with multiple isolates are used
- Fixes stateful bridges by applying new state when invoking create, resolving issues seen in #23

## 1.2.1

### Enhancements

- Upgrades Android SDK to 1.2.3 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.2.3)
- Upgrades iOS SDK to 3.7.2. [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.7.2)

## 1.2.0

### Enhancements

- Upgrades Android SDK to 1.2.0 [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.2.0)

### Fixes

- Updates `compileSDKVersion` to 34 fixing build issues on Android.

## 1.1.9

### Enhancements

- Upgrades Android SDK to 1.1.8. [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.1.8)

### Fixes

- Bumps minimum Kotlin version to 1.8.0 and Android Gradle Plugin to 8.1.0 to be able to be
  compatible with the latest Android SDK. This was necessary for important bug fixes.
- SW-2868: Fixes transaction issues caused by hot restart.

## 1.1.8

### Enhancements

- Upgrades iOS SDK to 3.6.6. [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.6.6)
- Upgrades Android SDK to 1.1.7. [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.1.7)

## 1.1.7

### Enhancements

- Upgrades iOS SDK to 3.6.5. [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.6.5)

## 1.1.6

### Enhancements

- Upgrades Android SDK to 1.1.6. [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.1.6)

## 1.1.5

### Enhancements

- Upgrades Android SDK to 1.1.5. [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.1.5)

## 1.1.4

### Enhancements

- Upgrades Android SDK to 1.1.4. [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.1.4)
- Upgrades iOS SDK to 3.6.2. [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.6.2)
- Adds `identityAlias` `SuperwallEvent`.

### Fixes

- Updates the UUID framework dependency to the latest version to prevent conflicts.

## 1.1.3

### Fixes

- Fixes crash that occurred if an Android foreground service was started and the app was relaunched from a cold start.

## 1.1.2

### Enhancements

- Upgrades Android SDK to 1.1.2. [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.1.2)
- Upgrades iOS SDK to 3.6.1. [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.6.1)

## 1.1.1

### Fixes

- Fixes `LocalNotification` issue that was trying to initialise an `int` with a `double`.

## 1.1.0

### Enhancements

- Upgrades Android SDK to 1.1.1. [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.1.1)
- Upgrades iOS SDK to 3.6.0. [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.6.0)

## 1.0.1

### Fixes

- Fixes issue with invalid imports due to a breaking change on Android.

## 1.0.0

### Enhancements

- Upgrades Android SDK to 1.0.0. [View Android SDK release notes](https://github.com/superwall-me/Superwall-Android/releases/tag/1.0.0)
- Upgrades iOS SDK to 3.5.0. [View iOS SDK release notes](https://github.com/superwall-me/Superwall-iOS/releases/tag/3.5.0)
