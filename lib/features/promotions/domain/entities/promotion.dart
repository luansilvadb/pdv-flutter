import '../../../../shared/domain/entities/base_entity.dart';

enum PromotionType { percentage, fixed, buyGet, combo }

class Promotion extends Entity {
  @override
  final String id;
  final String name;
  final PromotionType type;
  final double value;
  final Map<String, dynamic> conditions;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  Promotion({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.conditions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [id, name, type, value, conditions, createdAt, updatedAt];

  Promotion copyWith({
    String? id,
    String? name,
    PromotionType? type,
    double? value,
    Map<String, dynamic>? conditions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      conditions: conditions ?? this.conditions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
