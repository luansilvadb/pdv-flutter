import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/product_provider.dart';
import '../widgets/category_tabs.dart';
import '../widgets/product_card.dart';
import 'package:intl/intl.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background,
                AppColors.background.withValues(alpha: 0.95),
                AppColors.surfaceVariant.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Column(
            children: [
              // Enhanced Header
              _buildEnhancedHeader(context, productProvider),

              // Enhanced Category Tabs
              _buildEnhancedCategorySection(),

              // Enhanced Products Grid
              Expanded(
                child: _buildEnhancedProductsGrid(context, productProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnhancedHeader(
    BuildContext context,
    ProductProvider productProvider,
  ) {
    final now = DateTime.now();
    final dateFormatter = DateFormat('EEEE, d \'de\' MMMM \'de\' y', 'pt_BR');
    final timeFormatter = DateFormat('HH:mm', 'pt_BR');

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceElevated, AppColors.surfaceContainer],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant info and date/time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            FluentIcons.shop,
                            color: AppColors.primaryAccent,
                            size: AppSizes.iconSmall,
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingMedium),
                        Flexible(
                          child: Text(
                            AppConstants.appName,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Menu Principal',
                      style: TextStyle(
                        color: AppColors.primaryAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.paddingLarge),
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surfaceVariant.withValues(alpha: 0.3),
                      AppColors.surfaceVariant.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.calendar,
                          color: AppColors.textSecondary,
                          size: AppSizes.iconSmall,
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        Text(
                          dateFormatter.format(now),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.clock,
                          color: AppColors.primaryAccent,
                          size: AppSizes.iconSmall,
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        Text(
                          timeFormatter.format(now),
                          style: TextStyle(
                            color: AppColors.primaryAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.paddingLarge),

          // Enhanced Search bar
          _buildEnhancedSearchBar(productProvider),
        ],
      ),
    );
  }

  Widget _buildEnhancedSearchBar(ProductProvider productProvider) {
    final searchQuery = productProvider.searchQuery;
    final hasSearchQuery = searchQuery.isNotEmpty;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainer.withValues(alpha: 0.9),
            AppColors.surfaceContainerHigh.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color:
              hasSearchQuery
                  ? AppColors.primaryAccent.withValues(alpha: 0.4)
                  : AppColors.border.withValues(alpha: 0.2),
          width: hasSearchQuery ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color:
                hasSearchQuery
                    ? AppColors.primaryAccent.withValues(alpha: 0.1)
                    : AppColors.shadowLight,
            blurRadius: hasSearchQuery ? 8 : 6,
            offset: const Offset(0, 2),
            spreadRadius: hasSearchQuery ? 0 : -1,
          ),
          if (hasSearchQuery)
            BoxShadow(
              color: AppColors.primaryAccent.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
        ],
      ),
      child: TextBox(
        placeholder: 'Busque por pratos, bebidas ou categorias...',
        onChanged: (value) {
          productProvider.setSearchQuery(value);
        },
        prefix: AnimatedContainer(
          duration: AppSizes.animationMedium,
          padding: const EdgeInsets.only(
            left: AppSizes.paddingLarge,
            right: AppSizes.paddingSmall,
          ),
          child: Icon(
            FluentIcons.search,
            color:
                hasSearchQuery
                    ? AppColors.primaryAccent
                    : AppColors.textTertiary,
            size: AppSizes.iconMedium,
          ),
        ),
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasSearchQuery)
              AnimatedContainer(
                duration: AppSizes.animationMedium,
                margin: const EdgeInsets.only(right: AppSizes.paddingSmall),
                child: IconButton(
                  icon: Icon(
                    FluentIcons.clear,
                    size: AppSizes.iconSmall,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () {
                    productProvider.setSearchQuery('');
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return AppColors.surfaceVariant.withValues(alpha: 0.5);
                      }
                      return Colors.transparent;
                    }),
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.only(right: AppSizes.paddingMedium),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingSmall,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryAccent.withValues(alpha: 0.15),
                    AppColors.primaryAccent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                border: Border.all(
                  color: AppColors.primaryAccent.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '⌘',
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'K',
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.4,
        ),
        placeholderStyle: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildEnhancedCategorySection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceElevated.withValues(alpha: 0.7),
            AppColors.background,
          ],
        ),
      ),
      child: const CategoryTabs(),
    );
  }

  Widget _buildEnhancedProductsGrid(
    BuildContext context,
    ProductProvider productProvider,
  ) {
    final filteredProducts = productProvider.filteredProducts;

    if (filteredProducts.isEmpty) {
      return _buildEnhancedEmptyState(context);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 2.0,
          colors: [
            AppColors.surfaceVariant.withValues(alpha: 0.05),
            AppColors.background,
          ],
        ),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateCrossAxisCount(context),
          childAspectRatio: 0.8,
          crossAxisSpacing: AppSizes.paddingMedium,
          mainAxisSpacing: AppSizes.paddingMedium,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return AnimatedContainer(
            duration: Duration(
              milliseconds:
                  AppSizes.animationMedium.inMilliseconds + (index * 50),
            ),
            curve: Curves.easeOutCubic,
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (AppBreakpoints.isMobile(width)) return 1;
    if (AppBreakpoints.isTablet(width)) return 2;
    if (AppBreakpoints.isDesktop(width)) return 3;
    return 4; // Desktop large
  }

  Widget _buildEnhancedEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.surfaceVariant.withValues(alpha: 0.3),
                      AppColors.surfaceVariant.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  FluentIcons.search,
                  size: 60,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingLarge),
              Text(
                'Nenhum produto encontrado',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              Text(
                'Tente buscar com palavras-chave diferentes\nou navegue pelas categorias',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                  height: 1.4,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingLarge),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMedium,
                  vertical: AppSizes.paddingSmall,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryAccent.withValues(alpha: 0.1),
                      AppColors.primaryAccent.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(
                    color: AppColors.primaryAccent.withValues(alpha: 0.2),
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
                    Flexible(
                      child: Text(
                        'Dica: Use termos como "pizza", "hambúrguer" ou "bebida"',
                        style: TextStyle(
                          color: AppColors.primaryAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.primaryAccent.withValues(alpha: 0.1),
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    AppColors.primaryAccent,
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
                    ),
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMedium,
                      vertical: AppSizes.paddingSmall,
                    ),
                  ),
                ),
                onPressed: () {
                  // Limpar busca
                  context.read<ProductProvider>().setSearchQuery('');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.refresh, size: AppSizes.iconSmall),
                    const SizedBox(width: AppSizes.paddingSmall),
                    Text(
                      'Mostrar todos os produtos',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
