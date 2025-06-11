import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
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
      final productModels = await localDataSource.getAllProducts();

      // Converte ProductModel para ProductEntity
      final productEntities =
          productModels.map((model) => model.toEntity()).toList();

      return Right(productEntities);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
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
      final productModels = await localDataSource.getProductsByCategory(
        categoryId,
      );

      // Converte ProductModel para ProductEntity
      final productEntities =
          productModels.map((model) => model.toEntity()).toList();

      return Right(productEntities);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
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
      final productModel = await localDataSource.getProductById(productId);

      // Converte ProductModel para ProductEntity
      final productEntity = productModel.toEntity();

      return Right(productEntity);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
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
      final productModels = await localDataSource.getProductsByIds(productIds);

      // Converte ProductModel para ProductEntity
      final productEntities =
          productModels.map((model) => model.toEntity()).toList();

      return Right(productEntities);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(
        CacheFailure(message: 'Erro inesperado ao buscar produtos por IDs: $e'),
      );
    }
  }

  @override
  FutureEither<bool> isProductAvailable(String productId) async {
    try {
      final isAvailable = await localDataSource.isProductAvailable(productId);

      return Right(isAvailable);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Erro inesperado ao verificar disponibilidade: $e',
        ),
      );
    }
  }
}
