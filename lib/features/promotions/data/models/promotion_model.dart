import '../../domain/entities/promotion.dart';

class PromotionModel extends Promotion {
  PromotionModel({
    required super.id,
    required super.name,
    required super.type,
    required super.value,
    required super.conditions,
    super.createdAt,
    super.updatedAt,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      name: json['name'],
      type: PromotionType.values.firstWhere((e) => e.toString() == json['type']),
      value: json['value'].toDouble(),
      conditions: Map<String, dynamic>.from(json['conditions']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'value': value,
      'conditions': conditions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PromotionModel.fromEntity(Promotion entity) {
    return PromotionModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      value: entity.value,
      conditions: entity.conditions,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
