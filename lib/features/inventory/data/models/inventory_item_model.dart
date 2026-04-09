import '../../domain/entities/inventory_item.dart';

class InventoryItemModel extends InventoryItem {
  InventoryItemModel({
    required super.id,
    required super.productId,
    required super.currentQuantity,
    required super.minQuantity,
    required super.unit,
    required super.lastRestock,
    super.createdAt,
    super.updatedAt,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'],
      productId: json['productId'],
      currentQuantity: json['currentQuantity'].toDouble(),
      minQuantity: json['minQuantity'].toDouble(),
      unit: InventoryUnit.values.firstWhere((e) => e.toString() == json['unit']),
      lastRestock: DateTime.parse(json['lastRestock']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'currentQuantity': currentQuantity,
      'minQuantity': minQuantity,
      'unit': unit.toString(),
      'lastRestock': lastRestock.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory InventoryItemModel.fromEntity(InventoryItem entity) {
    return InventoryItemModel(
      id: entity.id,
      productId: entity.productId,
      currentQuantity: entity.currentQuantity,
      minQuantity: entity.minQuantity,
      unit: entity.unit,
      lastRestock: entity.lastRestock,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
