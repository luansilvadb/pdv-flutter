import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../constants/app_constants.dart';
import '../providers/product_provider.dart';

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: AppSizes.animationMedium,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.all(AppSizes.paddingLarge),
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.surfaceElevated, AppColors.surfaceContainer],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and title
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppSizes.paddingMedium,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryAccent.withValues(alpha: 0.2),
                              AppColors.primaryAccent.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSmall,
                          ),
                        ),
                        child: Icon(
                          FluentIcons.filter,
                          color: AppColors.primaryAccent,
                          size: AppSizes.iconSmall,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingMedium),
                      Text(
                        'Categorias',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSmall,
                          ),
                        ),
                        child: Text(
                          '${productProvider.filteredProducts.length} itens',
                          style: TextStyle(
                            color: AppColors.primaryAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Category buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        ProductCategory.values.asMap().entries.map((entry) {
                          final index = entry.key;
                          final category = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(
                              right:
                                  index < ProductCategory.values.length - 1
                                      ? AppSizes.paddingMedium
                                      : 0,
                            ),
                            child: _buildEnhancedCategoryButton(
                              productProvider,
                              category,
                              index,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedCategoryButton(
    ProductProvider productProvider,
    ProductCategory category,
    int index,
  ) {
    final isSelected = productProvider.selectedCategory == category;
    final productCount = productProvider.getProductCountForCategory(category);

    return AnimatedContainer(
      duration: Duration(
        milliseconds: AppSizes.animationMedium.inMilliseconds + (index * 100),
      ),
      curve: Curves.easeOutCubic,
      child: Button(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (isSelected) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primaryAccentPressed;
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primaryAccentHover;
              }
              return AppColors.primaryAccent;
            } else {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.overlayMedium;
              }
              return Colors.transparent;
            }
          }),
          foregroundColor: WidgetStateProperty.all(
            isSelected ? Colors.white : AppColors.textSecondary,
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
              vertical: 12,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
          ),
          elevation: WidgetStateProperty.resolveWith<double>((states) {
            if (isSelected) {
              if (states.contains(WidgetState.pressed)) {
                return AppElevations.level1;
              }
              if (states.contains(WidgetState.hovered)) {
                return AppElevations.level4;
              }
              return AppElevations.level2;
            }
            return AppElevations.level0;
          }),
        ),
        onPressed: () {
          productProvider.setSelectedCategory(category);
        },
        child: Container(
          decoration:
              isSelected
                  ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  )
                  : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Enhanced icon with background
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.white.withValues(alpha: 0.2)
                          : AppColors.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Icon(
                  _getIconForCategory(category),
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSizes.paddingMedium),

              // Category name and count
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.localizedDisplayName,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$productCount ${productCount == 1 ? 'item' : 'itens'}',
                    style: TextStyle(
                      color:
                          isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textTertiary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Selection indicator
              if (isSelected) ...[
                const SizedBox(width: AppSizes.paddingSmall),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(ProductCategory category) {
    switch (category) {
      case ProductCategory.burger:
        return FluentIcons.shop;
      case ProductCategory.noodles:
        return FluentIcons.cafe;
      case ProductCategory.drinks:
        return FluentIcons.coffee_script;
      case ProductCategory.desserts:
        return FluentIcons.cake;
    }
  }
}
