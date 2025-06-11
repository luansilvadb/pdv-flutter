import '../../domain/entities/cart_item_entity.dart';

/// Model que representa um item do carrinho com serialização JSON
class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productPrice,
    required super.productImageUrl,
    required super.quantity,
  });

  /// Factory constructor para criar a partir de JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productImageUrl: json['productImageUrl'] as String,
      quantity: json['quantity'] as int,
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  /// Factory para criar a partir de Entity
  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      productPrice: entity.productPrice,
      productImageUrl: entity.productImageUrl,
      quantity: entity.quantity,
    );
  }

  /// Converte para Entity
  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      productId: productId,
      productName: productName,
      productPrice: productPrice,
      productImageUrl: productImageUrl,
      quantity: quantity,
    );
  }

  /// Cria uma cópia com novos valores
  @override
  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    double? productPrice,
    String? productImageUrl,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CartItemModel(id: $id, productId: $productId, productName: $productName, '
        'productPrice: $productPrice, quantity: $quantity, subtotal: $subtotal)';
  }
}
