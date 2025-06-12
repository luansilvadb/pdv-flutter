import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case para buscar o carrinho atual
class GetCart extends UseCaseNoParams<CartEntity> with UseCaseLogging {
  final CartRepository repository;

  GetCart(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call() async {
    logExecution('GetCart');

    try {
      final result = await repository.getCart();

      result.fold(
        (failure) => logError('GetCart', failure),
        (cart) => logSuccess('GetCart', cart),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao buscar carrinho: $e',
      );
      logError('GetCart', failure);
      return Left(failure);
    }
  }
}
