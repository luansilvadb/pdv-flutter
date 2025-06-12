import 'package:logger/logger.dart';
import 'environment.dart';

/// Configurações globais da aplicação
class AppConfig {
  // Ambiente
  static const bool isDevelopment = bool.fromEnvironment(
    'DEBUG',
    defaultValue: true,
  );
  static const bool isStaging = bool.fromEnvironment(
    'STAGING',
    defaultValue: false,
  );
  static const bool isProduction = !isDevelopment && !isStaging;

  // Getter para Environment
  static Environment get environment => EnvironmentConfig.current;

  // Configurações de logging
  static Level get logLevel {
    if (isProduction) return Level.warning;
    if (isStaging) return Level.info;
    return Level.debug;
  }

  // Configurações de API (futuro)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.pdv-restaurant.com',
  );

  static const Duration apiTimeout = Duration(seconds: 30);

  // Configurações de cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB

  // Configurações de negócio
  static const double defaultTaxRate = 0.10;
  static const int maxCartItems = 50;
  static const double minOrderValue = 5.0;

  // Configurações de UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Configurações de logging
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: isDevelopment,
  );
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );
  static const bool enableCrashReporting = bool.fromEnvironment(
    'ENABLE_CRASH_REPORTING',
    defaultValue: isProduction,
  );

  // Configurações de storage
  static const String storageBoxName = 'pdv_storage';
  static const String cartStorageKey = 'cart_items';
  static const String userPreferencesKey = 'user_preferences';
  static const String orderHistoryKey = 'order_history';

  // Configurações de features
  static const bool enableOfflineMode = true;
  static const bool enableSyncOnStartup = true;
  static const bool enableAutoBackup = true;

  // Limitações
  static const int maxOrderHistoryItems = 1000;
  static const int maxSearchResults = 100;
  static const Duration searchDebounce = Duration(milliseconds: 300);

  // Configurações específicas do ambiente
  static String get environmentName {
    if (isDevelopment) return 'development';
    if (isStaging) return 'staging';
    return 'production';
  }

  static bool get enableDetailedLogs => isDevelopment;
  static bool get enableNetworkLogs => isDevelopment;
  static bool get enablePerformanceMonitoring => true;
}
