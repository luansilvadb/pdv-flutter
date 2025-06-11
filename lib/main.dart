import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/navigation_provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const PDVRestaurantApp());
}

class PDVRestaurantApp extends StatelessWidget {
  const PDVRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: FluentApp(
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
      ),
    );
  }
}
