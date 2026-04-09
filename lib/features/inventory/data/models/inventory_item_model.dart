import '../../domain/entities/inventory_item.dart';

class InventoryItemModel extends InventoryItem {
  InventoryItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.currentQuantity,
    required super.minQuantity,
    required super.unit,
    super.lastRestock,
    super.createdAt,
    super.updatedAt,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      currentQuantity: (json['currentQuantity'] as num).toDouble(),
      minQuantity: (json['minQuantity'] as num).toDouble(),
      unit: InventoryUnit.values.firstWhere(
        (e) => e.toString().split('.').last == json['unit'],
        orElse: () => InventoryUnit.UN,
      ),
      lastRestock: DateTime.parse(json['lastRestock']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'currentQuantity': currentQuantity,
      'minQuantity': minQuantity,
      'unit': unit.toString().split('.').last,
      'lastRestock': lastRestock.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory InventoryItemModel.fromEntity(InventoryItem entity) {
    return InventoryItemModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      currentQuantity: entity.currentQuantity,
      minQuantity: entity.minQuantity,
      unit: entity.unit,
      lastRestock: entity.lastRestock,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
