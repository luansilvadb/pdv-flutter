import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/dependency_injection.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/create_order.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../inventory/presentation/providers/inventory_provider.dart';
import 'checkout_state.dart';
import 'orders_provider.dart';

/// Notifier para gerenciar o processo de checkout
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final CreateOrder _createOrder;
  final Ref _ref;

  CheckoutNotifier(this._createOrder, this._ref) : super(const CheckoutState());

  /// Atualiza o método de pagamento selecionado
  void updatePaymentMethod(PaymentMethod method) {
    state = state.copyWith(paymentMethod: method);
  }

  /// Atualiza o valor para troco
  void updateChangeFor(double? amount) {
    state = state.copyWith(changeFor: amount);
  }

  /// Processa a finalização do pedido
  Future<bool> processCheckout(CartEntity cart) async {
    if (cart.isEmpty) {
      state = state.copyWith(error: 'O carrinho está vazio');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
    final order = OrderEntity.fromCart(
      id: orderId,
      cartItems: cart.items,
      subtotal: cart.subtotal,
      tax: cart.tax,
      total: cart.total,
      paymentMethod: state.paymentMethod,
      customerName: 'Cliente', // Padrão por enquanto
      notes: state.paymentMethod == PaymentMethod.cash && state.changeFor != null
          ? 'Troco para R\$ ${state.changeFor?.toStringAsFixed(2)}'
          : null,
    );

    // Usa o OrdersNotifier para criar o pedido e manter a sincronia da lista
    final success = await _ref.read(ordersNotifierProvider.notifier).createOrder(order);

    if (success) {
      // Atualiza o estoque para cada item do carrinho
      for (final item in cart.items) {
        await _ref.read(inventoryProvider.notifier).updateStock(
          item.productId,
          _calculateNewStock(item.productId, item.quantity.value),
        );
      }

      state = state.copyWith(
        isLoading: false,
        completedOrder: order,
      );

      // Limpa o carrinho após sucesso
      await _ref.read(cartProvider.notifier).clearCart();

      return true;
    } else {
      final error = _ref.read(ordersErrorProvider) ?? 'Erro desconhecido ao finalizar pedido';
      state = state.copyWith(isLoading: false, error: error);
      return false;
    }
  }

  /// Reinicia o estado do checkout
  void reset() {
    state = const CheckoutState();
  }

  /// Calcula o novo estoque após a venda
  double _calculateNewStock(String productId, int soldQuantity) {
    final inventoryItems = _ref.read(inventoryProvider).items;
    final itemIndex = inventoryItems.indexWhere((i) => i.productId == productId);

    if (itemIndex == -1) {
      return 0.0; // Graceful handling if item not in inventory
    }

    return inventoryItems[itemIndex].currentQuantity - soldQuantity;
  }
}

/// Provider para o CheckoutNotifier
final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(sl<CreateOrder>(), ref);
});
