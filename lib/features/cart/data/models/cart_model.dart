import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../../../shared/domain/value_objects/money.dart';
import 'cart_item_model.dart';

/// Model que representa o carrinho completo com serialização JSON
/// Usa composição em vez de herança para manter separação das camadas
class CartModel {
  final String id;
  final List<CartItemEntity> items;
  final Money subtotal;
  final Money tax;
  final Money total;
  final Money discount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.discount = Money.zero,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  /// Factory constructor para criar a partir de JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final items =
        itemsJson
            .map(
              (itemJson) =>
                  CartItemModel.fromJson(
                    itemJson as Map<String, dynamic>,
                  ).toEntity(),
            )
            .toList();

    return CartModel(
      id: json['id'] as String,
      items: items,
      subtotal: Money(json['subtotal'] as double? ?? 0.0),
      tax: Money(json['tax'] as double? ?? 0.0),
      total: Money(json['total'] as double? ?? 0.0),
      discount: Money(json['discount'] as double? ?? 0.0),
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
      'subtotal': subtotal.value,
      'tax': tax.value,
      'total': total.value,
      'discount': discount.value,
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
      subtotal: entity.subtotal,
      tax: entity.tax,
      total: entity.total,
      discount: entity.discount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converte para Entity
  CartEntity toEntity() {
    return CartEntity(
      id: id,
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
      discount: discount,
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
      subtotal: Money.zero,
      tax: Money.zero,
      total: Money.zero,
      discount: Money.zero,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Propriedades calculadas para compatibilidade com JSON
  int get itemCount {
    return items.fold<int>(0, (sum, item) => sum + item.quantity.value);
  }

  double get totalAmount => total.value;

  /// Cria uma cópia com novos valores
  CartModel copyWith({
    String? id,
    List<CartItemEntity>? items,
    Money? subtotal,
    Money? tax,
    Money? total,
    Money? discount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      discount: discount ?? this.discount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'CartModel(id: $id, itemCount: $itemCount, '
        'totalAmount: $totalAmount, items: ${items.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartModel &&
        other.id == id &&
        other.items == items &&
        other.subtotal == subtotal &&
        other.tax == tax &&
        other.total == total &&
        other.discount == discount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      items,
      subtotal,
      tax,
      total,
      discount,
      createdAt,
      updatedAt,
    );
  }
}
