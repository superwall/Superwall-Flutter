import SuperwallKit

extension LogLevel {
  static func fromJson(_ json: String) -> LogLevel? {
    switch json {
      case "debug":
        return LogLevel.debug
      case "info":
        return LogLevel.info
      case "warn":
        return LogLevel.warn
      case "error":
        return LogLevel.error
      case "none":
        return LogLevel.none
      default:
        return nil
    }
  }
}
