import 'package:dartz/dartz.dart';
import '../entities/base_entity.dart';
import '../../../core/errors/failures.dart';

/// Repositório base para operações CRUD padrão
abstract class Repository<T extends Entity> {
  /// Obtém todas as entidades
  Future<Either<Failure, List<T>>> getAll();

  /// Obtém uma entidade por ID
  Future<Either<Failure, T?>> getById(String id);

  /// Salva uma entidade (create ou update)
  Future<Either<Failure, String>> save(T entity);

  /// Remove uma entidade por ID
  Future<Either<Failure, void>> delete(String id);

  /// Limpa todas as entidades
  Future<Either<Failure, void>> clear();

  /// Verifica se uma entidade existe
  Future<Either<Failure, bool>> exists(String id);

  /// Conta o número total de entidades
  Future<Either<Failure, int>> count();
}

/// Mixin para operações de busca em repositórios
mixin SearchableRepository<T extends Entity> {
  /// Busca entidades por um termo
  Future<Either<Failure, List<T>>> search(String query);

  /// Filtra entidades por critério
  Future<Either<Failure, List<T>>> filter(Map<String, dynamic> criteria);

  /// Obtém entidades paginadas
  Future<Either<Failure, List<T>>> getPaginated({int page = 1, int limit = 20});
}

/// Mixin para operações de cache em repositórios
mixin CacheableRepository<T extends Entity> {
  /// Limpa o cache
  Future<Either<Failure, void>> clearCache();

  /// Atualiza o cache
  Future<Either<Failure, void>> refreshCache();

  /// Verifica se o cache está expirado
  Future<Either<Failure, bool>> isCacheExpired();
}
