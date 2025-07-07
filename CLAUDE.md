# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Superwall Flutter SDK - a Flutter plugin that wraps native iOS and Android SDKs for paywall management and subscription handling. The project uses **Pigeon** for type-safe communication between Flutter and native platforms.

## Key Architecture

### Pigeon-Based Communication
- **Single Source of Truth**: `pigeons/configure.dart` defines all data models and API interfaces
- **Code Generation**: Pigeon generates type-safe interfaces for Dart, Kotlin (Android), and Swift (iOS)
- **Communication Flow**: Flutter ↔ Generated Interface ↔ Method Channel ↔ Native Implementation ↔ Native SDK

### Core Components
- **Flutter Layer**: `lib/src/public/Superwall.dart` - Main SDK class, singleton pattern
- **Generated Code**: `lib/src/generated/superwallhost.g.dart` - Auto-generated from Pigeon
- **Native Hosts**: 
  - Android: `android/src/main/kotlin/.../SuperwallHost.kt`
  - iOS: `ios/Classes/SuperwallHost.swift`
- **Proxy Classes**: `lib/src/private/*Proxy.dart` - Handle callback routing between Flutter and native

### Data Flow Patterns
- **Host API**: Native-to-Flutter calls (e.g., `PSuperwallHostApi`)
- **Flutter API**: Flutter-to-Native calls (e.g., `PSuperwallDelegateGenerated`)
- **Event Streams**: For continuous updates (e.g., `SubscriptionStatusStream`)

## Development Commands

### Code Generation
Generate Pigeon interfaces after modifying `pigeons/configure.dart`:
```bash
flutter pub run pigeon --input pigeons/configure.dart
```

### Testing
Run unit tests:
```bash
flutter test
```

Run integration tests (non-UI methods):  
```bash
cd test_app
flutter test integration_test/sdk_methods_test.dart
```

Run UI tests with Maestro:
```bash
# iOS
./run_tests.sh ios

# Android  
./run_tests.sh android
```

Individual Maestro test:
```bash
# iOS
maestro test -e PLATFORM_ID=com.superwall.Advanced test_app/maestro/handler/flow.yaml

# Android
maestro test -e PLATFORM_ID=com.superwall.superapp test_app/maestro/handler/flow.yaml
```

### Build Commands
Build example app:
```bash
cd example
flutter build ios --no-codesign  # iOS
flutter build apk               # Android
```

### Analysis and Linting
```bash
flutter analyze
dart format .
```

## Adding New Methods

1. **Define in Pigeon**: Add method and any new data classes to `pigeons/configure.dart`
   - Prefix Pigeon classes with `P` (e.g., `PPaywallInfo`)
   - Use sealed classes for polymorphic types
2. **Generate Code**: Run `flutter pub run pigeon --input pigeons/configure.dart`
3. **Implement Native**: Add implementations in `SuperwallHost.kt` and `SuperwallHost.swift`
4. **Flutter Integration**: Add public method in `lib/src/public/Superwall.dart`
5. **Mapping**: Create mapping functions between public classes and Pigeon classes

## Code Conventions

### File Organization
- **Public API**: `lib/src/public/` - Classes exposed to SDK users
- **Private API**: `lib/src/private/` - Internal implementation details  
- **Generated**: `lib/src/generated/` - Auto-generated Pigeon code (do not edit)

### Naming Patterns
- **Pigeon Classes**: Prefixed with `P` (e.g., `PSuperwallOptions`)
- **Public Classes**: No prefix (e.g., `SuperwallOptions`)
- **Proxy Classes**: Suffixed with `Proxy` (e.g., `PurchaseControllerProxy`)

### Data Mapping
- Always map between public SDK classes and Pigeon classes
- Use helper methods like `_convertToGeneratedOptions()` in `Superwall.dart`
- Handle sealed class conversions with switch statements

## Testing Structure

### Integration Tests
- Location: `test_app/integration_test/sdk_methods_test.dart`
- Purpose: Test SDK methods without UI dependencies
- Run with: `flutter test integration_test/sdk_methods_test.dart`

### UI Tests (Maestro)
- Location: `test_app/maestro/`
- Test flows: handler, delegate, purchase controller
- Platform-specific app IDs:
  - iOS: `com.superwall.Advanced`
  - Android: `com.superwall.superapp`

## Project Structure Notes

- **Multiple Example Apps**: Both `example/` and `test_app/` serve different testing purposes
- **Platform-Specific Code**: Native implementations in `android/` and `ios/` directories
- **Shared Configuration**: `analysis_options.yaml` enables inline-class experiment
- **Asset Management**: `pubspec.yaml` included as asset for SDK functionality

## Important Files

- `pigeons/configure.dart` - API definition and data models
- `lib/src/public/Superwall.dart` - Main SDK entry point  
- `CONTRIBUTING.md` - Detailed architecture documentation
- `run_tests.sh` - Automated testing script for both platforms