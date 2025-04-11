# Superwall Flutter SDK Architecture

## Overview

The SW Flutter SDK is a wrapper around native SDK's for Android and iOS.
Under the hood it is based on [Pigeon](https://pub.dev/packages/pigeon), which enables
us to generate Dart, Kotlin and Swift interfaces and method channels, enabling typesafe communication between the Native Host and Flutter.

Each platform contains implementations of the generated interfaces, allowing it's Flutter counterpart to hook into native calls easily.

## Pigeon Integration

### Configuration and Code Generation

The SDK uses Pigeon to define the communication interface between Flutter and native platforms in a single source of truth - the `pigeons/configure.dart` file. This file contains:

1. **Data Models**: Defines all the data structures that can be passed between Flutter and native code
   - Basic data types (strings, numbers, booleans)
   - Complex objects (e.g., `PSuperwallOptions`, `PPaywallInfo`)
   - Enums (e.g., `PLogLevel`, `PEventType`)
   - Sealed classes for polymorphic types (e.g., `PSubscriptionStatus`, `PTriggerResult`)
   - Note: We do not expose these clasess to the user, but map them into exported ones.

2. **API Interfaces**: Defines the communication channels between Flutter and native platforms
   - `PSuperwallHostApi`: Native-to-Flutter API for core SDK functionality
   - `PSuperwallDelegateGenerated`: Flutter-to-Native API for delegate callbacks
   - `PPurchaseControllerGenerated`: Flutter-to-Native API for purchase handling
   - Event channels for streaming data (e.g., `SubscriptionStatusStream`)
   - Note: We do not expose these interfaces to the user, but map them into exported ones.

The generated code lives in `SuperwallHostGenerated` files, while the interface implementations live in `SuperwallHost`.


## Adding new methods

To add a new method to the API, you have to do the following:

1. Add it to the `pigeons/configure.dart` file
   1. 1. If there are any data classes that are not defined in that file but you need to pass, define a pigeon class, prefixed by P. You will need to map from the SDK classes to P* classes and vice versa to be able to pass them through method calls.
2. Run codegen commmand:

```sh
flutter pub run pigeon --input pigeons/configure.dartcriptionStatus_didChange
```

3. Override and implement it in:
   - `SuperwallHost.kt`
   - `SuperwallHost.swift`
  
4. Now add it to the Flutter SDK in `Superwall.dart` and call into the `hostApi` there.

## Communication Flow

1. **Flutter to Native**:
   ```
   Flutter Code -> Generated Dart Interface -> Method Channel -> Generated Native Interface -> Native Host Implementation -> Native SDK
   ```

2. **Native to Flutter**:
   ```
   Native SDK -> Native Host -> Generated Native Interface -> Method Channel -> Generated Dart Interface -> Flutter Code
   ```

3. **Streaming Updates**:
   - Uses EventChannel API for continuous data flow (e.g., subscription status updates)
   - The stream handler's `onListen` is invoked when listened from flutter.



## Testing

To test, we use two different approaches.

1. Integration tests
2. Maestro UI tests


## Integration tests

You will find these in `test_app/integration_test/sdk_methods_test.dart`. 
These are to test the non-UI methods and non-paywall dependent methods.
You can run them using:

```sh
flutter test integration_test/sdk_methods_test.dart
```


## UI Tests

These are ran using Maestro.
First, download and install [maestro](https://maestro.dev/).
After that, you can run them using:

```sh

## For iOS
maestro test -e PLATFORM_ID=com.superwall.Advanced test_app/maestro/purchasecontroller/no_pc_purchases.yaml

## For Android
maestro test -e PLATFORM_ID=com.superwall.superapp test_app/maestro/purchasecontroller/no_pc_purchases.yaml

```

Note the difference in the provided PLATFORM_ID as the package which we will run and test.
You can provide folder as a path to the command to run the whole suite of tests, but maestro currently doesn't pretty print the output.

You can also use:

```./run_tests.sh android/ios` to run either all Android or all iOS test flows.


