import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case para atualizar quantidade de item no carrinho
class UpdateCartItemQuantity {
  final CartRepository repository;

  const UpdateCartItemQuantity(this.repository);

  /// Executa o use case para atualizar quantidade do produto
  /// Retorna [FutureEither<CartEntity>]
  FutureEither<CartEntity> call(UpdateQuantityParams params) async {
    // Validações básicas
    if (params.newQuantity < 0) {
      return Left(
        ValidationFailure(message: 'Quantidade não pode ser negativa'),
      );
    }

    return await repository.updateQuantity(
      productId: params.productId,
      quantity: params.newQuantity,
    );
  }
}

/// Parâmetros para atualizar quantidade
class UpdateQuantityParams extends Equatable {
  final String productId;
  final int newQuantity;

  const UpdateQuantityParams({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];

  @override
  String toString() {
    return 'UpdateQuantityParams(productId: $productId, newQuantity: $newQuantity)';
  }
}
