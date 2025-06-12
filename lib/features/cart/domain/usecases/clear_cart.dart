import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../repositories/cart_repository.dart';

/// Use case para limpar o carrinho
class ClearCart extends UseCaseNoParams<Unit> with UseCaseLogging {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, Unit>> call() async {
    logExecution('ClearCart');

    try {
      final result = await repository.clearCart();

      result.fold(
        (failure) => logError('ClearCart', failure),
        (unit) => logSuccess('ClearCart', unit),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao limpar carrinho: $e',
      );
      logError('ClearCart', failure);
      return Left(failure);
    }
  }
}
