import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case para buscar produtos por nome ou descrição
class SearchProducts extends UseCase<List<ProductEntity>, SearchProductsParams>
    with UseCaseLogging {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    SearchProductsParams params,
  ) async {
    logExecution('SearchProducts', {'query': params.query});

    try {
      final result = await repository.searchProducts(params.query);

      return result.fold(
        (failure) {
          logError('SearchProducts', failure);
          return Left(failure);
        },
        (products) {
          logSuccess('SearchProducts', {'found': products.length});
          return Right(products);
        },
      );
    } catch (e) {
      final failure = UnknownFailure(message: 'Erro inesperado na busca: $e');
      logError('SearchProducts', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para busca de produtos
class SearchProductsParams extends Equatable {
  final String query;

  const SearchProductsParams({required this.query});

  @override
  List<Object?> get props => [query];
}
