import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

import '../entities/cart_entity.dart';

/// Interface abstrata para operações do carrinho
abstract class CartRepository {
  /// Busca o carrinho atual
  Future<Either<Failure, CartEntity>> getCart();

  /// Adiciona um produto ao carrinho
  /// Se o produto já existe, incrementa a quantidade
  Future<Either<Failure, CartEntity>> addItem({
    required String productId,
    required int quantity,
  });

  /// Remove um item completamente do carrinho
  Future<Either<Failure, CartEntity>> removeItem(String productId);

  /// Atualiza a quantidade de um item específico
  /// Se quantity <= 0, remove o item
  Future<Either<Failure, CartEntity>> updateQuantity({
    required String productId,
    required int quantity,
  });

  /// Incrementa a quantidade de um item em 1
  Future<Either<Failure, CartEntity>> incrementQuantity(String productId);

  /// Decrementa a quantidade de um item em 1
  /// Se quantity chegar a 0, remove o item
  Future<Either<Failure, CartEntity>> decrementQuantity(String productId);

  /// Limpa todo o carrinho
  Future<Either<Failure, Unit>> clearCart();

  /// Salva o carrinho atual
  Future<Either<Failure, Unit>> saveCart(CartEntity cart);

  /// Verifica se um produto existe no carrinho
  Future<Either<Failure, bool>> containsProduct(String productId);

  /// Obtém a quantidade de um produto específico
  Future<Either<Failure, int>> getProductQuantity(String productId);
}
