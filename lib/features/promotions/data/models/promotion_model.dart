import '../../domain/entities/promotion.dart';

class PromotionModel extends Promotion {
  PromotionModel({
    required super.id,
    required super.name,
    required super.type,
    required super.value,
    super.daysOfWeek,
    super.startTime,
    super.endTime,
    super.minSubtotal,
    super.applicableProductIds,
    super.buyQuantity,
    super.getQuantity,
    super.comboItems,
    super.createdAt,
    super.updatedAt,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'],
      name: json['name'],
      type: PromotionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      value: (json['value'] as num).toDouble(),
      daysOfWeek: List<int>.from(json['daysOfWeek']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      minSubtotal: (json['minSubtotal'] as num).toDouble(),
      applicableProductIds: List<String>.from(json['applicableProductIds']),
      buyQuantity: json['buyQuantity'],
      getQuantity: json['getQuantity'],
      comboItems: json['comboItems'] != null ? Map<String, int>.from(json['comboItems']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'value': value,
      'daysOfWeek': daysOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'minSubtotal': minSubtotal,
      'applicableProductIds': applicableProductIds,
      'buyQuantity': buyQuantity,
      'getQuantity': getQuantity,
      'comboItems': comboItems,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
