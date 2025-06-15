import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../features/cart/domain/entities/cart_item_entity.dart';
import '../../../core/constants/app_constants.dart';
import 'product_image.dart';
import 'quantity_controls.dart';

/// Card individual para cada item do carrinho - MIGRADO
///
/// Mudanças principais:
/// - ConsumerWidget ao invés de StatelessWidget
/// - Usa CartItemEntity ao invés de CartItem antigo
/// - Remove dependência do CartProvider (widgets filhos lidam com ações)
/// - Acessa propriedades diretamente da CartItemEntity
/// - Mantém funcionalidade e visual idênticos
///
/// Combina imagem do produto, informações e controles de quantidade
/// em um layout responsivo e visualmente atraente.
class CartItemCard extends ConsumerWidget {
  /// Item do carrinho a ser exibido - MIGRADO: CartItemEntity
  final CartItemEntity item;

  /// Formatador de moeda
  final NumberFormat currencyFormatter;

  /// Índice do item na lista (para possíveis animações futuras)
  final int index;

  const CartItemCard({
    super.key,
    required this.item,
    required this.currencyFormatter,
    required this.index,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingSmall), // Reduzido de paddingMedium
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainer,
            AppColors.surfaceContainer.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall), // Reduzido de radiusMedium
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4, // Reduzido de 8
            offset: const Offset(0, 2), // Reduzido de (0, 4)
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall), // Reduzido de radiusMedium
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingSmall), // Reduzido de paddingMedium
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagem do produto - versão compacta
                ProductImage(
                  item: item,
                  width: 40, // Reduzido de 56
                  height: 40, // Reduzido de 56
                ),

                const SizedBox(width: AppSizes.paddingSmall), // Reduzido de paddingMedium

                // Informações do produto - ocupa espaço restante
                Expanded(child: _buildProductInfo()),

                const SizedBox(width: 4), // Reduzido de paddingSmall

                // Controles de quantidade - largura fixa - MIGRADO: remover cartProvider
                QuantityControls(item: item),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /// Constrói a seção de informações do produto - MIGRADO: CartItemEntity (versão compacta)
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.productName, // MIGRADO: usar productName da CartItemEntity
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13, // Reduzido de 14
            letterSpacing: 0.2, // Reduzido de 0.3
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2), // Reduzido de 6
        Text(
          currencyFormatter.format(
            item.productPrice,
          ), // MIGRADO: usar productPrice da CartItemEntity
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10, // Reduzido de 11
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 1), // Reduzido de 2
        Text(
          'Total: ${currencyFormatter.format(item.subtotal)}', // MIGRADO: usar subtotal da CartItemEntity
          style: TextStyle(
            color: AppColors.priceColor,
            fontWeight: FontWeight.bold,
            fontSize: 11, // Reduzido de 12
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
