import 'dart:convert';

import 'package:logger/logger.dart';

/// App Logger
///
/// Wrapper around Logger package with custom configuration
/// Usage:
/// ```dart
/// AppLogger.i('Info message');
/// AppLogger.e('Error message', error: exception);
/// AppLogger.d('Debug message');
/// AppLogger.w('Warning message');
/// ```
class AppLogger {
  static late Logger _logger;

  /// Initialize logger with app configuration
  static void init({bool verbose = false}) {
    _logger = Logger(
      level: verbose ? Level.trace : Level.debug,
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        noBoxingByDefault: false,
      ),
      filter: _DevelopmentFilter(),
      output: ConsoleOutput(),
    );
  }

  /// Verbose log - Most detailed log level
  static void v(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Debug log
  static void d(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Info log
  static void i(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning log
  static void w(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error log
  static void e(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// WTF log - What a Terrible Failure
  static void wtf(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

/// Custom filter for development mode
class _DevelopmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // Log everything in development, only warnings and errors in production
    // Always log everything for now
    return true;
  }
}

/// JSON Formatter for structured logging
class JsonFormatter {
  static String format(Map<String, dynamic> data) {
    return const JsonEncoder.withIndent('  ').convert(data);
  }
}

/// Usage Examples:
///
/// ```dart
/// // Simple log
/// AppLogger.i('User logged in');
///
/// // Log with error
/// AppLogger.e('Failed to fetch data', error: exception);
///
/// // Log with error and stack trace
/// AppLogger.e('Critical error', error: error, stackTrace: stackTrace);
///
/// // Log structured data
/// AppLogger.i('User action', error: {
///   'action': 'swipe_right',
///   'userId': 'user_123',
///   'timestamp': DateTime.now().toIso8601String(),
/// });
/// ```
