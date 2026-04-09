import '../../../../shared/domain/entities/base_entity.dart';

enum InventoryUnit { KG, UN, LT, GR }

enum InventoryStatus { IN_STOCK, LOW_STOCK, OUT_OF_STOCK }

class InventoryItem extends Entity {
  @override
  final String id;
  final String productId;
  final String productName;
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
    required this.productName,
    required this.currentQuantity,
    required this.minQuantity,
    required this.unit,
    DateTime? lastRestock,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : lastRestock = lastRestock ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  InventoryStatus get status {
    if (currentQuantity <= 0) return InventoryStatus.OUT_OF_STOCK;
    if (currentQuantity <= minQuantity) return InventoryStatus.LOW_STOCK;
    return InventoryStatus.IN_STOCK;
  }

  InventoryItem copyWith({
    String? id,
    String? productId,
    String? productName,
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
      productName: productName ?? this.productName,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      minQuantity: minQuantity ?? this.minQuantity,
      unit: unit ?? this.unit,
      lastRestock: lastRestock ?? this.lastRestock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        currentQuantity,
        minQuantity,
        unit,
        lastRestock,
        createdAt,
        updatedAt,
      ];
}
