import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../providers/printing_providers.dart';
import '../../domain/entities/order_entity.dart';

/// Widget para exibir um card de pedido
class OrderCard extends ConsumerWidget {
  final OrderEntity order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevated,
            AppColors.surfaceContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: _getStatusColor().withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com ID e status
            _buildHeader(),
            
            const SizedBox(height: AppSizes.paddingMedium),
            
            // Informações do pedido
            _buildOrderInfo(),
            
            const SizedBox(height: AppSizes.paddingMedium),
            
            // Itens do pedido (resumo)
            _buildItemsSummary(),
            
            const SizedBox(height: AppSizes.paddingMedium),            // Footer com total e data
            _buildFooter(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ID do pedido
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getStatusColor().withValues(alpha: 0.2),
                    _getStatusColor().withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Icon(
                FluentIcons.receipt_processing,
                color: _getStatusColor(),
                size: 16,
              ),
            ),
            const SizedBox(width: AppSizes.paddingMedium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pedido #${order.id.substring(order.id.length - 8)}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (order.customerName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    order.customerName!,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            border: Border.all(
              color: _getStatusColor().withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            order.status.displayName,
            style: TextStyle(
              color: _getStatusColor(),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Row(
      children: [
        // Método de pagamento
        Expanded(
          child: Row(
            children: [
              Icon(
                _getPaymentIcon(),
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Text(
                order.paymentMethod.displayName,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Número de itens
        Row(
          children: [
            Icon(
              FluentIcons.shopping_cart,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            Text(
              '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'itens'}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemsSummary() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Itens do Pedido',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          
          // Lista de itens (limitada a 3 para não ocupar muito espaço)
          ...order.items.take(3).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Text(
                  '${item.quantity.value}x',
                  style: TextStyle(
                    color: AppColors.primaryAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'R\$ ${item.totalPrice.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )),
          
          // Indicador se há mais itens
          if (order.items.length > 3) ...[
            const SizedBox(height: 4),
            Text(
              '+ ${order.items.length - 3} outros itens',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Data do pedido
            Row(
              children: [
                Icon(
                  FluentIcons.calendar,
                  color: AppColors.textTertiary,
                  size: 14,
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Text(
                  dateFormatter.format(order.createdAt),
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            // Total do pedido
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
                    AppColors.primaryAccent.withValues(alpha: 0.15),
                    AppColors.primaryAccent.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(
                  color: AppColors.primaryAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'R\$ ${order.total.value.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.primaryAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.paddingMedium),
        
        // Botões de ação
        Row(
          children: [            // Botão para imprimir cupom fiscal
            Expanded(
              child: Builder(
                builder: (buttonContext) => FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return AppColors.secondaryAccent.withValues(alpha: 0.8);
                      }
                      if (states.contains(WidgetState.hovered)) {
                        return AppColors.secondaryAccent.withValues(alpha: 0.9);
                      }
                      return AppColors.secondaryAccent;
                    }),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
                    ),
                  ),
                  onPressed: () => _showReceiptPreview(buttonContext, ref),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.print,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: AppSizes.paddingSmall),
                      Text(
                        'Imprimir Cupom',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),                ),
              ),
            ),
          ],
        ),
      ],
    );
  }  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.processing:
        return AppColors.info;
      case OrderStatus.completed:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }  /// Exibe a prévia do cupom fiscal
  void _showReceiptPreview(BuildContext context, WidgetRef ref) {
    ref.read(printingProvider.notifier).printOrderReceiptInBrowser(order);
  }

  IconData _getPaymentIcon() {
    switch (order.paymentMethod) {
      case PaymentMethod.cash:
        return FluentIcons.money;
      case PaymentMethod.credit:
        return FluentIcons.contact_card;
      case PaymentMethod.debit:
        return FluentIcons.payment_card;
      case PaymentMethod.pix:
        return FluentIcons.code;
    }
  }
}
