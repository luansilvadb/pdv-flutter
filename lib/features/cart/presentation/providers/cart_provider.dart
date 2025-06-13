import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../core/services/dependency_injection.dart';
import '../../../../shared/domain/value_objects/quantity.dart';
import '../../../../shared/domain/value_objects/money.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_cart_item_quantity.dart';
import '../../domain/usecases/get_cart.dart';
import '../../domain/usecases/clear_cart.dart';
import 'cart_state.dart';

/// Provider StateNotifier para gerenciar o estado do carrinho
class CartNotifier extends StateNotifier<CartState> {
  final AddToCart _addToCart;
  final RemoveFromCart _removeFromCart;
  final UpdateCartItemQuantity _updateCartItemQuantity;
  final GetCart _getCart;
  final ClearCart _clearCart;
  final Logger _logger;

  CartNotifier({
    required AddToCart addToCart,
    required RemoveFromCart removeFromCart,
    required UpdateCartItemQuantity updateCartItemQuantity,
    required GetCart getCart,
    required ClearCart clearCart,
    required Logger logger,
  }) : _addToCart = addToCart,
       _removeFromCart = removeFromCart,
       _updateCartItemQuantity = updateCartItemQuantity,
       _getCart = getCart,
       _clearCart = clearCart,
       _logger = logger,
       super(const CartInitial());

  /// Carrinho atual (apenas quando carregado)
  CartEntity? get currentCart {
    final currentState = state;
    if (currentState is CartLoaded) {
      return currentState.cart;
    }
    return null;
  }

  /// Verifica se carrinho está vazio
  bool get isEmpty => currentCart?.isEmpty ?? true;

  /// Verifica se carrinho não está vazio
  bool get isNotEmpty => !isEmpty;

  /// Quantidade total de itens
  int get itemCount => currentCart?.itemCount ?? 0;

  /// Valor total do carrinho
  double get totalAmount => currentCart?.totalAmount ?? 0.0;

  /// Inicializa o carrinho (carrega do storage)
  Future<void> initialize() async {
    if (state is CartLoading) return; // Evita múltiplas chamadas simultâneas

    _logger.d('Inicializando carrinho...');
    state = const CartLoading();

    final result = await _getCart();

    result.fold(
      (failure) {
        _logger.e('Erro ao carregar carrinho: ${failure.message}');
        state = CartError(failure.message);
      },
      (cart) {
        _logger.d('Carrinho carregado com ${cart.items.length} itens');
        state = CartLoaded(cart);
      },
    );
  }  /// Adiciona produto ao carrinho
  Future<void> addProduct({
    required String productId,
    required String productName,
    required Money price,
    required String productImageUrl,
    Quantity? quantity,
  }) async {
    final qty = quantity ?? Quantity.one;
    _logger.d(
      'Adicionando produto $productId ao carrinho (quantidade: ${qty.value})',
    );

    // Não alteramos o estado para CartItemAdding para evitar flick

    final params = AddToCartParams(
      productId: productId,
      productName: productName,
      price: price,
      productImageUrl: productImageUrl,
      quantity: qty,
    );
    final result = await _addToCart(params);

    result.fold(
      (failure) {
        _logger.e('Erro ao adicionar produto: ${failure.message}');
        // Mantém o estado anterior, não faz alterações desnecessárias
        _showError(failure.message);
      },
      (cart) {
        _logger.d('Produto adicionado com sucesso');
        state = CartLoaded(cart);
      },
    );
  }
  /// Remove produto completamente do carrinho
  Future<void> removeProduct(String productId) async {
    _logger.d('Removendo produto $productId do carrinho');

    // Não alteramos o estado para evitar flick

    final params = RemoveFromCartParams(productId: productId);
    final result = await _removeFromCart(params);

    result.fold(
      (failure) {
        _logger.e('Erro ao remover produto: ${failure.message}');
        _showError(failure.message);
      },
      (cart) {
        _logger.d('Produto removido com sucesso');
        state = CartLoaded(cart);
      },
    );
  }  /// Atualiza quantidade de um produto
  Future<void> updateQuantity(String productId, Quantity quantity) async {
    _logger.d('Atualizando quantidade do produto $productId para ${quantity.value}');

    // Não alteramos o estado para evitar flick

    final params = UpdateQuantityParams(
      productId: productId,
      newQuantity: quantity,
    );
    final result = await _updateCartItemQuantity(params);

    result.fold(
      (failure) {
        _logger.e('Erro ao atualizar quantidade: ${failure.message}');
        _showError(failure.message);
      },
      (cart) {
        _logger.d('Quantidade atualizada com sucesso');
        state = CartLoaded(cart);
      },
    );
  }
  /// Incrementa quantidade em 1
  Future<void> incrementQuantity(String productId) async {
    final currentItem = currentCart?.findItemByProductId(productId);
    if (currentItem != null) {
      final newQuantity = Quantity(currentItem.quantity.value + 1);
      await updateQuantity(productId, newQuantity);
    }
  }

