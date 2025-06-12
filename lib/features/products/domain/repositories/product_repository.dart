import 'package:dartz/dartz.dart';
import '../../../../core/utils/typedef.dart';
import '../../../../core/errors/failures.dart';
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

  /// ====== NOVOS MÉTODOS DA ARQUITETURA APRIMORADA ======

  /// Busca produtos por nome ou descrição
  /// [query] - Termo de busca
  /// Retorna [Either<Failure, List<ProductEntity>>]
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);

  /// Busca produtos com preço dentro de um range
  /// [minPrice] - Preço mínimo
  /// [maxPrice] - Preço máximo
  /// Retorna [Either<Failure, List<ProductEntity>>]
  Future<Either<Failure, List<ProductEntity>>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  );

  /// Busca produtos disponíveis (com estoque)
  /// Retorna [Either<Failure, List<ProductEntity>>]
  Future<Either<Failure, List<ProductEntity>>> getAvailableProducts();

  /// Busca produtos em promoção ou com desconto
  /// Retorna [Either<Failure, List<ProductEntity>>]
  Future<Either<Failure, List<ProductEntity>>> getPromotionalProducts();

  /// Atualiza a quantidade disponível de um produto
  /// [productId] - ID do produto
  /// [quantity] - Nova quantidade
  /// Retorna [Either<Failure, void>]
  Future<Either<Failure, void>> updateProductQuantity(
    String productId,
    int quantity,
  );

  /// Decrementa a quantidade de um produto (para vendas)
  /// [productId] - ID do produto
  /// [quantity] - Quantidade a decrementar
  /// Retorna [Either<Failure, void>]
  Future<Either<Failure, void>> decrementProductQuantity(
    String productId,
    int quantity,
  );
}
