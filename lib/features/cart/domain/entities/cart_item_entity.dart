import 'package:equatable/equatable.dart';
import '../../../../shared/domain/value_objects/quantity.dart';
import '../../../../shared/domain/value_objects/money.dart';

/// Entity que representa um item no carrinho de compras
class CartItemEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final Money price;
  final String productImageUrl;
  final Quantity quantity;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.productImageUrl,
    required this.quantity,
  });

  /// Preço total do item (preço unitário * quantidade)
  Money get totalPrice => Money(price.value * quantity.value);

  /// Getter para compatibilidade com código antigo
  double get productPrice => price.value;

  /// Getter para compatibilidade com código antigo
  double get subtotal => totalPrice.value;
  /// Cria uma cópia com novos valores
  CartItemEntity copyWith({
    String? id,
    String? productId,
    String? productName,
    Money? price,
    String? productImageUrl,
    Quantity? quantity,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Método factory para criar uma instância vazia do CartItemEntity
  /// Útil para casos onde precisamos de um valor padrão
  factory CartItemEntity.empty() {
    return CartItemEntity(
      id: '',
      productId: '',
      productName: '',
      price: Money(0),
      productImageUrl: '',
      quantity: Quantity(0),
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    price,
    productImageUrl,
    quantity,
  ];

  @override
  String toString() {
    return 'CartItemEntity(id: $id, productId: $productId, productName: $productName, '
        'productPrice: $productPrice, quantity: $quantity, subtotal: $subtotal)';
  }
}
