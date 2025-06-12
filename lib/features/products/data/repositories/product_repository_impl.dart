import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

/// Implementação concreta do ProductRepository
/// Usa ProductLocalDataSource e trata erros convertendo para Failures
class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  const ProductRepositoryImpl({required this.localDataSource});

  @override
  FutureEither<List<ProductEntity>> getAllProducts() async {
    try {
      AppLogger.debug('ProductRepository: Getting all products');
      final productModels = await localDataSource.getAllProducts();

      // Converte ProductModel para ProductEntity
      final productEntities =
          productModels.map((model) => model.toEntity()).toList();

      AppLogger.debug(
        'ProductRepository: Found ${productEntities.length} products',
      );
      return Right(productEntities);
    } on CacheException catch (e) {
      AppLogger.error('ProductRepository: Cache error getting all products', e);
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error(
        'ProductRepository: Unexpected error getting all products',
        e,
      );
      return Left(
        CacheFailure(message: 'Erro inesperado ao buscar produtos: $e'),
      );
    }
  }

  @override
  FutureEither<List<ProductEntity>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      AppLogger.debug(
        'ProductRepository: Getting products by category $categoryId',
      );
      final productModels = await localDataSource.getProductsByCategory(
        categoryId,
      );

      // Converte ProductModel para ProductEntity
      final productEntities =
          productModels.map((model) => model.toEntity()).toList();

      AppLogger.debug(
        'ProductRepository: Found ${productEntities.length} products for category $categoryId',
      );
      return Right(productEntities);
    } on CacheException catch (e) {
      AppLogger.error(
        'ProductRepository: Cache error getting products by category',
        e,
      );
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error(
        'ProductRepository: Unexpected error getting products by category',
        e,
      );
      return Left(
        CacheFailure(
          message: 'Erro inesperado ao buscar produtos por categoria: $e',
        ),
      );
    }
  }

  @override
  FutureEither<ProductEntity> getProductById(String productId) async {
    try {
      AppLogger.debug('ProductRepository: Getting product by ID $productId');
      final productModel = await localDataSource.getProductById(productId);

      // Converte ProductModel para ProductEntity
      final productEntity = productModel.toEntity();

      AppLogger.debug('ProductRepository: Found product ${productEntity.name}');
      return Right(productEntity);
    } on CacheException catch (e) {
      AppLogger.error(
        'ProductRepository: Cache error getting product by ID',
        e,
      );
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error(
        'ProductRepository: Unexpected error getting product by ID',
        e,
      );
      return Left(
        CacheFailure(message: 'Erro inesperado ao buscar produto por ID: $e'),
      );
    }
  }

  @override
  FutureEither<List<ProductEntity>> getProductsByIds(
    List<String> productIds,
  ) async {
    try {
      AppLogger.debug(
        'ProductRepository: Getting products by IDs ${productIds.length}',
      );
      final productModels = await localDataSource.getProductsByIds(productIds);

      // Converte ProductModel para ProductEntity
      final productEntities =
          productModels.map((model) => model.toEntity()).toList();

      AppLogger.debug(
        'ProductRepository: Found ${productEntities.length} products by IDs',
      );
      return Right(productEntities);
    } on CacheException catch (e) {
      AppLogger.error(
        'ProductRepository: Cache error getting products by IDs',
        e,
      );
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error(
        'ProductRepository: Unexpected error getting products by IDs',
        e,
      );
      return Left(
        CacheFailure(message: 'Erro inesperado ao buscar produtos por IDs: $e'),
      );
    }
  }

  @override
  FutureEither<bool> isProductAvailable(String productId) async {
    try {
      AppLogger.debug(
        'ProductRepository: Checking availability for product $productId',
      );
      final isAvailable = await localDataSource.isProductAvailable(productId);

      AppLogger.debug(
        'ProductRepository: Product $productId availability: $isAvailable',
      );
      return Right(isAvailable);
    } on CacheException catch (e) {
      AppLogger.error(
        'ProductRepository: Cache error checking product availability',
        e,
      );
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      AppLogger.error(
        'ProductRepository: Unexpected error checking product availability',
        e,
      );
      return Left(
        CacheFailure(
          message: 'Erro inesperado ao verificar disponibilidade: $e',
        ),
      );
    }
  }

  // ====== NOVOS MÉTODOS DA ARQUITETURA APRIMORADA ======

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query,
  ) async {
    try {
      AppLogger.debug(
        'ProductRepository: Searching products with query "$query"',
      );

      // Obtém todos os produtos e filtra
      final allProductsResult = await getAllProducts();

      return allProductsResult.fold((failure) => Left(failure), (products) {
        final filteredProducts =
            products.where((product) {
              final searchTerm = query.toLowerCase();
              return product.name.toLowerCase().contains(searchTerm) ||
                  product.description.toLowerCase().contains(searchTerm);
            }).toList();

        AppLogger.debug(
          'ProductRepository: Found ${filteredProducts.length} products for query "$query"',
        );
        return Right(filteredProducts);
      });
    } catch (e) {
      AppLogger.error('ProductRepository: Error searching products', e);
      return Left(
        CacheFailure(message: 'Erro inesperado ao buscar produtos: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      AppLogger.debug(
        'ProductRepository: Getting products by price range $minPrice - $maxPrice',
      );

      final allProductsResult = await getAllProducts();

      return allProductsResult.fold((failure) => Left(failure), (products) {
        final filteredProducts =
            products.where((product) {
              return product.price >= minPrice && product.price <= maxPrice;
            }).toList();

        AppLogger.debug(
          'ProductRepository: Found ${filteredProducts.length} products in price range',
        );
        return Right(filteredProducts);
      });
    } catch (e) {
      AppLogger.error(
        'ProductRepository: Error getting products by price range',
        e,
      );
      return Left(
        CacheFailure(
          message: 'Erro inesperado ao buscar produtos por preço: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAvailableProducts() async {
    try {
      AppLogger.debug('ProductRepository: Getting available products');

      final allProductsResult = await getAllProducts();

      return allProductsResult.fold((failure) => Left(failure), (products) {
        final availableProducts =
            products.where((product) {
              return product.isAvailable && product.availableQuantity > 0;
            }).toList();

        AppLogger.debug(
          'ProductRepository: Found ${availableProducts.length} available products',
        );
        return Right(availableProducts);
      });
    } catch (e) {
      AppLogger.error('ProductRepository: Error getting available products', e);
      return Left(
        CacheFailure(
          message: 'Erro inesperado ao buscar produtos disponíveis: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getPromotionalProducts() async {
    try {
      AppLogger.debug('ProductRepository: Getting promotional products');

      final allProductsResult = await getAllProducts();

      return allProductsResult.fold((failure) => Left(failure), (products) {
        // Por enquanto, considera promoção produtos com preço abaixo de R$30
        final promotionalProducts =
            products.where((product) {
              return product.isAvailable && product.price < 30.0;
            }).toList();

        AppLogger.debug(
          'ProductRepository: Found ${promotionalProducts.length} promotional products',
        );
        return Right(promotionalProducts);
      });
    } catch (e) {
      AppLogger.error(
        'ProductRepository: Error getting promotional products',
        e,
      );
      return Left(
        CacheFailure(
          message: 'Erro inesperado ao buscar produtos promocionais: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateProductQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      AppLogger.business('Update Product Quantity', {
        'productId': productId,
        'newQuantity': quantity,
      });

      // Por enquanto retorna sucesso - implementação futura incluirá persistência
      // Data source update implementation planned for future releases

      AppLogger.debug(
        'ProductRepository: Updated quantity for product $productId to $quantity',
      );
      return const Right(null);
    } catch (e) {
      AppLogger.error('ProductRepository: Error updating product quantity', e);
      return Left(
        CacheFailure(message: 'Erro inesperado ao atualizar quantidade: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> decrementProductQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      AppLogger.business('Decrement Product Quantity', {
        'productId': productId,
        'decrementBy': quantity,
      });

      // Por enquanto retorna sucesso - implementação futura incluirá persistência
      // Data source decrement implementation planned for future releases

      AppLogger.debug(
        'ProductRepository: Decremented quantity for product $productId by $quantity',
      );
      return const Right(null);
    } catch (e) {
      AppLogger.error(
        'ProductRepository: Error decrementing product quantity',
        e,
      );
      return Left(
        CacheFailure(message: 'Erro inesperado ao decrementar quantidade: $e'),
      );
    }
  }
}
