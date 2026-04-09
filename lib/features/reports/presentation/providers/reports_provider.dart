import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../../../../core/services/dependency_injection.dart';

class ReportsState {
  final AsyncValue<Report?> salesReport;
  final AsyncValue<Report?> productsReport;
  final AsyncValue<Report?> financialReport;
  final DateTimeRange period;

  ReportsState({
    this.salesReport = const AsyncValue.data(null),
    this.productsReport = const AsyncValue.data(null),
    this.financialReport = const AsyncValue.data(null),
    required this.period,
  });

  ReportsState copyWith({
    AsyncValue<Report?>? salesReport,
    AsyncValue<Report?>? productsReport,
    AsyncValue<Report?>? financialReport,
    DateTimeRange? period,
  }) {
    return ReportsState(
      salesReport: salesReport ?? this.salesReport,
      productsReport: productsReport ?? this.productsReport,
      financialReport: financialReport ?? this.financialReport,
      period: period ?? this.period,
    );
  }
}

class DateTimeRange {
  final DateTime start;
  final DateTime end;
  DateTimeRange(this.start, this.end);
}

class ReportsNotifier extends StateNotifier<ReportsState> {
  final ReportRepository _repository;

  ReportsNotifier(this._repository) : super(ReportsState(
    period: DateTimeRange(
      DateTime.now().subtract(const Duration(days: 7)),
      DateTime.now(),
    ),
  )) {
    generateAllReports();
  }

  Future<void> setPeriod(DateTime start, DateTime end) async {
    state = state.copyWith(period: DateTimeRange(start, end));
    await generateAllReports();
  }

  Future<void> generateAllReports() async {
    await Future.wait([
      _generateSalesReport(),
      _generateProductsReport(),
      _generateFinancialReport(),
    ]);
  }

  Future<void> _generateSalesReport() async {
    state = state.copyWith(salesReport: const AsyncValue.loading());
    try {
      final report = await _repository.generateSalesReport(state.period.start, state.period.end);
      state = state.copyWith(salesReport: AsyncValue.data(report));
    } catch (e, st) {
      state = state.copyWith(salesReport: AsyncValue.error(e, st));
    }
  }

  Future<void> _generateProductsReport() async {
    state = state.copyWith(productsReport: const AsyncValue.loading());
    try {
      final report = await _repository.generateProductsReport(state.period.start, state.period.end);
      state = state.copyWith(productsReport: AsyncValue.data(report));
    } catch (e, st) {
      state = state.copyWith(productsReport: AsyncValue.error(e, st));
    }
  }

  Future<void> _generateFinancialReport() async {
    state = state.copyWith(financialReport: const AsyncValue.loading());
    try {
      final report = await _repository.generateFinancialReport(state.period.start, state.period.end);
      state = state.copyWith(financialReport: AsyncValue.data(report));
    } catch (e, st) {
      state = state.copyWith(financialReport: AsyncValue.error(e, st));
    }
  }
}

final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  return ReportsNotifier(sl<ReportRepository>());
});
