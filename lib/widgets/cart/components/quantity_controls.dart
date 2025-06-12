import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/cart/domain/entities/cart_item_entity.dart';
// import '../../../models/order.dart'; // COMENTADO - Model antigo
import '../../../core/constants/app_constants.dart';
import '../../../features/cart/presentation/providers/cart_provider.dart';

/// Componente reutilizável para controles de quantidade no carrinho - MIGRADO
///
/// Mudanças principais:
/// - ConsumerWidget ao invés de StatelessWidget
/// - Usa CartItemEntity ao invés de CartItem antigo
/// - Usa CartProvider Riverpod para ações (incrementar/decrementar)
/// - Acessa productId e quantity diretamente da entity
/// - Remove dependência do CartProvider antigo
/// - Mantém funcionalidade e visual idênticos
///
/// Fornece botões para incrementar/decrementar quantidade de itens
/// com feedback visual apropriado.
class QuantityControls extends ConsumerWidget {
  /// Item do carrinho a ser controlado - MIGRADO: CartItemEntity
  final CartItemEntity item;

  const QuantityControls({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceVariant.withValues(alpha: 0.7),
            AppColors.surfaceVariant.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: FluentIcons.remove,
            // MIGRADO: Usar CartProvider Riverpod para decrementar
            onPressed:
                () => ref
                    .read(cartProvider.notifier)
                    .decrementQuantity(item.productId),
            color: AppColors.error,
          ),
          _buildQuantityDisplay(),
          _buildQuantityButton(
            icon: FluentIcons.add,
            // MIGRADO: Usar CartProvider Riverpod para incrementar
            onPressed:
                () => ref
                    .read(cartProvider.notifier)
                    .incrementQuantity(item.productId),
            color: AppColors.primaryAccent,
          ),
        ],
      ),
    );
  }

  /// Constrói o botão de controle de quantidade
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Button(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return color.withValues(alpha: 0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return color.withValues(alpha: 0.1);
            }
            return Colors.transparent;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  /// Constrói o display da quantidade atual - MIGRADO: CartItemEntity
  Widget _buildQuantityDisplay() {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Text(
        '${item.quantity}', // MIGRADO: usar quantity da CartItemEntity
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
