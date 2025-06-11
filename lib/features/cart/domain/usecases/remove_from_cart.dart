import 'package:equatable/equatable.dart';

import '../../../../core/utils/typedef.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case para remover item do carrinho
class RemoveFromCart {
  final CartRepository repository;

  const RemoveFromCart(this.repository);

  /// Executa o use case para remover produto do carrinho
  /// Retorna [FutureEither<CartEntity>]
  FutureEither<CartEntity> call(RemoveFromCartParams params) async {
    return await repository.removeItem(params.productId);
  }
}

/// Parâmetros para remover produto do carrinho
class RemoveFromCartParams extends Equatable {
  final String productId;

  const RemoveFromCartParams({required this.productId});

  @override
  List<Object?> get props => [productId];

  @override
  String toString() {
    return 'RemoveFromCartParams(productId: $productId)';
  }
}
