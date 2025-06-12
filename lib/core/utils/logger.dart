import 'package:logger/logger.dart';
import '../config/app_config.dart';

/// Sistema de logging avançado da aplicação
class AppLogger {
  static late Logger _logger;
  static bool _initialized = false;

  /// Inicializa o sistema de logging
  static Future<void> initialize() async {
    if (_initialized) return;

    _logger = Logger(
      level: AppConfig.logLevel,
      printer: _createPrinter(),
      output: ConsoleOutput(),
    );

    _initialized = true;
    info('Logger initialized for ${AppConfig.environmentName} environment');
  }

  /// Cria o printer apropriado baseado no ambiente
  static LogPrinter _createPrinter() {
    if (AppConfig.isProduction) {
      return SimplePrinter(colors: false);
    }

    return PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    );
  }

  /// Log de debug
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_initialized) return;
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log de informação
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_initialized) return;
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log de warning
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_initialized) return;
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log de erro
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!_initialized) return;
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log específico para operações de negócio
  static void business(String operation, Map<String, dynamic> data) {
    info('BUSINESS: $operation', data);
  }

  /// Log específico para operações de migração
  static void migration(String step, String details) {
    info('MIGRATION: $step - $details');
  }

  /// Log de performance
  static void performance(String operation, Duration duration) {
    info('PERFORMANCE: $operation took ${duration.inMilliseconds}ms');
  }

  /// Log de ação do usuário
  static void userAction(
    String action,
    String userId,
    Map<String, dynamic>? metadata,
  ) {
    info('USER_ACTION: $action by $userId', metadata);
  }
}
