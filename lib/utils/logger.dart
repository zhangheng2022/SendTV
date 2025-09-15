import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.warning : Level.all, // Release 模式只显示 warning 以上
  );

  /// 详细日志（Verbose）
  static void t(dynamic message) => _logger.t(message);

  /// 调试日志（Debug）
  static void d(dynamic message) => _logger.d(message);

  /// 信息日志（Info）
  static void i(dynamic message) => _logger.i(message);

  /// 警告日志（Warning）
  static void w(dynamic message) => _logger.w(message);

  /// 错误日志（Error）
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  /// 致命错误（What a Terrible Failure）
  static void f(dynamic message) => _logger.f(message);
}
