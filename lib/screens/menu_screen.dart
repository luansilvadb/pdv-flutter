import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../features/products/presentation/providers/products_provider.dart';
import '../features/products/presentation/providers/category_provider.dart';
import '../widgets/category_tabs.dart';
import '../widgets/product_card.dart';
import 'package:intl/intl.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  bool _hasInitialized = false;
  // Controlador para manter o estado de scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Carrega os produtos e categorias apenas uma vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        // Use um AutoDispose provider para produtos e categorias para
        // que sejam mantidos enquanto a tela estiver visível
        ref.read(productsNotifierProvider.notifier).loadAvailableProducts();
        ref.read(categoriesNotifierProvider.notifier).loadCategories();
        _hasInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsListProvider);
    final isLoading = ref.watch(isLoadingProductsProvider);
    final error = ref.watch(productsErrorProvider);    // React to category selection changes - forçar reload para corrigir bug
    ref.listen<String?>(selectedCategoryIdProvider, (previous, next) {
      // Sempre executa o carregamento, independente se mudou ou não
      // Isso corrige o bug de categoria não funcionar após voltar de "Todos"
      if (next == null) {
        // Se nenhuma categoria selecionada (botão "Todos"), carrega todos os produtos
        ref.read(productsNotifierProvider.notifier).loadAvailableProducts();
      } else {
        // Se categoria selecionada, filtra produtos por categoria
        ref.read(productsNotifierProvider.notifier).loadProductsByCategory(next);
      }
    });

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
        children: [          // Enhanced Header
          _buildEnhancedHeader(context, ref),

          // Enhanced Category Tabs
          _buildEnhancedCategorySection(),

          // Quick Filters for search
          _buildQuickFilters(ref),

          // Enhanced Products Grid - sem loading bloqueante
          Expanded(
            child: _buildContent(context, ref, products, isLoading, error),          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List products,
    bool isLoading,
    String? error,
  ) {
    // Se há erro, sempre mostra o erro
    if (error != null) {
      return _buildErrorState(error);
    }

    // Se está carregando E não há produtos ainda, mostra loading
    if (isLoading && products.isEmpty) {
      return const Center(child: ProgressRing());
    }

    // Se não há produtos (e não está carregando), mostra estado vazio
    if (products.isEmpty) {
      return _buildEnhancedEmptyState(context, ref);
    }

    // Sempre mostra produtos se existem, mesmo durante loading
    return Stack(
      children: [
        _buildProductsGrid(products),
        // Indicador sutil de loading no canto superior direito
        if (isLoading)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: ProgressRing(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Atualizando...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FluentIcons.error, size: 64, color: AppColors.error),
          const SizedBox(height: AppSizes.paddingLarge),
          Text(
            'Erro ao carregar produtos',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          Text(
            error,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(BuildContext context, WidgetRef ref) {
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
          _buildEnhancedSearchBar(ref),
        ],
      ),
    );
  }

  Widget _buildEnhancedSearchBar(WidgetRef ref) {
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
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: -1,
          ),
        ],
      ),
      child: TextBox(
        placeholder: 'Busque por pratos, bebidas ou categorias...',
        onChanged: (value) {
          ref.read(productsNotifierProvider.notifier).searchProducts(value);
        },
        prefix: AnimatedContainer(
          duration: AppSizes.animationMedium,
          padding: const EdgeInsets.only(
            left: AppSizes.paddingLarge,
            right: AppSizes.paddingSmall,
          ),
          child: Icon(
            FluentIcons.search,
            color: AppColors.textTertiary,
            size: AppSizes.iconMedium,
          ),
        ),
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
        cursorColor: AppColors.primaryAccent,
        cursorWidth: 2.0,
        autofocus: false,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: null,
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

  // Método otimizado para construir o grid de produtos
  Widget _buildProductsGrid(List products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular número de colunas com base na largura disponível
        final double itemWidth = 200; // Largura desejada para cada item
        final int crossAxisCount = (constraints.maxWidth / itemWidth).floor();
        
        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount > 0 ? crossAxisCount : 1,
            childAspectRatio: 0.7,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          // Usar valor de key único para cada produto para manter estado dos widgets
          // Isso evita reconstruções desnecessárias e melhora bastante a performance
          itemBuilder: (context, index) => ProductCard(
            product: products[index],
            key: ValueKey('product-${products[index].id}'),
          ),
          itemCount: products.length,
          // Usar AlwaysScrollableScrollPhysics para melhorar a experiência de scroll
          physics: const AlwaysScrollableScrollPhysics(),
          // Usar cache para os itens que saem da tela
          cacheExtent: 500,
        );
      }
    );
  }

  Widget _buildEnhancedEmptyState(BuildContext context, WidgetRef ref) {
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
                  // Carregar todos os produtos
                  ref
                      .read(productsNotifierProvider.notifier)
                      .loadAvailableProducts();
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
          ),        ),
      ),
    );
  }

  Widget _buildQuickFilters(WidgetRef ref) {
    // Busca será implementada em versões futuras state
    return const SizedBox.shrink();
  }
}
