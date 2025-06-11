import '../../../../core/utils/typedef.dart';
import '../entities/product_entity.dart';

/// Interface abstrata para operações de produto
/// Define o contrato que será implementado na camada de dados
abstract class ProductRepository {
  /// Busca todos os produtos disponíveis
  /// Retorna [Either<Failure, List<ProductEntity>>]
  FutureEither<List<ProductEntity>> getAllProducts();

  /// Busca produtos filtrados por categoria
  /// [categoryId] - ID da categoria para filtrar
  /// Retorna [Either<Failure, List<ProductEntity>>]
  FutureEither<List<ProductEntity>> getProductsByCategory(String categoryId);

  /// Busca um produto específico pelo ID
  /// [productId] - ID do produto a ser buscado
  /// Retorna [Either<Failure, ProductEntity>]
  FutureEither<ProductEntity> getProductById(String productId);

  /// Busca produtos por lista de IDs
  /// [productIds] - Lista de IDs dos produtos
  /// Retorna [Either<Failure, List<ProductEntity>>]
  FutureEither<List<ProductEntity>> getProductsByIds(List<String> productIds);

  /// Verifica se um produto está disponível
  /// [productId] - ID do produto a ser verificado
  /// Retorna [Either<Failure, bool>]
  FutureEither<bool> isProductAvailable(String productId);
}
