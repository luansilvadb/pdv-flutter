import '../../../../shared/domain/entities/base_entity.dart';

enum InventoryUnit { kg, un, lt, gr }

enum InventoryStatus { inStock, lowStock, outOfStock }

class InventoryItem extends Entity {
  @override
  final String id;
  final String productId;
  final double currentQuantity;
  final double minQuantity;
  final InventoryUnit unit;
  final DateTime lastRestock;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  InventoryItem({
    required this.id,
    required this.productId,
    required this.currentQuantity,
    required this.minQuantity,
    required this.unit,
    required this.lastRestock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  InventoryStatus get status {
    if (currentQuantity <= 0) return InventoryStatus.outOfStock;
    if (currentQuantity <= minQuantity) return InventoryStatus.lowStock;
    return InventoryStatus.inStock;
  }

  InventoryItem copyWith({
    String? id,
    String? productId,
    double? currentQuantity,
    double? minQuantity,
    InventoryUnit? unit,
    DateTime? lastRestock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      minQuantity: minQuantity ?? this.minQuantity,
      unit: unit ?? this.unit,
      lastRestock: lastRestock ?? this.lastRestock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    currentQuantity,
    minQuantity,
    unit,
    lastRestock,
    createdAt,
    updatedAt,
  ];
}
