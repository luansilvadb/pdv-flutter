import 'package:equatable/equatable.dart';

/// Entity que representa um item no carrinho de compras
class CartItemEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final double productPrice;
  final String productImageUrl;
  final int quantity;
  final double subtotal;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.quantity,
  }) : subtotal = productPrice * quantity;

  /// Cria uma cópia com novos valores
  CartItemEntity copyWith({
    String? id,
    String? productId,
    String? productName,
    double? productPrice,
    String? productImageUrl,
    int? quantity,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    productPrice,
    productImageUrl,
    quantity,
    subtotal,
  ];

  @override
  String toString() {
    return 'CartItemEntity(id: $id, productId: $productId, productName: $productName, '
        'productPrice: $productPrice, quantity: $quantity, subtotal: $subtotal)';
  }
}
