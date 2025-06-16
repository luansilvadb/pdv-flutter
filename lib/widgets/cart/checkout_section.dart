import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/cart/presentation/providers/cart_state.dart';
import '../../features/cart/domain/entities/cart_entity.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';
import '../../features/printing/presentation/providers/printing_queue_provider.dart';
import '../../shared/presentation/widgets/custom_toast.dart';

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
class CheckoutSection extends ConsumerStatefulWidget {
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
  ConsumerState<CheckoutSection> createState() => _CheckoutSectionState();
}

class _CheckoutSectionState extends ConsumerState<CheckoutSection> {
  // Controle de concorrência e debounce
  bool _isProcessing = false;
  DateTime? _lastOrderTime;

  @override
  Widget build(BuildContext context) {
    // final ref = this.ref; // Removido: não está mais em uso
    // MIGRADO: Usar os totais já calculados da CartEntity
    final subtotal = widget.currentCart.subtotal.value; // Subtotal com descontos aplicados
    final tax = widget.currentCart.tax.value; // Taxa já calculada
    final total = widget.currentCart.total.value; // Total já calculado

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
          _buildCheckoutButton(context, total),
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
        ),        Text(
          widget.currencyFormatter.format(amount),
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
    double total,
  ) {
    final isDisabled = _isProcessing || (_lastOrderTime != null && DateTime.now().difference(_lastOrderTime!) < const Duration(seconds: 2));
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (isDisabled) return AppColors.surfaceVariant.withValues(alpha: 0.3);
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
        onPressed: isDisabled ? null : () => _showCheckoutDialog(context, ref, total),
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
    );
  }  /// Exibe diálogo de confirmação do pedido - MIGRADO: usar CartEntity
  void _showCheckoutDialog(BuildContext context, WidgetRef ref, double total) {
    String selectedPaymentMethod = 'Dinheiro'; // Estado local do dialog - movido para fora
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          
          return ContentDialog(
        title: null, // Removendo o título padrão para usar um header customizado
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header customizado com gradiente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
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
                          AppColors.primaryAccent.withValues(alpha: 0.3),
                          AppColors.primaryAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryAccent.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      FluentIcons.payment_card,
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
                          'Finalizar Pedido',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Confirme os detalhes para concluir',
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
            ),
            
            const SizedBox(height: AppSizes.paddingLarge),
            
            // Resumo do pedido com card elevado
            Container(
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
                    'Resumo do Pedido',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),                  const SizedBox(height: AppSizes.paddingMedium),
                  
                  // Detalhes do pedido
                  _buildDetailRow(
                    FluentIcons.shopping_cart,
                    '${widget.currentCart.itemCount} ${widget.currentCart.itemCount == 1 ? 'item' : 'itens'} no carrinho',
                    AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),
                  _buildDetailRow(
                    FluentIcons.money,
                    'Subtotal: ${widget.currencyFormatter.format(widget.currentCart.subtotal.value)}',
                    AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),                  _buildDetailRow(
                    FluentIcons.calculator_multiply,
                    'Taxa (10%): ${widget.currencyFormatter.format(widget.currentCart.tax.value)}',
                    AppColors.textSecondary,
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
                              AppColors.primaryAccent.withValues(alpha: 0.2),
                              AppColors.primaryAccent.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                        child:                        Text(
                          widget.currencyFormatter.format(total),
                          style: TextStyle(
                            color: AppColors.primaryAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.paddingLarge),            // Métodos de pagamento (simulação para design)
            Text(
              'Forma de Pagamento',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppSizes.paddingSmall),            // Dinheiro
            _buildDialogPaymentOption(
              'Dinheiro',
              FluentIcons.money,
              AppColors.success,
              selectedPaymentMethod == 'Dinheiro',
              (value) {
                setDialogState(() {
                  selectedPaymentMethod = 'Dinheiro';
                });
              },
            ),
            
            const SizedBox(height: AppSizes.paddingSmall),
            
            // Cartão de Crédito
            _buildDialogPaymentOption(
              'Cartão de Crédito',
              FluentIcons.payment_card,
              AppColors.secondaryAccent,
              selectedPaymentMethod == 'Cartão de Crédito',
              (value) {
                setDialogState(() {
                  selectedPaymentMethod = 'Cartão de Crédito';
                });
              },
            ),
            
            const SizedBox(height: AppSizes.paddingSmall),
            
            // PIX
            _buildDialogPaymentOption(
              'PIX',
              FluentIcons.code,
              AppColors.primaryAccent,
              selectedPaymentMethod == 'PIX',
              (value) {
                setDialogState(() {
                  selectedPaymentMethod = 'PIX';
                });              },
            ),
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
                          return AppColors.primaryAccentPressed;
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return AppColors.primaryAccentHover;
                        }
                        return AppColors.primaryAccent;
                      }),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centraliza o conteúdo
                      children: [
                        Icon(
                          FluentIcons.check_mark,
                          size: AppSizes.iconSmall,
                          color: Colors.white,
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        // Flexible para permitir quebra de texto se necessário
                        Flexible(
                          child: Text(
                            'Confirmar Pedido', 
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _confirmOrder(context, ref, selectedPaymentMethod),
                  ),
                ),              ],
            ),
          ),
        ],
      );
    },
  ),
);
  }
  
  // Método auxiliar para construir linhas de detalhes no modal
  Widget _buildDetailRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.iconSmall,
          color: color,
        ),
        const SizedBox(width: AppSizes.paddingSmall),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }  /// Confirma o pedido e exibe notificação de sucesso - MIGRADO: usar Riverpod + Orders + Printing
  void _confirmOrder(BuildContext context, WidgetRef ref, String selectedPaymentMethod) async {
    if (_isProcessing) return;
    _isProcessing = true;
    setState(() {});
    try {
      // Converter string para enum PaymentMethod
      PaymentMethod paymentMethod;
      switch (selectedPaymentMethod) {
        case 'Cartão de Crédito':
          paymentMethod = PaymentMethod.credit;
          break;
        case 'PIX':
          paymentMethod = PaymentMethod.pix;
          break;
        case 'Dinheiro':
        default:
          paymentMethod = PaymentMethod.cash;
          break;
      }
      
      // Criar o pedido a partir do carrinho
      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
        final order = OrderEntity.fromCart(
        id: orderId,
        cartItems: widget.currentCart.items,
        subtotal: widget.currentCart.subtotal,
        tax: widget.currentCart.tax,
        total: widget.currentCart.total,
        paymentMethod: paymentMethod, // Usar o método selecionado
        customerName: 'Cliente', // Padrão por enquanto
      );

      // Salvar o pedido no histórico
      final success = await ref.read(ordersNotifierProvider.notifier).createOrder(order);
      if (success) {
        // MIGRADO: Usar CartProvider Riverpod para limpar carrinho
        ref.read(cartProvider.notifier).clearCart();        // Gerar e exibir prévia interna do cupom fiscal automaticamente
        if (context.mounted) {
          ref.read(printingQueueProvider.notifier).addToQueue(context, order);
        }

        if (context.mounted) {
          Navigator.of(context).pop();
          
          // Usar o toast personalizado pequeno e no topo centro
          showCustomToast(
            context,
            title: 'Pedido Finalizado',
            message: 'Pedido #${orderId.substring(orderId.length - 8)} criado e cupom fiscal gerado!',
            icon: FluentIcons.completed,
            color: AppColors.success,
            duration: const Duration(seconds: 5),
          );
        }
      } else {        
        if (context.mounted) {
          Navigator.of(context).pop();
          showCustomToast(
            context,
            title: 'Erro',
            message: 'Não foi possível criar o pedido. Tente novamente.',
            icon: FluentIcons.error,
            color: AppColors.error,
            duration: const Duration(seconds: 4),
          );
        }      }
    } catch (e) {      
      if (context.mounted) {
        Navigator.of(context).pop();
        showCustomToast(
          context,
          title: 'Erro Inesperado',
          message: 'Erro: $e',
          icon: FluentIcons.error,
          color: AppColors.error,
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      _isProcessing = false;
      _lastOrderTime = DateTime.now();
      if (mounted) setState(() {});
    }
  }

  /// Constrói uma opção de pagamento para o dialog (com callback)
  Widget _buildDialogPaymentOption(
    String label,
    IconData icon,
    Color iconColor,
    bool isSelected,
    ValueChanged<bool?> onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(true),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryAccent.withValues(alpha: 0.1)
              : AppColors.surfaceVariant.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryAccent.withValues(alpha: 0.3)
                : AppColors.border.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            RadioButton(
              checked: isSelected,
              onChanged: onChanged,
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            Icon(
              icon,
              size: AppSizes.iconSmall,
              color: iconColor,
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
