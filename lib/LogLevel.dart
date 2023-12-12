import 'package:flutter/services.dart';

enum LogLevel {
  debug(10),
  info(20),
  warn(30),
  error(40),
  none(99);

  final int value;

  const LogLevel(this.value);

  static final _descriptions = <LogLevel, Future<String>>{};
  static final _descriptionEmojis = <LogLevel, Future<String>>{};

  static Future<String> description(LogLevel level) async {
    if (!_descriptions.containsKey(level)) {
      _descriptions[level] = _fetchDescriptionFromNative(level);
    }
    return _descriptions[level]!;
  }

  static Future<String> descriptionEmoji(LogLevel level) async {
    if (!_descriptionEmojis.containsKey(level)) {
      _descriptionEmojis[level] = _fetchDescriptionEmojiFromNative(level);
    }
    return _descriptionEmojis[level]!;
  }

  static Future<String> _fetchDescriptionFromNative(LogLevel level) async {
    final MethodChannel _channel = MethodChannel('SWK_LogLevelPlugin');
    final String description = await _channel.invokeMethod('getLogLevelDescription', {'level': level.value});
    return description;
  }

  static Future<String> _fetchDescriptionEmojiFromNative(LogLevel level) async {
    final MethodChannel _channel = MethodChannel('SWK_LogLevelPlugin');
    final String descriptionEmoji = await _channel.invokeMethod('getLogLevelDescriptionEmoji', {'level': level.value});
    return descriptionEmoji;
  }
}
