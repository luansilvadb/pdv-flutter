import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case para filtrar produtos por categoria
class FilterProductsByCategory
    extends UseCase<List<ProductEntity>, FilterProductsByCategoryParams>
    with UseCaseLogging {
  final ProductRepository repository;

  FilterProductsByCategory(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    FilterProductsByCategoryParams params,
  ) async {
    logExecution('FilterProductsByCategory', {'categoryId': params.categoryId});

    try {
      final result = await repository.getProductsByCategory(params.categoryId);

      return result.fold(
        (failure) {
          logError('FilterProductsByCategory', failure);
          return Left(failure);
        },
        (products) {
          logSuccess('FilterProductsByCategory', {'found': products.length});
          return Right(products);
        },
      );
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao filtrar por categoria: $e',
      );
      logError('FilterProductsByCategory', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para filtro por categoria
class FilterProductsByCategoryParams extends Equatable {
  final String categoryId;

  const FilterProductsByCategoryParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
