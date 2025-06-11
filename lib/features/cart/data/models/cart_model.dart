import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_item_model.dart';

/// Model que representa o carrinho completo com serialização JSON
class CartModel extends CartEntity {
  CartModel({
    required super.id,
    required super.items,
    required super.createdAt,
    super.updatedAt,
  });

  /// Factory constructor para criar a partir de JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final items =
        itemsJson
            .map(
              (itemJson) =>
                  CartItemModel.fromJson(itemJson as Map<String, dynamic>),
            )
            .toList();

    return CartModel(
      id: json['id'] as String,
      items: items,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items':
          items.map((item) => CartItemModel.fromEntity(item).toJson()).toList(),
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Factory para criar a partir de Entity
  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      id: entity.id,
      items: entity.items,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converte para Entity
  CartEntity toEntity() {
    return CartEntity(
      id: id,
      items: items,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Factory para criar carrinho vazio
  factory CartModel.empty() {
    final now = DateTime.now();
    return CartModel(
      id: 'cart_${now.millisecondsSinceEpoch}',
      items: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Cria uma cópia com novos valores
  @override
  CartModel copyWith({
    String? id,
    List<CartItemEntity>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'CartModel(id: $id, itemCount: $itemCount, '
        'totalAmount: $totalAmount, items: ${items.length})';
  }
}
