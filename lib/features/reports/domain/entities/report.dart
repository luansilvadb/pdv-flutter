import '../../../../shared/domain/entities/base_entity.dart';

enum ReportType { SALES, PRODUCTS, FINANCIAL }

class ReportDataPoint {
  final String label;
  final double value;
  final int count;
  final double percentage;

  ReportDataPoint({
    required this.label,
    required this.value,
    required this.count,
    required this.percentage,
  });
}

class Report extends Entity {
  @override
  final String id;
  final ReportType type;
  final DateTime start;
  final DateTime end;
  final List<ReportDataPoint> data;
  final double totalValue;
  final int totalCount;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  Report({
    required this.id,
    required this.type,
    required this.start,
    required this.end,
    required this.data,
    required this.totalValue,
    required this.totalCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        type,
        start,
        end,
        data,
        totalValue,
        totalCount,
        createdAt,
        updatedAt,
      ];
}
