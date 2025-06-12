import 'package:fluent_ui/fluent_ui.dart';

/// Constantes da aplicação
class AppConstants {
  static const String appName = 'PDV Restaurant';
  static const String appVersion = '2.0.0';
  
  // Limites de quantidade
  static const int maxQuantity = 999;
  static const int minQuantity = 1;
  static const int lowStockThreshold = 5;
  
  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);
  
  // Formatos
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm:ss';
  static const String currencyFormat = 'R\$ #,##0.00';
}

/// Cores da aplicação
class AppColors {
  static const Color primary = Color(0xFF0078D4);
  static const Color secondary = Color(0xFF6CB33F);
  static const Color danger = Color(0xFFD13438);
  static const Color warning = Color(0xFFFF8C00);
  static const Color success = Color(0xFF107C10);
  static const Color info = Color(0xFF0078D4);
  
  // Estados
  static const Color lowStock = Color(0xFFFF8C00);
  static const Color outOfStock = Color(0xFFD13438);
  static const Color inStock = Color(0xFF107C10);
  
  // Background
  static const Color background = Color(0xFFF3F2F1);
  static const Color surface = Colors.white;
  
  // Text
  static const Color textPrimary = Color(0xFF323130);
  static const Color textSecondary = Color(0xFF605E5C);
}

/// Tamanhos da aplicação
class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}
