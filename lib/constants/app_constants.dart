import 'package:fluent_ui/fluent_ui.dart';

class AppConstants {
  static const String appName = 'Lorem Restaurant';
  static const String searchPlaceholder = 'Search menu here...';
  static const String printBillsText = 'Print Bills';

  // Tax rate (10%)
  static const double taxRate = 0.10;

  // Navigation items
  static const List<String> navigationItems = [
    'Home',
    'Menu',
    'History',
    'Promos',
    'Settings',
  ];
}

class AppColors {
  // Dark theme colors - Material Design 3 inspired
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  static const Color surfaceContainer = Color(0xFF252525);
  static const Color surfaceContainerHigh = Color(0xFF2F2F2F);

  // Elevated surface
  static const Color surfaceElevated = Color(0xFF242424);
  static const Color surfaceElevatedHigh = Color(0xFF2E2E2E);

  // Accent colors - More sophisticated palette
  static const Color primaryAccent = Color(0xFFFF8A65); // Warm orange
  static const Color primaryAccentHover = Color(0xFFFF7043);
  static const Color primaryAccentPressed = Color(0xFFFF5722);
  static const Color secondaryAccent = Color(0xFF4FC3F7); // Cyan blue
  static const Color tertiaryAccent = Color(0xFF9C27B0); // Purple

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Text colors with better contrast ratios
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textTertiary = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFF757575);

  // Price color
  static const Color priceColor = Color(
    0xFF4CAF50,
  ); // Green for better psychology
  static const Color originalPrice = Color(
    0xFF9E9E9E,
  ); // Gray for crossed out prices

  // Border colors
  static const Color border = Color(0xFF424242);
  static const Color borderFocus = Color(0xFF757575);
  static const Color borderHover = Color(0xFF616161);

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowHeavy = Color(0x4D000000);

  // Overlay colors
  static const Color overlayLight = Color(0x0AFFFFFF);
  static const Color overlayMedium = Color(0x14FFFFFF);
  static const Color overlayHeavy = Color(0x1FFFFFFF);
}

class AppSizes {
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border radius - Updated for modern look
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;

  // Icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;

  // Card sizes - Made responsive
  static const double productCardHeight = 220.0;
  static const double productCardWidth = 190.0;
  static const double productCardMaxWidth = 240.0;
  static const double productCardMinWidth = 160.0;

  // Sidebar
  static const double sidebarWidth = 260.0;
  static const double sidebarCollapsedWidth = 68.0;

  // Cart panel - Made adaptive
  static const double cartPanelWidth = 320.0;
  static const double cartPanelMinWidth = 280.0;
  static const double cartPanelMaxWidth = 380.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 350);

  // Touch targets for better accessibility
  static const double minTouchTarget = 44.0;
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
}

class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double desktopLarge = 1600;

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) =>
      width >= desktop && width < desktopLarge;
  static bool isDesktopLarge(double width) => width >= desktopLarge;
}

class AppElevations {
  static const double level0 = 0.0;
  static const double level1 = 1.0;
  static const double level2 = 3.0;
  static const double level3 = 6.0;
  static const double level4 = 8.0;
  static const double level5 = 12.0;
}
