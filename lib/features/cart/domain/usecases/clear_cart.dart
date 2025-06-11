import 'package:dartz/dartz.dart';

import '../../../../core/utils/typedef.dart';
import '../repositories/cart_repository.dart';

/// Use case para limpar o carrinho
class ClearCart {
  final CartRepository repository;

  const ClearCart(this.repository);

  /// Executa o use case para limpar carrinho
  /// Não requer parâmetros
  /// Retorna [FutureEither<Unit>]
  FutureEither<Unit> call() async {
    return await repository.clearCart();
  }
}
