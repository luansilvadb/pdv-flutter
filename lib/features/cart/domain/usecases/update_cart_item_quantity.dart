import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';

import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../../../../shared/domain/value_objects/quantity.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case para atualizar quantidade de item no carrinho
class UpdateCartItemQuantity extends UseCase<CartEntity, UpdateQuantityParams>
    with UseCaseLogging {
  final CartRepository repository;

  UpdateCartItemQuantity(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(UpdateQuantityParams params) async {
    logExecution('UpdateCartItemQuantity', params);

    try {
      // Validações de negócio
      if (params.productId.trim().isEmpty) {
        final failure = ValidationFailure(
          message: 'ID do produto é obrigatório',
        );
        logError('UpdateCartItemQuantity', failure);
        return Left(failure);
      }

      if (params.newQuantity.isNegative) {
        final failure = ValidationFailure(
          message: 'Quantidade não pode ser negativa',
        );
        logError('UpdateCartItemQuantity', failure);
        return Left(failure);
      }

      final result = await repository.updateQuantity(
        productId: params.productId,
        quantity: params.newQuantity,
      );

      result.fold(
        (failure) => logError('UpdateCartItemQuantity', failure),
        (cart) => logSuccess('UpdateCartItemQuantity', cart),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao atualizar quantidade: $e',
      );
      logError('UpdateCartItemQuantity', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para atualizar quantidade
class UpdateQuantityParams extends Equatable {
  final String productId;
  final Quantity newQuantity;

  const UpdateQuantityParams({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productId, newQuantity];

  @override
  String toString() {
    return 'UpdateQuantityParams(productId: $productId, newQuantity: ${newQuantity.value})';
  }
}
