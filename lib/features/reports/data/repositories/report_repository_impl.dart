import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../../../orders/domain/repositories/order_repository.dart';
import '../../../orders/domain/entities/order_entity.dart';

class ReportRepositoryImpl implements ReportRepository {
  final OrderRepository _orderRepository;

  ReportRepositoryImpl(this._orderRepository);

  @override
  Future<Report> generateSalesReport(DateTime start, DateTime end) async {
    final result = await _orderRepository.getOrdersByDateRange(start, end);
    final orders = result.getOrElse(() => []);
    final completedOrders = orders.where((o) => o.status == OrderStatus.completed).toList();

    double totalValue = completedOrders.fold(0.0, (sum, o) => sum + o.total.value);

    Map<String, double> dailyTotals = {};
    for (var order in completedOrders) {
      String dateKey = "${order.createdAt.day}/${order.createdAt.month}";
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0.0) + order.total.value;
    }

    List<ReportDataPoint> data = dailyTotals.entries.map((e) => ReportDataPoint(
      label: e.key,
      value: e.value,
    )).toList();

    return Report(
      id: 'sales_${DateTime.now().millisecondsSinceEpoch}',
      type: ReportType.sales,
      start: start,
      end: end,
      data: data,
      totalValue: totalValue,
      totalCount: completedOrders.length,
    );
  }

  @override
  Future<Report> generateProductsReport(DateTime start, DateTime end) async {
    final result = await _orderRepository.getOrdersByDateRange(start, end);
    final orders = result.getOrElse(() => []);
    final completedOrders = orders.where((o) => o.status == OrderStatus.completed).toList();

    Map<String, _ProductStats> productStats = {};
    int totalItems = 0;

    for (var order in completedOrders) {
      for (var item in order.items) {
        final stats = productStats[item.productName] ?? _ProductStats();
        stats.count += item.quantity.value.toInt();
        stats.totalValue += item.totalPrice.value;
        productStats[item.productName] = stats;
        totalItems += item.quantity.value.toInt();
      }
    }

    List<ReportDataPoint> data = productStats.entries.map((e) => ReportDataPoint(
      label: e.key,
      value: e.value.totalValue,
      count: e.value.count,
      percentage: totalItems > 0 ? (e.value.count / totalItems) * 100 : 0.0,
    )).toList();

    data.sort((a, b) => b.count.compareTo(a.count));

    return Report(
      id: 'products_${DateTime.now().millisecondsSinceEpoch}',
      type: ReportType.products,
      start: start,
      end: end,
      data: data,
      totalValue: completedOrders.fold(0.0, (sum, o) => sum + o.total.value),
      totalCount: totalItems,
    );
  }

  @override
  Future<Report> generateFinancialReport(DateTime start, DateTime end) async {
    final result = await _orderRepository.getOrdersByDateRange(start, end);
    final orders = result.getOrElse(() => []);
    final completedOrders = orders.where((o) => o.status == OrderStatus.completed).toList();

    Map<String, double> paymentMethods = {};
    for (var order in completedOrders) {
      String method = order.paymentMethod.displayName;
      paymentMethods[method] = (paymentMethods[method] ?? 0.0) + order.total.value;
    }

    double totalValue = completedOrders.fold(0.0, (sum, o) => sum + o.total.value);

    List<ReportDataPoint> data = paymentMethods.entries.map((e) => ReportDataPoint(
      label: e.key,
      value: e.value,
      percentage: totalValue > 0 ? (e.value / totalValue) * 100 : 0.0,
    )).toList();

    return Report(
      id: 'financial_${DateTime.now().millisecondsSinceEpoch}',
      type: ReportType.financial,
      start: start,
      end: end,
      data: data,
      totalValue: totalValue,
      totalCount: completedOrders.length,
    );
  }
}

class _ProductStats {
  int count = 0;
  double totalValue = 0.0;
}
