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
      barrierDismissible: true,
      builder: (context) => ContentDialog(
        title: null, // Removendo o título padrão para usar um header customizado
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header customizado com gradiente
            _buildModalHeader(),
            
            const SizedBox(height: AppSizes.paddingLarge),
            
            // Resumo do carrinho com card elevado
            _buildCartSummary(itemCount),
            
            const SizedBox(height: AppSizes.paddingLarge),
            
            // Aviso sobre irreversibilidade
            _buildWarningSection(),
          ],
        ),
        actions: [
          // SizedBox para envolver os botões e evitar o overflow (seguindo as boas práticas)
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Utilizando Expanded com flexFactor para garantir que os botões tenham o mesmo tamanho
                Expanded(
                  child: Button(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingSmall,
                          vertical: AppSizes.paddingSmall,
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return AppColors.surfaceVariant.withValues(alpha: 0.5);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return AppColors.surfaceVariant.withValues(alpha: 0.3);
                        }
                        return AppColors.surfaceVariant.withValues(alpha: 0.1);
                      }),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centraliza o conteúdo
                      children: [
                        Icon(
                          FluentIcons.cancel,
                          size: AppSizes.iconSmall,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        // Flexible para permitir quebra de texto se necessário
                        Flexible(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                
                // Espaçamento entre os botões
                const SizedBox(width: AppSizes.paddingSmall),
                
                // Botão de confirmar com o mesmo tamanho usando Expanded
                Expanded(
                  child: FilledButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingSmall,
                          vertical: AppSizes.paddingSmall,
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return AppColors.error.withValues(alpha: 0.8);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return AppColors.error.withValues(alpha: 0.9);
                        }
                        return AppColors.error;
                      }),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centraliza o conteúdo
                      children: [
                        Icon(
                          FluentIcons.delete,
                          size: AppSizes.iconSmall,
                          color: Colors.white,
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        // Flexible para permitir quebra de texto se necessário
                        Flexible(
                          child: Text(
                            'Limpar Carrinho', 
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // MIGRADO: Usar CartProvider Riverpod para limpar carrinho
                      ref.read(cartProvider.notifier).clearCart();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// Constrói o header customizado do modal
  Widget _buildModalHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
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
          color: AppColors.error.withValues(alpha: 0.3),
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
                  AppColors.error.withValues(alpha: 0.3),
                  AppColors.error,
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              FluentIcons.warning,
              color: Colors.white,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Confirme para remover todos os itens',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o resumo do carrinho
  Widget _buildCartSummary(int itemCount) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Itens no Carrinho',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          
          // Informações do carrinho
          Row(
            children: [
              Icon(
                FluentIcons.shopping_cart,
                color: AppColors.textSecondary,
                size: AppSizes.iconSmall,
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Text(
                '$itemCount ${itemCount == 1 ? 'item' : 'itens'} no carrinho',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          if (currentCart != null) ...[
            const SizedBox(height: AppSizes.paddingSmall),
            Row(
              children: [
                Icon(
                  FluentIcons.money,
                  color: AppColors.textSecondary,
                  size: AppSizes.iconSmall,
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Text(
                  'Subtotal: R\$ ${currentCart!.subtotal.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
              child: Divider(),
            ),
            
            // Total com destaque
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
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
                        AppColors.priceColor.withValues(alpha: 0.2),
                        AppColors.priceColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Text(
                    'R\$ ${currentCart!.total.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppColors.priceColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Constrói a seção de aviso
  Widget _buildWarningSection() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingSmall),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            FluentIcons.blocked2,
            size: AppSizes.iconSmall,
            color: AppColors.warning,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          Text(
            'Esta ação não pode ser desfeita',
            style: TextStyle(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );  }
}