  /// Decrementa quantidade em 1
  Future<void> decrementQuantity(String productId) async {
    final currentItem = currentCart?.findItemByProductId(productId);
    if (currentItem != null) {
      final newQuantityValue = currentItem.quantity.value - 1;
      if (newQuantityValue <= 0) {
        await removeProduct(productId);
      } else {
        await updateQuantity(productId, Quantity(newQuantityValue));
      }
    }
  }
  /// Limpa todo o carrinho
  Future<void> clearCart() async {
    _logger.d('Limpando carrinho...');

    // Não alteramos o estado para evitar flick

    final result = await _clearCart();

    result.fold(
      (failure) {
        _logger.e('Erro ao limpar carrinho: ${failure.message}');
        _showError(failure.message);
      },
      (_) {
        _logger.d('Carrinho limpo com sucesso');
        state = const CartCleared();
        // Recarrega carrinho vazio
        initialize();
      },
    );
  }

  /// Verifica se produto está no carrinho
  bool containsProduct(String productId) {
    return currentCart?.containsProduct(productId) ?? false;
  }
  /// Obtém quantidade de um produto específico
  int getProductQuantity(String productId) {
    return currentCart?.findItemByProductId(productId)?.quantity.value ?? 0;
  }

  /// Recarrega o carrinho
  Future<void> refresh() async {
    await initialize();
  }

  /// Método privado para mostrar erro temporário
  void _showError(String message) {
    // Em uma implementação real, você poderia usar um sistema de notificações
    // ou outro mecanismo para mostrar erros sem alterar o estado principal
    _logger.e('Erro no carrinho: $message');
  }
}

/// Provider para o CartNotifier
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(
    addToCart: sl<AddToCart>(),
    removeFromCart: sl<RemoveFromCart>(),
    updateCartItemQuantity: sl<UpdateCartItemQuantity>(),
    getCart: sl<GetCart>(),
    clearCart: sl<ClearCart>(),
    logger: sl<Logger>(),
  );
});

/// Provider para acessar apenas o carrinho atual
final currentCartProvider = Provider<CartEntity?>((ref) {
  final cartState = ref.watch(cartProvider);
  if (cartState is CartLoaded) {
    return cartState.cart;
  }
  return null;
});

/// Provider para verificar se carrinho está carregando
final cartLoadingProvider = Provider<bool>((ref) {
  final cartState = ref.watch(cartProvider);
  return cartState is CartLoading;
});

/// Provider para obter informações básicas do carrinho
final cartInfoProvider = Provider<({int itemCount, double totalAmount})>((ref) {
  final cart = ref.watch(currentCartProvider);
  return (
    itemCount: cart?.itemCount ?? 0,
    totalAmount: cart?.totalAmount ?? 0.0,
  );
});
