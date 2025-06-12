import '../../../../shared/domain/entities/base_entity.dart';
import '../../../../shared/domain/value_objects/money.dart';
import '../../../../shared/domain/value_objects/quantity.dart';
import 'cart_item_entity.dart';

/// Entity do carrinho seguindo princípios Clean Architecture
class CartEntity extends Entity {
  @override
  final String id;
  final List<CartItemEntity> items;
  final Money subtotal;
  final Money tax;
  final Money total;
  final Money discount;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  CartEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.discount = Money.zero,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Cria um carrinho vazio
  factory CartEntity.empty() {
    return CartEntity(
      id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
      items: [],
      subtotal: Money.zero,
      tax: Money.zero,
      total: Money.zero,
      discount: Money.zero,
    );
  }

  /// Verifica se o carrinho está vazio
  bool get isEmpty => items.isEmpty;

  /// Verifica se o carrinho tem itens
  bool get isNotEmpty => items.isNotEmpty;
  /// Quantidade total de itens no carrinho
  int get itemCount {
    return items.fold<int>(0, (sum, item) => sum + item.quantity.value);
  }

  /// Propriedade para compatibilidade com código existente
  Quantity get totalQuantity {
    return Quantity(itemCount);
  }

  /// Valor total bruto dos itens (sem descontos/impostos)
  double get totalAmount => total.value;

  /// Valor total sem impostos e descontos
  Money get rawSubtotal {
    final total = items.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice.value,
    );
    return Money(total);
  }

  /// Encontra um item pelo ID do produto
  CartItemEntity? findItemByProductId(String productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Verifica se contém um produto específico
  bool containsProduct(String productId) {
    return items.any((item) => item.productId == productId);
  }

  /// Aplica desconto ao carrinho
  CartEntity applyDiscount(Money discountAmount) {
    final newSubtotal = rawSubtotal;
    final newDiscount = discountAmount;
    final discountedAmount = newSubtotal - newDiscount;
    final newTax = discountedAmount.percentage(10.0); // 10% de imposto
    final newTotal = discountedAmount + newTax;

    return copyWith(
      subtotal: discountedAmount,
      tax: newTax,
      total: newTotal,
      discount: newDiscount,
      updatedAt: DateTime.now(),
    );
  }

  /// Recalcula totais com base nos itens atuais
  CartEntity recalculateTotals() {
    final newSubtotal = rawSubtotal;
    final discountedAmount = newSubtotal - discount;
    final newTax = discountedAmount.percentage(10.0); // 10% de imposto
    final newTotal = discountedAmount + newTax;

    return copyWith(
      subtotal: discountedAmount,
      tax: newTax,
      total: newTotal,
      updatedAt: DateTime.now(),
    );
  }
  /// Adiciona um item ao carrinho
  CartEntity addItem(CartItemEntity newItem) {
    final existingItemIndex = items.indexWhere(
      (item) => item.productId == newItem.productId,
    );

    List<CartItemEntity> updatedItems;

    if (existingItemIndex >= 0) {
      // Se o item já existe, atualiza a quantidade
      final existingItem = items[existingItemIndex];
      final newQuantity = Quantity(existingItem.quantity.value + newItem.quantity.value);
      final updatedItem = existingItem.copyWith(quantity: newQuantity);
      updatedItems = List.from(items);
      updatedItems[existingItemIndex] = updatedItem;
    } else {
      // Se é um novo item, adiciona à lista
      updatedItems = [...items, newItem];
    }

    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    ).recalculateTotals();
  }

  /// Remove um item do carrinho
  CartEntity removeItem(String productId) {
    final updatedItems =
        items.where((item) => item.productId != productId).toList();

    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    ).recalculateTotals();
  }
  /// Atualiza a quantidade de um item
  CartEntity updateItemQuantity(String productId, Quantity newQuantity) {
    if (newQuantity.isEmpty) {
      return removeItem(productId);
    }

    final updatedItems = items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    ).recalculateTotals();
  }

  /// Limpa todos os itens do carrinho
  CartEntity clear() {
    return copyWith(
      items: [],
      subtotal: Money.zero,
      tax: Money.zero,
      total: Money.zero,
      discount: Money.zero,
      updatedAt: DateTime.now(),
    );
  }

  /// Cria uma cópia com valores alterados
  CartEntity copyWith({
    String? id,
    List<CartItemEntity>? items,
    Money? subtotal,
    Money? tax,
    Money? total,
    Money? discount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      discount: discount ?? this.discount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CartEntity(id: $id, items: ${items.length}, '
        'subtotal: ${subtotal.formatted}, tax: ${tax.formatted}, '
        'total: ${total.formatted}, discount: ${discount.formatted})';
  }

  @override
  List<Object?> get props => [
    id,
    items,
    subtotal,
    tax,
    total,
    discount,
    createdAt,
    updatedAt,
  ];
}
