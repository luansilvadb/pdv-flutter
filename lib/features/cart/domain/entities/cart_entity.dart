import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

/// Entity que representa o carrinho de compras completo
class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double totalAmount;
  final int itemCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartEntity({
    required this.id,
    required this.items,
    required this.createdAt,
    DateTime? updatedAt,
  }) : totalAmount = _calculateTotalAmount(items),
       itemCount = _calculateItemCount(items),
       updatedAt = updatedAt ?? DateTime.now();

  /// Calcula o valor total do carrinho
  static double _calculateTotalAmount(List<CartItemEntity> items) {
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Calcula a quantidade total de itens
  static int _calculateItemCount(List<CartItemEntity> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Retorna o valor total do carrinho
  double getTotalAmount() => totalAmount;

  /// Retorna a quantidade total de itens
  int getItemCount() => itemCount;

  /// Verifica se o carrinho está vazio
  bool get isEmpty => items.isEmpty;

  /// Verifica se o carrinho não está vazio
  bool get isNotEmpty => items.isNotEmpty;

  /// Encontra um item por ID do produto
  CartItemEntity? findItemByProductId(String productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Verifica se o produto já existe no carrinho
  bool containsProduct(String productId) {
    return items.any((item) => item.productId == productId);
  }

  /// Cria uma cópia com novos valores
  CartEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    items,
    totalAmount,
    itemCount,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'CartEntity(id: $id, itemCount: $itemCount, '
        'totalAmount: $totalAmount, items: ${items.length})';
  }
}
