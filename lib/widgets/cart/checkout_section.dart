import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import '../../constants/app_constants.dart';
import '../../providers/cart_provider.dart';

/// Seção de checkout com totais e botão de finalização
///
/// Exibe subtotal, taxa de serviço, total final e botão para
/// finalizar pedido com diálogo de confirmação.
class CheckoutSection extends StatelessWidget {
  /// Provider do carrinho para acessar valores
  final CartProvider cartProvider;

  /// Formatador de moeda
  final NumberFormat currencyFormatter;

  const CheckoutSection({
    super.key,
    required this.cartProvider,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.surfaceContainer, AppColors.surfaceContainerHigh],
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal', cartProvider.subtotal, false),
          const SizedBox(height: AppSizes.paddingSmall),
          _buildTotalRow('Taxa de Serviço (10%)', cartProvider.tax, false),
          _buildDivider(),
          _buildTotalRow('Total', cartProvider.total, true),
          const SizedBox(height: AppSizes.paddingLarge),
          _buildCheckoutButton(context),
        ],
      ),
    );
  }

  /// Constrói uma linha de total (subtotal, taxa, total)
  Widget _buildTotalRow(String label, double amount, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 17 : 15,
            letterSpacing: 0.3,
          ),
        ),
        Text(
          currencyFormatter.format(amount),
          style: TextStyle(
            color: isTotal ? AppColors.priceColor : AppColors.textSecondary,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 17 : 15,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  /// Constrói o divisor entre subtotais e total
  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.border.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// Constrói o botão de finalizar pedido
  Widget _buildCheckoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryAccentPressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryAccentHover;
            }
            return AppColors.primaryAccent;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
        onPressed: () => _showCheckoutDialog(context),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.print,
                color: Colors.white,
                size: AppSizes.iconMedium,
              ),
              const SizedBox(width: AppSizes.paddingMedium),
              Text(
                'Finalizar Pedido',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Exibe diálogo de confirmação do pedido
  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ContentDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(
                    FluentIcons.print,
                    color: AppColors.primaryAccent,
                    size: AppSizes.iconSmall,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingMedium),
                const Text('Finalizar Pedido'),
              ],
            ),
            content: Container(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FluentIcons.money,
                        color: AppColors.priceColor,
                        size: AppSizes.iconSmall,
                      ),
                      const SizedBox(width: AppSizes.paddingSmall),
                      Text(
                        'Total do pedido: ${currencyFormatter.format(cartProvider.total)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.priceColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingMedium),
                  Row(
                    children: [
                      Icon(
                        FluentIcons.shopping_cart,
                        color: AppColors.textSecondary,
                        size: AppSizes.iconSmall,
                      ),
                      const SizedBox(width: AppSizes.paddingSmall),
                      Text(
                        '${cartProvider.itemCount} ${cartProvider.itemCount == 1 ? 'item' : 'itens'} no carrinho',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              Button(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.primaryAccent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FluentIcons.accept,
                      color: Colors.white,
                      size: AppSizes.iconSmall,
                    ),
                    const SizedBox(width: AppSizes.paddingSmall),
                    const Text('Confirmar Pedido'),
                  ],
                ),
                onPressed: () => _confirmOrder(context),
              ),
            ],
          ),
    );
  }

  /// Confirma o pedido e exibe notificação de sucesso
  void _confirmOrder(BuildContext context) {
    cartProvider.clear();
    Navigator.of(context).pop();
    displayInfoBar(
      context,
      builder:
          (context, close) => InfoBar(
            title: Row(
              children: [
                Icon(
                  FluentIcons.completed,
                  color: AppColors.success,
                  size: AppSizes.iconSmall,
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                const Text('Pedido Finalizado'),
              ],
            ),
            content: const Text('Seu pedido foi processado com sucesso!'),
            severity: InfoBarSeverity.success,
            onClose: close,
          ),
    );
  }
}
