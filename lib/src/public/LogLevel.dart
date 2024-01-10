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
}