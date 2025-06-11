import 'package:fluent_ui/fluent_ui.dart';
import '../../../models/order.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/cart_provider.dart';

/// Componente reutilizável para controles de quantidade no carrinho
///
/// Fornece botões para incrementar/decrementar quantidade de itens
/// com feedback visual apropriado.
class QuantityControls extends StatelessWidget {
  /// Item do carrinho a ser controlado
  final CartItem item;

  /// Provider do carrinho para executar as ações
  final CartProvider cartProvider;

  const QuantityControls({
    super.key,
    required this.item,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => cartProvider.decrementQuantity(item.product.id),
            color: AppColors.error,
          ),
          _buildQuantityDisplay(),
          _buildQuantityButton(
            icon: FluentIcons.add,
            onPressed: () => cartProvider.incrementQuantity(item.product.id),
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

  /// Constrói o display da quantidade atual
  Widget _buildQuantityDisplay() {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Text(
        '${item.quantity}',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
