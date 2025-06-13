import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_provider.dart';
import 'cart_state.dart';

/// Providers otimizados para o carrinho que reduzem rebuilds desnecessários
/// ao observar apenas partes específicas do estado do carrinho

/// Provider para obter apenas o valor total do carrinho
/// Causa rebuild somente quando o valor total muda
final cartTotalProvider = Provider<double>((ref) {
  final cartState = ref.watch(cartProvider);
  if (cartState is CartLoaded) {
    return cartState.cart.totalAmount;
  }
  return 0.0;
});

/// Provider para obter apenas o número de itens no carrinho
/// Causa rebuild somente quando o número de itens muda
final cartItemCountProvider = Provider<int>((ref) {
  final cartState = ref.watch(cartProvider);
  if (cartState is CartLoaded) {
    return cartState.cart.itemCount;
  }
  return 0;
});

/// Provider para verificar se o carrinho está vazio
/// Causa rebuild somente quando o estado de "vazio" muda
final isCartEmptyProvider = Provider<bool>((ref) {
  final cartState = ref.watch(cartProvider);
  if (cartState is CartLoaded) {
    return cartState.cart.isEmpty;
  }
  return true;
});

/// Provider para obter itens individuais do carrinho
/// Causa rebuild somente quando os itens mudam
final cartItemsProvider = Provider<List<CartItemEntity>>((ref) {
  final cartState = ref.watch(cartProvider);
  if (cartState is CartLoaded) {
    return cartState.cart.items;
  }
  return [];
});

/// Provider para verificar se um produto específico está no carrinho
/// Útil para botões de "adicionar ao carrinho" que mudam de aparência quando o item já está no carrinho
final isProductInCartProvider = Provider.family<bool, String>((ref, productId) {
  final items = ref.watch(cartItemsProvider);
  return items.any((item) => item.productId == productId);
});

/// Provider para obter a quantidade de um produto específico no carrinho
final productQuantityInCartProvider = Provider.family<int, String>((ref, productId) {
  final items = ref.watch(cartItemsProvider);
  final item = items.firstWhere(
    (item) => item.productId == productId,
    orElse: () => CartItemEntity.empty(),
  );
  return item.quantity.value;
});
