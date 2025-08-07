# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **Superwall Flutter SDK v2.4.0** - a Flutter plugin that wraps native Superwall SDKs for Android and iOS. Superwall provides remotely configurable in-app paywall infrastructure for mobile applications.

## Architecture

### Core Technology Stack
- **Flutter Plugin**: Uses Pigeon for type-safe communication between Flutter and native platforms
- **Native SDKs**: 
  - Android: SuperwallKit Android SDK v2.3.1 (Kotlin)
  - iOS: SuperwallKit iOS SDK v4.5.2 (Swift)
- **Code Generation**: Pigeon generates Dart, Kotlin, and Swift interfaces from `pigeons/configure.dart`

### Communication Flow
The SDK uses a layered architecture:
1. **Public Flutter API** (`lib/src/public/`) - Developer-facing API
2. **Generated Interfaces** (`lib/src/generated/superwallhost.g.dart`) - Pigeon-generated type-safe communication
3. **Native Host Implementations** (`android/src/main/kotlin/`, `ios/Classes/`) - Platform-specific implementations
4. **Native SDKs** - Superwall's native Android/iOS SDKs

### Key Components
- **Superwall.dart**: Main SDK class using singleton pattern with static configuration
- **Pigeon Configuration**: `pigeons/configure.dart` defines all data models and API interfaces (single source of truth)
- **Proxy Classes**: Handle callback communication from native to Flutter (delegates, handlers, controllers)
- **Mappers**: Convert between public API models and Pigeon-generated models (prefixed with `P`)

## Development Commands

### Building & Dependencies
```bash
# Install dependencies
flutter pub get

# Generate Pigeon code (after modifying pigeons/configure.dart)
flutter pub run pigeon --input pigeons/configure.dart
```

### Testing
```bash
# Unit tests
flutter test

# Integration tests (requires test_app)
cd test_app && flutter test integration_test/sdk_methods_test.dart

# UI tests using Maestro
./run_tests.sh ios     # Run iOS UI tests  
./run_tests.sh android # Run Android UI tests

# Manual Maestro tests
maestro test -e PLATFORM_ID=com.superwall.Advanced test_app/maestro/handler/flow.yaml
maestro test -e PLATFORM_ID=com.superwall.superapp test_app/maestro/purchasecontroller/no_pc_purchases.yaml
```

### Linting
```bash
# Lint analysis (uses flutter_lints with custom rules in analysis_options.yaml)
flutter analyze
```

## Adding New SDK Methods

When adding new methods to the SDK, follow this workflow:

1. **Define in Pigeon**: Add method and any new data models to `pigeons/configure.dart`
   - Prefix Pigeon classes with `P` (e.g., `PPaywallInfo`)
   - Use sealed classes for polymorphic types

2. **Generate Code**: Run `flutter pub run pigeon --input pigeons/configure.dart`

3. **Implement Native Hosts**:
   - Android: `android/src/main/kotlin/.../SuperwallHost.kt`
   - iOS: `ios/Classes/SuperwallHost.swift`

4. **Add to Flutter API**: Implement in `lib/src/public/Superwall.dart`
   - Add conversion methods between public and Pigeon types
   - Call through `hostApi`

5. **Update Exports**: Add to `lib/superwallkit_flutter.dart` if needed

## Key Directories

- `lib/src/public/`: Public Flutter API - main developer interface
- `lib/src/private/`: Internal proxy classes for native callbacks  
- `lib/src/generated/`: Pigeon-generated communication interfaces
- `pigeons/configure.dart`: Single source of truth for API definitions
- `android/src/main/kotlin/`: Android native implementation
- `ios/Classes/`: iOS native implementation
- `test_app/`: Comprehensive test application with UI tests
- `example/`: Simple integration example

## Native Platform Details

### Android
- **Min SDK**: 26 (Android 8.0)
- **Compile SDK**: 34
- **Language**: Kotlin
- **Dependencies**: SuperwallKit Android v2.3.1, Google Billing Client v6.1.0

### iOS  
- **Min Version**: iOS 14.0
- **Language**: Swift 5.0
- **Dependencies**: SuperwallKit iOS v4.5.2
- **Build**: Uses CocoaPods for dependency management

## Testing Strategy

1. **Integration Tests**: Test non-UI SDK methods (`test_app/integration_test/`)
2. **Maestro UI Tests**: Test paywall presentation and user interactions (`test_app/maestro/`)
3. **Platform Coverage**: Tests run on both iOS and Android with different app IDs
   - iOS: `com.superwall.Advanced`  
   - Android: `com.superwall.superapp`

## Build Configuration Notes

- The Android build includes a `WAIT_FOR_DEBUGGER` configuration that can be set in `local.properties`
- Analysis options disable `file_names` rule and enable `inline-class` experiment
- The plugin supports both example apps and comprehensive test applications for development