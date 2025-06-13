import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../features/navigation/presentation/providers/navigation_provider.dart';
import '../features/navigation/presentation/providers/navigation_state.dart';
import '../features/cart/presentation/providers/cart_provider.dart';
import '../screens/menu_screen.dart';
import '../widgets/cart_panel.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Inicializar o carrinho assim que a tela principal carregar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = ref.watch(navigationProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.95),
            AppColors.surfaceVariant.withValues(alpha: 0.3),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: Row(        children: [
          // Enhanced Sidebar
          _buildModernSidebar(navigationState),

          // Main content
          Expanded(child: _buildMainContent(navigationState)),
        ],
      ),
    );
  }

  Widget _buildModernSidebar(NavigationState navigationState) {
    return Container(
      width: AppSizes.sidebarWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceElevated,
            AppColors.surfaceElevated.withValues(alpha: 0.95),
            AppColors.surfaceContainer,
          ],
        ),
        border: Border(
          right: BorderSide(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Header
          _buildSidebarHeader(),

          // Elegant Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),          // Navigation Items
          Expanded(child: _buildNavigationItems(navigationState)),

          // Branding Footer
          _buildBrandingFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryAccent, AppColors.primaryAccentHover],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              FluentIcons.shop,
              color: Colors.white,
              size: AppSizes.iconMedium,
            ),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PDV Restaurant',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Professional',
                  style: TextStyle(
                    color: AppColors.primaryAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItems(NavigationState navigationState) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      children:
          AppConstants.navigationItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = navigationState.selectedIndex == index;

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: AnimatedContainer(
                duration: AppSizes.animationMedium,
                curve: Curves.easeOutCubic,
                child: Button(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMedium,
                        vertical: 14,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (isSelected) {
                        return AppColors.primaryAccent.withValues(alpha: 0.15);
                      }
                      if (states.contains(WidgetState.hovered)) {
                        return AppColors.overlayMedium;
                      }
                      return Colors.transparent;
                    }),
                    foregroundColor: WidgetStateProperty.all(
                      isSelected
                          ? AppColors.primaryAccent
                          : AppColors.textSecondary,
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(navigationProvider.notifier)
                        .setSelectedIndex(index);
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primaryAccent.withValues(
                                    alpha: 0.2,
                                  )
                                  : AppColors.surfaceVariant.withValues(
                                    alpha: 0.3,
                                  ),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSmall,
                          ),
                        ),
                        child: Icon(
                          _getIconForIndex(index),
                          size: AppSizes.iconSmall,
                          color:
                              isSelected
                                  ? AppColors.primaryAccent
                                  : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingMedium),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildBrandingFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        children: [
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Text(
                'Sistema Online',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(NavigationState navigationState) {
    switch (navigationState.selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return _buildMenuWithCart(); // AQUI ESTÁ A CORREÇÃO!
      case 2:
        return _buildHistoryScreen();
      case 3:
        return _buildPromosScreen();
      case 4:
        return _buildSettingsScreen();
      default:
        return _buildMenuWithCart();
    }
  }

  // NOVA FUNÇÃO QUE INCLUI O CARTPANEL
  Widget _buildMenuWithCart() {
    return Row(
      children: [
        // Menu Screen expandido
        const Expanded(child: MenuScreen()),
        // Cart Panel
        const CartPanel(),
      ],
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return FluentIcons.home;
      case 1:
        return FluentIcons.shop;
      case 2:
        return FluentIcons.history;
      case 3:
        return FluentIcons.emoji;
      case 4:
        return FluentIcons.settings;
      default:
        return FluentIcons.more;
    }
  }

  Widget _buildHomeScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [
            AppColors.surfaceVariant.withValues(alpha: 0.1),
            AppColors.background,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surfaceElevated,
                    AppColors.surfaceContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                FluentIcons.home,
                size: 64,
                color: AppColors.primaryAccent,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXLarge),
            Text(
              'Bem-vindo ao Lorem Restaurant',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Navegue para o Menu para começar a fazer pedidos',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXLarge),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                border: Border.all(
                  color: AppColors.primaryAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FluentIcons.lightbulb,
                    color: AppColors.primaryAccent,
                    size: AppSizes.iconSmall,
                  ),
                  const SizedBox(width: AppSizes.paddingSmall),
                  Text(
                    'Sistema PDV Professional',
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryScreen() {
    return _buildFeatureScreen(
      FluentIcons.history,
      'Histórico de Pedidos',
      'Visualize pedidos anteriores aqui',
      AppColors.secondaryAccent,
    );
  }

  Widget _buildPromosScreen() {
    return _buildFeatureScreen(
      FluentIcons.emoji,
      'Promoções',
      'Gerencie ofertas promocionais',
      AppColors.tertiaryAccent,
    );
  }

  Widget _buildSettingsScreen() {
    return _buildFeatureScreen(
      FluentIcons.settings,
      'Configurações',
      'Configure as definições da aplicação',
      AppColors.info,
    );
  }

  Widget _buildFeatureScreen(
    IconData icon,
    String title,
    String subtitle,
    Color accentColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [accentColor.withValues(alpha: 0.05), AppColors.background],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surfaceElevated,
                    AppColors.surfaceContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, size: 64, color: accentColor),
            ),
            const SizedBox(height: AppSizes.paddingXLarge),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXLarge),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                border: Border.all(color: accentColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FluentIcons.info,
                    color: accentColor,
                    size: AppSizes.iconSmall,
                  ),
                  const SizedBox(width: AppSizes.paddingSmall),
                  Text(
                    'Em desenvolvimento',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
