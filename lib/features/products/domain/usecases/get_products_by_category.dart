import 'package:equatable/equatable.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case para buscar produtos filtrados por categoria
/// Implementa o padrão UseCase seguindo Clean Architecture
class GetProductsByCategory {
  final ProductRepository repository;

  const GetProductsByCategory(this.repository);

  /// Executa o use case para buscar produtos por categoria
  /// [params] - Parâmetros contendo o ID da categoria
  /// Retorna [FutureEither<List<ProductEntity>>]
  FutureEither<List<ProductEntity>> call(
    GetProductsByCategoryParams params,
  ) async {
    return await repository.getProductsByCategory(params.categoryId);
  }
}

/// Parâmetros para o use case GetProductsByCategory
class GetProductsByCategoryParams extends Equatable {
  final String categoryId;

  const GetProductsByCategoryParams({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];

  @override
  String toString() => 'GetProductsByCategoryParams(categoryId: $categoryId)';
}
