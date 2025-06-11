import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case para adicionar um produto ao carrinho
class AddToCart {
  final CartRepository repository;

  const AddToCart(this.repository);

  /// Executa o use case para adicionar produto ao carrinho
  /// Retorna [FutureEither<CartEntity>]
  FutureEither<CartEntity> call(AddToCartParams params) async {
    // Validações básicas
    if (params.quantity <= 0) {
      return Left(
        ValidationFailure(message: 'Quantidade deve ser maior que zero'),
      );
    }

    return await repository.addItem(
      productId: params.productId,
      quantity: params.quantity,
    );
  }
}

/// Parâmetros para adicionar produto ao carrinho
class AddToCartParams extends Equatable {
  final String productId;
  final int quantity;

  const AddToCartParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];

  @override
  String toString() {
    return 'AddToCartParams(productId: $productId, quantity: $quantity)';
  }
}
