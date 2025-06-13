import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart'; // COMENTADO - Provider antigo
import 'package:intl/intl.dart';
import '../core/constants/app_constants.dart';
import '../features/cart/presentation/providers/cart_provider.dart';
import '../features/cart/presentation/providers/cart_state.dart';
import 'cart/cart_header.dart';
import 'cart/cart_empty_state.dart';
import 'cart/checkout_section.dart';
import 'cart/components/cart_item_card.dart';

/// Painel principal do carrinho de compras - MIGRADO para Clean Architecture + Riverpod
///
/// Mudanças principais:
/// - Consumer Riverpod ao invés de Provider
/// - Usa CartState ao invés de CartProvider antigo
/// - Integra com nova CartEntity e CartItemEntity
/// - Mantém funcionalidade e layout idênticos
///
/// Orquestra todos os componentes do carrinho incluindo header,
/// lista de itens, estado vazio e seção de checkout.
/// Responsável pela estrutura geral e layout do painel.
class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use apenas o formatador como constante para evitar recalculo
    final currencyFormatter = NumberFormat.currency(
      symbol: 'R\$',
      decimalDigits: 2,
      locale: 'pt_BR',
    );

    // Watching apenas items individuais do estado para reduzir rebuilds desnecessários
    // Usa select() para escutar apenas partes específicas do estado
    final cartState = ref.watch(cartProvider);
    // Já que currentCartProvider é uma derivação mais específica, 
    // tem menos chance de causar rebuilds desnecessários
    final currentCart = ref.watch(currentCartProvider);

    return Container(
      width: AppSizes.cartPanelWidth,
      decoration: _buildPanelDecoration(),
      child: Column(
        children: [
          // Header com informações do pedido - MIGRADO: passar state ao invés de provider
          CartHeader(cartState: cartState, currentCart: currentCart),

          // Conteúdo principal do carrinho
          Expanded(
            child: _buildCartContent(cartState, currentCart, currencyFormatter),
          ),

          // Seção de checkout (apenas quando há itens)
          if (currentCart != null && currentCart.isNotEmpty)
            CheckoutSection(
              cartState: cartState,
              currentCart: currentCart,
              currencyFormatter: currencyFormatter,
            ),
        ],
      ),
    );
  }

  /// Constrói o conteúdo principal baseado no estado do carrinho
  Widget _buildCartContent(
    CartState cartState,
    dynamic currentCart,
    NumberFormat currencyFormatter,
  ) {
    // Loading state
    if (cartState is CartLoading) {
      return _buildLoadingState();
    }

    // Error state
    if (cartState is CartError) {
      return _buildErrorState(cartState.message);
    }

    // Empty cart
    if (currentCart == null || currentCart.isEmpty) {
      return const CartEmptyState();
    }

    // Cart with items
    return _buildCartItemsList(currentCart, currencyFormatter);
  }

  /// Constrói estado de loading
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressRing(strokeWidth: 3, activeColor: AppColors.primaryAccent),
          const SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Carregando carrinho...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Constrói estado de erro
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.error_badge, size: 48, color: AppColors.error),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Erro ao carregar carrinho',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              message,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói a decoração do painel do carrinho
  BoxDecoration _buildPanelDecoration() {
    return BoxDecoration(
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
        left: BorderSide(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 16,
          offset: const Offset(-4, 0),
        ),
      ],
    );
  }

  /// Constrói a lista de itens do carrinho - MIGRADO: usar CartEntity
  Widget _buildCartItemsList(dynamic cart, NumberFormat currencyFormatter) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return CartItemCard(
          item: item, // MIGRADO: CartItemEntity ao invés de CartItem antigo
          currencyFormatter: currencyFormatter,
          index: index,
        );
      },
    );
  }
}
