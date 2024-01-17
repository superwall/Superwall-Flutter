enum LogLevel {
  debug,
  info,
  warn,
  error,
  none
}

extension LogLevelJson on LogLevel {
  String toJson() {
    switch (this) {
      case LogLevel.debug:
        return 'debug';
      case LogLevel.info:
        return 'info';
      case LogLevel.warn:
        return 'warn';
      case LogLevel.error:
        return 'error';
      case LogLevel.none:
        return 'none';
    }
  }

  static LogLevel fromJson(String json) {
    switch (json) {
      case 'debug':
        return LogLevel.debug;
      case 'info':
        return LogLevel.info;
      case 'warn':
        return LogLevel.warn;
      case 'error':
        return LogLevel.error;
      case 'none':
        return LogLevel.none;
      default:
        throw FormatException('Invalid LogLevel: $json');
    }
  }
}