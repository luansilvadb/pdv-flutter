import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../providers/cart_provider.dart';
import 'cart/cart_header.dart';
import 'cart/cart_empty_state.dart';
import 'cart/checkout_section.dart';
import 'cart/components/cart_item_card.dart';

/// Painel principal do carrinho de compras
///
/// Orquestra todos os componentes do carrinho incluindo header,
/// lista de itens, estado vazio e seção de checkout.
/// Responsável pela estrutura geral e layout do painel.
class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: 'R\$',
      decimalDigits: 2,
      locale: 'pt_BR',
    );

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          width: AppSizes.cartPanelWidth,
          decoration: _buildPanelDecoration(),
          child: Column(
            children: [
              // Header com informações do pedido
              CartHeader(cartProvider: cartProvider),

              // Conteúdo principal do carrinho
              Expanded(
                child:
                    cartProvider.isEmpty
                        ? const CartEmptyState()
                        : _buildCartItemsList(cartProvider, currencyFormatter),
              ),

              // Seção de checkout (apenas quando há itens)
              if (!cartProvider.isEmpty)
                CheckoutSection(
                  cartProvider: cartProvider,
                  currencyFormatter: currencyFormatter,
                ),
            ],
          ),
        );
      },
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

  /// Constrói a lista de itens do carrinho
  Widget _buildCartItemsList(
    CartProvider cartProvider,
    NumberFormat currencyFormatter,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      itemCount: cartProvider.items.length,
      itemBuilder: (context, index) {
        final item = cartProvider.items[index];
        return CartItemCard(
          item: item,
          cartProvider: cartProvider,
          currencyFormatter: currencyFormatter,
          index: index,
        );
      },
    );
  }
}
