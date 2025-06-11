import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_constants.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/cart/presentation/providers/cart_state.dart';
import '../../features/cart/domain/entities/cart_entity.dart';

/// Header do painel de carrinho com informações do pedido e botão de limpar - MIGRADO
///
/// Mudanças principais:
/// - ConsumerWidget ao invés de StatelessWidget
/// - Aceita CartState e CartEntity ao invés de CartProvider antigo
/// - Usa CartProvider Riverpod para ações (limpar carrinho)
/// - Mantém funcionalidade e visual idênticos
///
/// Exibe o título do painel, contador de itens e botão para limpar carrinho
/// quando há itens presentes.
class CartHeader extends ConsumerWidget {
  /// Estado atual do carrinho
  final CartState cartState;

  /// Carrinho atual (quando carregado)
  final CartEntity? currentCart;

  const CartHeader({
    super.key,
    required this.cartState,
    required this.currentCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if (currentCart != null && currentCart!.isNotEmpty)
            _buildClearButton(context, ref),
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

  /// Constrói as informações do carrinho (título e contador) - MIGRADO
  Widget _buildCartInfo() {
    final itemCount = currentCart?.itemCount ?? 0;

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
          '$itemCount ${itemCount == 1 ? 'item' : 'itens'}',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Constrói o botão para limpar carrinho - MIGRADO: usar Riverpod
  Widget _buildClearButton(BuildContext context, WidgetRef ref) {
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
        onPressed: () => _showClearDialog(context, ref),
        child: Icon(
          FluentIcons.delete,
          color: AppColors.error,
          size: AppSizes.iconSmall,
        ),
      ),
    );
  }

  /// Exibe diálogo de confirmação para limpar carrinho - MIGRADO: usar Riverpod
  void _showClearDialog(BuildContext context, WidgetRef ref) {
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
                  // MIGRADO: Usar CartProvider Riverpod para limpar carrinho
                  ref.read(cartProvider.notifier).clearCart();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }
}
