import '../models/cart_model.dart';

/// Interface abstrata para persistência local do carrinho
abstract class CartLocalDataSource {
  /// Busca o carrinho salvo localmente
  /// Retorna null se não existe carrinho salvo
  Future<CartModel?> getCart();

  /// Salva o carrinho localmente
  Future<void> saveCart(CartModel cart);

  /// Remove o carrinho salvo localmente
  Future<void> clearCart();

  /// Verifica se existe um carrinho salvo
  Future<bool> hasCart();

  /// Obtém a última vez que o carrinho foi modificado
  Future<DateTime?> getLastModified();
}
