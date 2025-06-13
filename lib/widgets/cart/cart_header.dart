import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
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
  }  /// Exibe diálogo de confirmação para limpar carrinho - MIGRADO: usar Riverpod
  void _showClearDialog(BuildContext context, WidgetRef ref) {
    final itemCount = currentCart?.itemCount ?? 0;
    
    showDialog(
      context: context,
      barrierDismissible: true,      builder: (context) => ContentDialog(
        title: _buildModalTitle(),
        content: _buildModalContent(itemCount),        actions: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCancelButton(context),
                const SizedBox(width: AppSizes.paddingSmall),
                _buildConfirmButton(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o título do modal com ícone e gradiente
  Widget _buildModalTitle() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.error.withValues(alpha: 0.15),
            AppColors.error.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.error.withValues(alpha: 0.2),
                  AppColors.error.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              FluentIcons.warning,
              color: AppColors.error,
              size: AppSizes.iconMedium,
            ),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Limpar Carrinho',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ação irreversível',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o conteúdo do modal com informações detalhadas
  Widget _buildModalContent(int itemCount) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
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
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mensagem principal
          Row(
            children: [
              Icon(
                FluentIcons.info,
                color: AppColors.textSecondary,
                size: AppSizes.iconSmall,
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Expanded(
                child: Text(
                  'Tem certeza que deseja remover todos os itens do carrinho?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.paddingMedium),
          
          // Informações do carrinho
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(
                    FluentIcons.shopping_cart,
                    color: AppColors.primaryAccent,
                    size: AppSizes.iconSmall,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$itemCount ${itemCount == 1 ? 'item' : 'itens'} no carrinho',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (currentCart != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Total: R\$ ${currentCart!.total.value.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.priceColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.paddingMedium),
          
          // Aviso
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  FluentIcons.blocked2,
                  color: AppColors.warning,
                  size: AppSizes.iconSmall,
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Expanded(
                  child: Text(
                    'Esta ação não pode ser desfeita',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }  /// Constrói o botão de cancelar com estilo aprimorado
  Widget _buildCancelButton(BuildContext context) {
    return Expanded(
      child: Button(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.surfaceContainer;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.surfaceVariant.withValues(alpha: 0.5);
            }
            return AppColors.surfaceVariant.withValues(alpha: 0.3);
          }),
          foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              side: BorderSide(
                color: AppColors.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
          ),
          elevation: WidgetStateProperty.resolveWith<double>((states) {
            if (states.contains(WidgetState.hovered)) {
              return AppElevations.level2;
            }
            return AppElevations.level1;
          }),
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FluentIcons.cancel,
              size: AppSizes.iconSmall,
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            const Flexible(
              child: Text(
                'Cancelar',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }  /// Constrói o botão de confirmar com gradiente e sombra
  Widget _buildConfirmButton(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.error.withValues(alpha: 0.8);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.error.withValues(alpha: 0.9);
            }
            return AppColors.error;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
          ),
          elevation: WidgetStateProperty.resolveWith<double>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppElevations.level1;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppElevations.level3;
            }
            return AppElevations.level2;
          }),
        ),
        onPressed: () {
          // MIGRADO: Usar CartProvider Riverpod para limpar carrinho
          ref.read(cartProvider.notifier).clearCart();
          Navigator.of(context).pop();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FluentIcons.delete,
                size: AppSizes.iconSmall,
                color: Colors.white,
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              const Flexible(
                child: Text(
                  'Limpar Carrinho',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
