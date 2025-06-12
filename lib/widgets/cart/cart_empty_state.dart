import 'package:fluent_ui/fluent_ui.dart';
import '../../core/constants/app_constants.dart';

/// Estado vazio do carrinho com orientações para o usuário
///
/// Exibe uma interface amigável quando o carrinho está vazio,
/// orientando o usuário a adicionar itens do menu.
class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.paddingXLarge),
            _buildEmptyIcon(),
            const SizedBox(height: AppSizes.paddingLarge),
            _buildEmptyTitle(),
            const SizedBox(height: AppSizes.paddingMedium),
            _buildEmptyDescription(),
            const SizedBox(height: AppSizes.paddingLarge),
            _buildHintBadge(),
            const SizedBox(height: AppSizes.paddingXLarge),
          ],
        ),
      ),
    );
  }

  /// Constrói o ícone decorativo para estado vazio
  Widget _buildEmptyIcon() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            AppColors.surfaceVariant.withValues(alpha: 0.3),
            AppColors.surfaceVariant.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
      ),
      child: Icon(
        FluentIcons.shopping_cart,
        size: 56,
        color: AppColors.textTertiary,
      ),
    );
  }

  /// Constrói o título do estado vazio
  Widget _buildEmptyTitle() {
    return Text(
      'Carrinho vazio',
      style: TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Constrói a descrição do estado vazio
  Widget _buildEmptyDescription() {
    return Text(
      'Adicione itens do menu\npara começar seu pedido',
      style: TextStyle(
        color: AppColors.textTertiary,
        fontSize: 14,
        height: 1.4,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Constrói o badge com dica para o usuário
  Widget _buildHintBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FluentIcons.lightbulb,
            color: AppColors.primaryAccent,
            size: AppSizes.iconSmall,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          Text(
            'Navegue pelo menu',
            style: TextStyle(
              color: AppColors.primaryAccent,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
