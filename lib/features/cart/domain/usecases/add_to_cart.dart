import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';

import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../../../../shared/domain/value_objects/quantity.dart';
import '../../../../shared/domain/value_objects/money.dart';
import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

/// Use case para adicionar um produto ao carrinho
class AddToCart extends UseCase<CartEntity, AddToCartParams>
    with UseCaseLogging {
  final CartRepository repository;

  AddToCart(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(AddToCartParams params) async {
    logExecution('AddToCart', params);

    try {
      // Validações de negócio
      if (params.quantity.isEmpty) {
        final failure = ValidationFailure(
          message: 'Quantidade deve ser maior que zero',
        );
        logError('AddToCart', failure);
        return Left(failure);
      }

      if (params.price.value <= 0) {
        final failure = ValidationFailure(
          message: 'Preço deve ser maior que zero',
        );
        logError('AddToCart', failure);
        return Left(failure);
      }

      if (params.productName.trim().isEmpty) {
        final failure = ValidationFailure(
          message: 'Nome do produto é obrigatório',
        );
        logError('AddToCart', failure);
        return Left(failure);
      }

      // Cria o item do carrinho com ID único
      final cartItem = CartItemEntity(
        id: 'item_${DateTime.now().millisecondsSinceEpoch}',
        productId: params.productId,
        productName: params.productName,
        price: params.price,
        productImageUrl: params.productImageUrl,
        quantity: params.quantity,
      );

      final result = await repository.addItem(cartItem);

      result.fold(
        (failure) => logError('AddToCart', failure),
        (cart) => logSuccess('AddToCart', cart),
      );

      return result;
    } catch (e) {
      final failure = UnknownFailure(
        message: 'Erro inesperado ao adicionar item: $e',
      );
      logError('AddToCart', failure);
      return Left(failure);
    }
  }
}

/// Parâmetros para adicionar produto ao carrinho
class AddToCartParams extends Equatable {
  final String productId;
  final String productName;
  final Money price;
  final String productImageUrl;
  final Quantity quantity;

  const AddToCartParams({
    required this.productId,
    required this.productName,
    required this.price,
    required this.productImageUrl,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    price,
    productImageUrl,
    quantity,
  ];

  @override
  String toString() {
    return 'AddToCartParams(productId: $productId, productName: $productName, '
        'price: ${price.formatted}, quantity: ${quantity.value})';
  }
}
