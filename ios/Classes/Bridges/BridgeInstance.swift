import Flutter
import SuperwallKit

typealias BridgeClass = String
typealias BridgeId = String
typealias Communicator = FlutterMethodChannel

public class BridgeInstance: NSObject {
  class var bridgeClass: BridgeClass {
    assertionFailure("Subclasses must implement")
    return ""
  }

  lazy var communicator: Communicator = {
    let communicator = Communicator(name: bridgeId, binaryMessenger: BridgingCreator.shared.registrar.messenger())

    // Setting an associated object here because `FlutterMethodChannel / Communicator` doesn't make the `name` publicly available. Consider subclassing `FlutterMethodChannel` instead to avoid this.
    communicator.bridgeId = bridgeId

    return communicator
  }()

  let bridgeId: BridgeId
  let initializationArgs: [String: Any]?

  required init(bridgeId: BridgeId, initializationArgs: [String: Any]? = nil) {
    self.bridgeId = bridgeId
    self.initializationArgs = initializationArgs
  }
}

extension BridgeId {
  var bridgeClass: BridgeClass {
    guard let bridgeClass = components(separatedBy: "-").first else {
      fatalError("Unable to parse bridge class from \(self).")
    }

    return bridgeClass
  }
}

extension BridgeClass {
  // Make sure this is the same on the Dart side.
  func generateBridgeId() -> BridgeId {
    return "\(self)-bridgeId"
  }
}

extension BridgeInstance: FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {}
}
