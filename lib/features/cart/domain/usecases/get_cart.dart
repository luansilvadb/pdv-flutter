import '../../../../core/utils/typedef.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case para buscar o carrinho atual
class GetCart {
  final CartRepository repository;

  const GetCart(this.repository);

  /// Executa o use case para buscar carrinho atual
  /// Não requer parâmetros
  /// Retorna [FutureEither<CartEntity>]
  FutureEither<CartEntity> call() async {
    return await repository.getCart();
  }
}

/// Classe para representar parâmetros vazios em use cases
class NoParams {
  const NoParams();
}
