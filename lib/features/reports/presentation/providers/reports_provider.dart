import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/entities/report.dart';

class ReportsState {
  final List<Report> reports;
  final bool isLoading;
  final String? error;

  const ReportsState({
    this.reports = const [],
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    List<Report>? reports,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ReportsNotifier extends StateNotifier<ReportsState> {
  final Ref _ref;

  ReportsNotifier(this._ref) : super(const ReportsState());

  Future<Report> generateSalesReport(DateTime start, DateTime end) async {
    state = state.copyWith(isLoading: true);

    final allOrders = _ref.read(ordersNotifierProvider).allOrders;
    final filteredOrders = allOrders.where((o) =>
      o.createdAt.isAfter(start) && o.createdAt.isBefore(end)
    ).toList();

    final totalValue = filteredOrders.fold(0.0, (sum, o) => sum + o.total.value);
    final totalCount = filteredOrders.length;

    // Agrupar por dia
    final Map<String, double> categoryTotals = {};
    final Map<String, int> categoryCounts = {};

    for (var o in filteredOrders) {
      for (var item in o.items) {
        final category = item.productName.split(' ').first; // Simplificado: usa primeira palavra do nome como categoria
        final itemTotal = item.price.value * item.quantity.value;
        categoryTotals[category] = (categoryTotals[category] ?? 0) + itemTotal;
        categoryCounts[category] = (categoryCounts[category] ?? 0) + item.quantity.value;
      }
    }

    final dataPoints = categoryTotals.entries.map((e) => ReportDataPoint(
      label: e.key,
      value: e.value,
      count: categoryCounts[e.key] ?? 0,
      percentage: totalValue > 0 ? (e.value / totalValue) * 100 : 0,
    )).toList();

    final report = Report(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      type: ReportType.SALES,
      start: start,
      end: end,
      data: dataPoints,
      totalValue: totalValue,
      totalCount: totalCount,
    );

    state = state.copyWith(isLoading: false, reports: [...state.reports, report]);
    return report;
  }
}

final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  return ReportsNotifier(ref);
});
