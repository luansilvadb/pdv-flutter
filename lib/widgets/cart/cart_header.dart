import 'package:fluent_ui/fluent_ui.dart';
import '../../constants/app_constants.dart';
import '../../providers/cart_provider.dart';

/// Header do painel de carrinho com informações do pedido e botão de limpar
///
/// Exibe o título do painel, contador de itens e botão para limpar carrinho
/// quando há itens presentes.
class CartHeader extends StatelessWidget {
  /// Provider do carrinho para acessar informações
  final CartProvider cartProvider;

  const CartHeader({super.key, required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceContainer, AppColors.surfaceContainerHigh],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildCartIcon(),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(child: _buildCartInfo()),
          if (!cartProvider.isEmpty) _buildClearButton(context),
        ],
      ),
    );
  }

  /// Constrói o ícone decorativo do carrinho
  Widget _buildCartIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryAccent.withValues(alpha: 0.2),
            AppColors.primaryAccent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Icon(
        FluentIcons.shopping_cart,
        color: AppColors.primaryAccent,
        size: AppSizes.iconMedium,
      ),
    );
  }

  /// Constrói as informações do carrinho (título e contador)
  Widget _buildCartInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pedido Atual',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${cartProvider.itemCount} ${cartProvider.itemCount == 1 ? 'item' : 'itens'}',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Constrói o botão para limpar carrinho
  Widget _buildClearButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Button(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.error.withValues(alpha: 0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.error.withValues(alpha: 0.1);
            }
            return Colors.transparent;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
          ),
        ),
        onPressed: () => _showClearDialog(context),
        child: Icon(
          FluentIcons.delete,
          color: AppColors.error,
          size: AppSizes.iconSmall,
        ),
      ),
    );
  }

  /// Exibe diálogo de confirmação para limpar carrinho
  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ContentDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(
                    FluentIcons.warning,
                    color: AppColors.error,
                    size: AppSizes.iconSmall,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingMedium),
                const Text('Limpar Carrinho'),
              ],
            ),
            content: const Text(
              'Tem certeza que deseja remover todos os itens do carrinho? Esta ação não pode ser desfeita.',
            ),
            actions: [
              Button(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(AppColors.error),
                ),
                child: const Text('Limpar Carrinho'),
                onPressed: () {
                  cartProvider.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }
}
