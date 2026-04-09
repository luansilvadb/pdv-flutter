import '../../../../shared/domain/entities/base_entity.dart';

enum PromotionType { PERCENTAGE, FIXED, BOGO, COMBO }

class Promotion extends Entity {
  @override
  final String id;
  final String name;
  final PromotionType type;
  final double value;
  final List<int> daysOfWeek;
  final String? startTime;
  final String? endTime;
  final double minSubtotal;
  final List<String> applicableProductIds;
  final int? buyQuantity;
  final int? getQuantity;
  final Map<String, int>? comboItems;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  Promotion({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    this.daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
    this.startTime,
    this.endTime,
    this.minSubtotal = 0.0,
    this.applicableProductIds = const [],
    this.buyQuantity,
    this.getQuantity,
    this.comboItems,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool isActive() {
    final now = DateTime.now();
    if (!daysOfWeek.contains(now.weekday)) return false;

    if (startTime != null && endTime != null) {
      final startParts = startTime!.split(':');
      final endParts = endTime!.split(':');
      final nowMinutes = now.hour * 60 + now.minute;
      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      if (nowMinutes < startMinutes || nowMinutes > endMinutes) return false;
    }

    return true;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        value,
        daysOfWeek,
        startTime,
        endTime,
        minSubtotal,
        applicableProductIds,
        buyQuantity,
        getQuantity,
        comboItems,
        createdAt,
        updatedAt,
      ];
}
