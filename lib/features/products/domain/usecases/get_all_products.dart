import '../../../../core/utils/typedef.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case para buscar todos os produtos
/// Implementa o padrão UseCase seguindo Clean Architecture
class GetAllProducts {
  final ProductRepository repository;

  const GetAllProducts(this.repository);

  /// Executa o use case para buscar todos os produtos
  /// Não requer parâmetros
  /// Retorna [FutureEither<List<ProductEntity>>]
  FutureEither<List<ProductEntity>> call() async {
    return await repository.getAllProducts();
  }
}

/// Classe para representar parâmetros vazios em use cases
class NoParams {
  const NoParams();
}
