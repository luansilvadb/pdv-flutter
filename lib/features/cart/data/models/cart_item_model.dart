import '../../domain/entities/cart_item_entity.dart';
import '../../../../shared/domain/value_objects/money.dart';
import '../../../../shared/domain/value_objects/quantity.dart';

/// Model que representa um item do carrinho com serialização JSON
/// Usa composição em vez de herança para manter separação das camadas
class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final Money price;
  final String productImageUrl;
  final Quantity quantity;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.productImageUrl,
    required this.quantity,
  });

  /// Factory constructor para criar a partir de JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      price: Money((json['productPrice'] as num).toDouble()),
      productImageUrl: json['productImageUrl'] as String,
      quantity: Quantity(json['quantity'] as int),
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': price.value,
      'productImageUrl': productImageUrl,
      'quantity': quantity.value,
      'subtotal': subtotal,
    };
  }

  /// Factory para criar a partir de Entity
  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      price: entity.price,
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
      price: price,
      productImageUrl: productImageUrl,
      quantity: quantity,
    );
  }

  /// Propriedades calculadas para compatibilidade
  Money get totalPrice => Money(price.value * quantity.value);
  double get productPrice => price.value;
  double get subtotal => totalPrice.value;

  /// Cria uma cópia com novos valores
  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    Money? price,
    String? productImageUrl,
    Quantity? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CartItemModel(id: $id, productId: $productId, productName: $productName, '
        'price: ${price.formatted}, quantity: ${quantity.value}, subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.id == id &&
        other.productId == productId &&
        other.productName == productName &&
        other.price == price &&
        other.productImageUrl == productImageUrl &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productId,
      productName,
      price,
      productImageUrl,
      quantity,
    );
  }
}
