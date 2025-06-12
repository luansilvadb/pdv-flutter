import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case para obter produtos disponíveis (com estoque)
class GetAvailableProducts extends UseCaseNoParams<List<ProductEntity>>
    with UseCaseLogging {
  final ProductRepository repository;

  GetAvailableProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call() async {
    logExecution('GetAvailableProducts');

    try {
      final result = await repository.getAvailableProducts();

      return result.fold(
        (failure) {
          logError('GetAvailableProducts', failure);
          return Left(failure);
        },
        (products) {
          logSuccess('GetAvailableProducts', {'found': products.length});
          return Right(products);
        },
      );
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao buscar produtos disponíveis: $e',
      );
      logError('GetAvailableProducts', failure);
      return Left(failure);
    }
  }
}
