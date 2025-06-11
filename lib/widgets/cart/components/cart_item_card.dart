import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import '../../../models/order.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/cart_provider.dart';
import 'product_image.dart';
import 'quantity_controls.dart';

/// Card individual para cada item do carrinho
///
/// Combina imagem do produto, informações e controles de quantidade
/// em um layout responsivo e visualmente atraente.
class CartItemCard extends StatelessWidget {
  /// Item do carrinho a ser exibido
  final CartItem item;

  /// Provider do carrinho para interações
  final CartProvider cartProvider;

  /// Formatador de moeda
  final NumberFormat currencyFormatter;

  /// Índice do item na lista (para possíveis animações futuras)
  final int index;

  const CartItemCard({
    super.key,
    required this.item,
    required this.cartProvider,
    required this.currencyFormatter,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainer,
            AppColors.surfaceContainer.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagem do produto - largura fixa
                ProductImage(item: item),

                const SizedBox(width: AppSizes.paddingMedium),

                // Informações do produto - ocupa espaço restante
                Expanded(child: _buildProductInfo()),

                const SizedBox(width: AppSizes.paddingSmall),

                // Controles de quantidade - largura fixa
                QuantityControls(item: item, cartProvider: cartProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói a seção de informações do produto
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.product.name,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          currencyFormatter.format(item.product.price),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Total: ${currencyFormatter.format(item.totalPrice)}',
          style: TextStyle(
            color: AppColors.priceColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
