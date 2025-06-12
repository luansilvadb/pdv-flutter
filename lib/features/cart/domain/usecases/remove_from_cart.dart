import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';

import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case para remover item do carrinho
class RemoveFromCart extends UseCase<CartEntity, RemoveFromCartParams>
    with UseCaseLogging {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(RemoveFromCartParams params) async {
    logExecution('RemoveFromCart', params);

    try {
      // Validações de negócio
      if (params.productId.trim().isEmpty) {
        final failure = ValidationFailure(
          message: 'ID do produto é obrigatório',
        );
        logError('RemoveFromCart', failure);
        return Left(failure);
      }

      final result = await repository.removeItem(params.productId);

      result.fold(
        (failure) => logError('RemoveFromCart', failure),
        (cart) => logSuccess('RemoveFromCart', cart),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao remover item: $e',
      );
      logError('RemoveFromCart', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para remover produto do carrinho
class RemoveFromCartParams extends Equatable {
  final String productId;

  const RemoveFromCartParams({required this.productId});

  @override
  List<Object?> get props => [productId];

  @override
  String toString() {
    return 'RemoveFromCartParams(productId: $productId)';
  }
}
