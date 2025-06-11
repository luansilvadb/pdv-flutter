import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../features/navigation/presentation/providers/navigation_provider.dart';

class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationProvider);
    final selectedIndex = navigationState.selectedIndex;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          // Header simples
          _buildHeader(context),

          // Divisor
          Container(
            height: 1,
            color: AppColors.border,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

          const SizedBox(height: 16),

          // Navigation items
          Expanded(child: _buildNavigationItems(context, ref, selectedIndex)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              FluentIcons.shop,
              color: AppColors.primaryAccent,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PDV Restaurant',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Sistema de Vendas',
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItems(
    BuildContext context,
    WidgetRef ref,
    int selectedIndex,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: AppConstants.navigationItems.length,
      itemBuilder: (context, index) {
        final item = AppConstants.navigationItems[index];
        final isSelected = selectedIndex == index;
        final icon = _getIconForIndex(index);

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _buildNavigationItem(
            context,
            ref,
            item,
            icon,
            index,
            isSelected,
          ),
        );
      },
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
    int index,
    bool isSelected,
  ) {
    return Button(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isSelected) {
            return AppColors.primaryAccent.withValues(alpha: 0.15);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.surfaceContainer;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.surfaceContainerHigh;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isSelected) {
            return AppColors.primaryAccent;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.textPrimary;
          }
          return AppColors.textSecondary;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color:
                  isSelected
                      ? AppColors.primaryAccent.withValues(alpha: 0.3)
                      : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
      onPressed: () {
        ref.read(navigationProvider.notifier).setSelectedIndex(index);
      },
      child: Row(
        children: [
          // Icon
          Icon(
            icon,
            color:
                isSelected ? AppColors.primaryAccent : AppColors.textSecondary,
            size: 20,
          ),

          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color:
                    isSelected
                        ? AppColors.primaryAccent
                        : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
}
