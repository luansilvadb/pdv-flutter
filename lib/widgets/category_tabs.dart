import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart'; // COMENTADO - Provider antigo
import '../features/products/domain/entities/category_entity.dart';

import '../core/constants/app_constants.dart';
import '../features/products/presentation/providers/category_provider.dart';
import '../features/products/presentation/providers/products_provider.dart';

/// Widget de tabs de categorias - MIGRADO para Clean Architecture + Riverpod
///
/// Mudanças principais:
/// - ConsumerStatefulWidget ao invés de StatefulWidget com Provider
/// - Usa CategoryProvider e ProductsProvider Riverpod
/// - Integra com CategoryEntity ao invés de enum direto
/// - Usa providers para contagem de produtos por categoria
/// - Mantém funcionalidade e visual idênticos
class CategoryTabs extends ConsumerStatefulWidget {
  const CategoryTabs({super.key});

  @override
  ConsumerState<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends ConsumerState<CategoryTabs>
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
    // MIGRADO: Usar Consumer Riverpod para escutar mudanças
    final categories = ref.watch(categoriesListProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final productsState = ref.watch(productsNotifierProvider);

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
              padding: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
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
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
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
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Text(
                      // MIGRADO: Contar produtos do estado Riverpod
                      '${_getFilteredProductsCount(productsState, selectedCategoryId)} itens',
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

            // Category buttons - MIGRADO: usar CategoryEntity
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Botão "Todos" (nenhuma categoria selecionada)
                  Padding(
                    padding: const EdgeInsets.only(
                      right: AppSizes.paddingMedium,
                    ),
                    child: _buildAllCategoriesButton(selectedCategoryId),
                  ),
                  // Botões das categorias
                  ...categories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final category = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        right:
                            index < categories.length - 1
                                ? AppSizes.paddingMedium
                                : 0,
                      ),
                      child: _buildEnhancedCategoryButton(
                        category,
                        index + 1, // +1 porque "Todos" é index 0
                        selectedCategoryId,
                        productsState,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói botão "Todos" para mostrar todas as categorias
  Widget _buildAllCategoriesButton(String? selectedCategoryId) {
    final isSelected = selectedCategoryId == null;
    final productsState = ref.watch(productsNotifierProvider);
    final allProductsCount = _getFilteredProductsCount(productsState, null);

    return AnimatedContainer(
      duration: Duration(milliseconds: AppSizes.animationMedium.inMilliseconds),
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
        ),        onPressed: () {
          // MIGRADO: Usar CategoryProvider Riverpod para limpar seleção
          // Força atualização para "Todos" mesmo se já está selecionado
          ref
              .read(categoriesNotifierProvider.notifier)
              .forceShowAll();
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
                  FluentIcons.all_apps,
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
                    'Todos',
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
                    '$allProductsCount ${allProductsCount == 1 ? 'item' : 'itens'}',
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

  Widget _buildEnhancedCategoryButton(
    CategoryEntity category,
    int index,
    String? selectedCategoryId,
    dynamic productsState,
  ) {
    final isSelected = selectedCategoryId == category.id;
    final productCount = _getProductCountForCategory(
      productsState,
      category.id,
    );

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
        ),        onPressed: () {
          // MIGRADO: Usar CategoryProvider Riverpod para selecionar categoria
          // Força atualização mesmo se for a mesma categoria
          ref
              .read(categoriesNotifierProvider.notifier)
              .forceSelectCategory(category.id);
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
                  _getIconForCategory(
                    category.name,
                  ), // MIGRADO: usar name da CategoryEntity
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
                    category.name, // MIGRADO: usar name da CategoryEntity
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

  // TEMPORÁRIO: Mapear nomes das categorias para enum ProductCategory
  IconData _getIconForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'hambúrgueres':
      case 'burgers':
        return FluentIcons.shop;
      case 'massas':
      case 'noodles':
        return FluentIcons.cafe;
      case 'bebidas':
      case 'drinks':
        return FluentIcons.coffee_script;
      case 'sobremesas':
      case 'desserts':
        return FluentIcons.cake;
      default:
        return FluentIcons.shop;
    }
  }

  /// Conta produtos por categoria - MIGRADO: usar estado Riverpod
  int _getProductCountForCategory(dynamic productsState, String categoryId) {
    if (productsState.products.isEmpty) return 0;

    return productsState.products
        .where((product) => product.categoryId == categoryId)
        .length;
  }

  /// Conta produtos filtrados - MIGRADO: usar estado Riverpod
  int _getFilteredProductsCount(
    dynamic productsState,
    String? selectedCategoryId,
  ) {
    if (productsState.products.isEmpty) return 0;

    if (selectedCategoryId == null) {
      return productsState.products.length;
    }

    return productsState.products
        .where((product) => product.categoryId == selectedCategoryId)
        .length;
  }
}
