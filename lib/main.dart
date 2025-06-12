import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/services/dependency_injection.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependências com nova arquitetura Clean
  await initializeDependencies();

  runApp(const ProviderScope(child: PDVRestaurantApp()));
}

class PDVRestaurantApp extends StatelessWidget {
  const PDVRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: AppConstants.appName,
      theme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: AccentColor.swatch({
          'darkest': AppColors.primaryAccentPressed.withValues(alpha: 0.3),
          'darker': AppColors.primaryAccentPressed.withValues(alpha: 0.5),
          'dark': AppColors.primaryAccentHover.withValues(alpha: 0.7),
          'normal': AppColors.primaryAccent,
          'light': AppColors.primaryAccent.withValues(alpha: 0.8),
          'lighter': AppColors.primaryAccent.withValues(alpha: 0.6),
          'lightest': AppColors.primaryAccent.withValues(alpha: 0.4),
        }),
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.surface,
        menuColor: AppColors.surfaceElevated,
        visualDensity: VisualDensity.comfortable,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
