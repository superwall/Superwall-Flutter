# CHANGELOG

The changelog for `Superwall`. Also see the [releases](https://github.com/superwall/Superwall-Flutter/releases) on GitHub.

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
