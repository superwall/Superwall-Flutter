import 'package:flutter/services.dart';

// The name of the bridging class on the native side
typedef BridgeClass = String;

// The identifier of the bridge instance
typedef BridgeId = String;

class BridgingCreator {
  static const MethodChannel _channel = MethodChannel('SWK_BridgingCreator');

  // Stores argument metadata provided during the creation of the bridgeId.
  // This will later be used when invoking creation to pass in initialization arguments
  static final Map<String, Map<String, dynamic>> _metadataByBridgeId = {};

  static BridgeId _createBridgeId(
      {String? givenId,
      required BridgeClass bridgeClass,
      Map<String, dynamic>? initializationArgs}) {
    BridgeId bridgeId = givenId ?? bridgeClass.generateBridgeId();
    _metadataByBridgeId[bridgeId] = {'args': initializationArgs};

    return bridgeId;
  }

  static _invokeBridgeInstanceCreation(BridgeId bridgeId) async {
    Map<String, dynamic> metadata =
        BridgingCreator._metadataByBridgeId[bridgeId] ?? {};
    Map<String, dynamic>? initializationArgs = metadata['args'];

    await _channel.invokeMethod('createBridgeInstance',
        {'bridgeId': bridgeId, 'args': initializationArgs});

    metadata['bridgeInstanceCreated'] = 'true';
    _metadataByBridgeId[bridgeId] = metadata;
  }

  static Future<void> _ensureBridgeCreated(BridgeId bridgeId) async {
    Map<String, dynamic>? metadata =
        BridgingCreator._metadataByBridgeId[bridgeId];

    // If metadata is not null, this bridge was already created on the Dart
    // side here, so you must invoke creation of the instance on the native side.
    if (metadata != null && metadata['bridgeInstanceCreated'] == null) {
      await BridgingCreator._invokeBridgeInstanceCreation(bridgeId);
    }
  }
}

// A protocol that Dart classes should conform to if they want to be able to
// create a BridgeId, or instantiate themselves from a BridgeID
abstract class BridgeIdInstantiable {
  BridgeId bridgeId;

  BridgeIdInstantiable(
      {required BridgeClass bridgeClass,
      BridgeId? bridgeId,
      BridgeId? givenId,
      Map<String, dynamic>? initializationArgs})
      : bridgeId = bridgeId ??
            BridgingCreator._createBridgeId(
                givenId: givenId,
                bridgeClass: bridgeClass,
                initializationArgs: initializationArgs) {
    assert(this.bridgeId.endsWith('-bridgeId'),
        'Make sure bridgeIds end with "-bridgeId"');
    this.bridgeId.associate(this);
    this.bridgeId.communicator.setMethodCallHandler(handleMethodCall);
  }

  // Handle method calls from native (subclasses should implement)
  Future<dynamic> handleMethodCall(MethodCall call) async {}
}

extension MethodChannelBridging on MethodChannel {
  // Will invoke the method as usual, but will wait for any native Ids to be
  // created if they don't already exist.
  Future<T?> invokeBridgeMethod<T>(String method,
      [Map<String, Object?>? arguments]) async {
    // Check if arguments is a Map and contains native IDs
    if (arguments != null) {
      for (var value in arguments.values) {
        if (value is String && value.isBridgeId) {
          BridgeId bridgeId = value;
          await bridgeId.ensureBridgeCreated();
        }
      }
    }

    await bridgeId.ensureBridgeCreated();

    return invokeMethod(method, arguments);
  }

  BridgeId get bridgeId {
    return name;
  }
}

extension FlutterMethodCall on MethodCall {
  T? argument<T>(String key) {
    return arguments[key] as T?;
  }

  BridgeId bridgeId(String key) {
    final BridgeId? bridgeId = argument<String>(key);
    assert(
        bridgeId != null,
        'Attempting to fetch a bridge Id in Dart that has '
        'not been created by the BridgeCreator natively.');

    return bridgeId ?? '';
  }
}

// Stores a reference to a dart instance that receives responses from the native side.
extension BridgeAssociation on BridgeId {
  static final List<dynamic> associatedInstances = [];

  associate(dynamic dartInstance) {
    BridgeAssociation.associatedInstances.add(dartInstance);
  }
}

extension BridgeAdditions on BridgeId {
  MethodChannel get communicator {
    return MethodChannel(this);
  }

  BridgeClass get bridgeClass {
    return split('-').first;
  }

  // Call this
  Future<void> ensureBridgeCreated() async {
    await BridgingCreator._ensureBridgeCreated(this);
  }
}

extension StringExtension on String {
  bool get isBridgeId {
    return endsWith('-bridgeId');
  }
}

extension Additions on BridgeClass {
  // Make sure this is the same on the Native side.
  BridgeId generateBridgeId() {
    final bridgeId = '$this-bridgeId';
    return bridgeId;
  }
}
