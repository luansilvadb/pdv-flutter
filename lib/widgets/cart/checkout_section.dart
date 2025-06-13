import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/cart/presentation/providers/cart_state.dart';
import '../../features/cart/domain/entities/cart_entity.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';

/// Seção de checkout com totais e botão de finalização - MIGRADO
///
/// Mudanças principais:
/// - ConsumerWidget ao invés de StatelessWidget
/// - Aceita CartState e CartEntity ao invés de CartProvider antigo
/// - Usa CartProvider Riverpod para ações (limpar carrinho)
/// - Calcula totais a partir da CartEntity
/// - Mantém funcionalidade e visual idênticos
///
/// Exibe subtotal, taxa de serviço, total final e botão para
/// finalizar pedido com diálogo de confirmação.
class CheckoutSection extends ConsumerWidget {
  /// Estado atual do carrinho
  final CartState cartState;

  /// Carrinho atual (quando carregado)
  final CartEntity currentCart;

  /// Formatador de moeda
  final NumberFormat currencyFormatter;

  const CheckoutSection({
    super.key,
    required this.cartState,
    required this.currentCart,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MIGRADO: Calcular totais a partir da CartEntity
    final subtotal = currentCart.totalAmount;
    final tax = subtotal * 0.10; // Taxa de serviço 10%
    final total = subtotal + tax;

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
          _buildTotalRow('Subtotal', subtotal, false),
          const SizedBox(height: AppSizes.paddingSmall),
          _buildTotalRow('Taxa de Serviço (10%)', tax, false),
          _buildDivider(),
          _buildTotalRow('Total', total, true),
          const SizedBox(height: AppSizes.paddingLarge),
          _buildCheckoutButton(context, ref, total),
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

  /// Constrói o botão de finalizar pedido - MIGRADO: usar WidgetRef
  Widget _buildCheckoutButton(
    BuildContext context,
    WidgetRef ref,
    double total,
  ) {
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
        onPressed: () => _showCheckoutDialog(context, ref, total),
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

  /// Exibe diálogo de confirmação do pedido - MIGRADO: usar CartEntity
  void _showCheckoutDialog(BuildContext context, WidgetRef ref, double total) {
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
                        'Total do pedido: ${currencyFormatter.format(total)}',
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
                        '${currentCart.itemCount} ${currentCart.itemCount == 1 ? 'item' : 'itens'} no carrinho',
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
                onPressed: () => _confirmOrder(context, ref),
              ),
            ],
          ),
    );
  }
  /// Confirma o pedido e exibe notificação de sucesso - MIGRADO: usar Riverpod + Orders
  void _confirmOrder(BuildContext context, WidgetRef ref) async {
    try {      // Criar o pedido a partir do carrinho
      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
      
      final order = OrderEntity.fromCart(
        id: orderId,
        cartItems: currentCart.items,
        subtotal: currentCart.subtotal,
        tax: currentCart.tax,
        total: currentCart.total,
        paymentMethod: PaymentMethod.cash, // Padrão por enquanto
        customerName: 'Cliente', // Padrão por enquanto
      );

      // Salvar o pedido no histórico
      final success = await ref.read(ordersNotifierProvider.notifier).createOrder(order);
      
      if (success) {
        // MIGRADO: Usar CartProvider Riverpod para limpar carrinho
        ref.read(cartProvider.notifier).clearCart();        if (context.mounted) {
          Navigator.of(context).pop();
          
          displayInfoBar(
            context,
            builder: (context, close) => InfoBar(
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
              content: Text('Pedido #${orderId.substring(orderId.length - 8)} criado com sucesso!'),
              severity: InfoBarSeverity.success,
              onClose: close,
            ),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
          displayInfoBar(
            context,
            builder: (context, close) => InfoBar(
              title: Row(
                children: [
                  Icon(
                    FluentIcons.error,
                    color: AppColors.error,
                    size: AppSizes.iconSmall,
                  ),
                  const SizedBox(width: AppSizes.paddingSmall),
                  const Text('Erro'),
                ],
              ),
              content: const Text('Não foi possível criar o pedido. Tente novamente.'),
              severity: InfoBarSeverity.error,
              onClose: close,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        displayInfoBar(
          context,
          builder: (context, close) => InfoBar(
            title: Row(
              children: [
                Icon(
                  FluentIcons.error,
                  color: AppColors.error,
                  size: AppSizes.iconSmall,
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                const Text('Erro Inesperado'),
              ],
            ),            content: Text('Erro: $e'),
            severity: InfoBarSeverity.error,
            onClose: close,
          ),
        );
      }
    }
  }
}
