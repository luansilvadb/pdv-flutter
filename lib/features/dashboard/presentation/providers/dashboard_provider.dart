import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../inventory/presentation/providers/inventory_provider.dart';
import '../../../inventory/domain/entities/inventory_item.dart';

class DashboardKPIs {
  final double dailyRevenue;
  final int activeOrdersCount;
  final double averageTicket;
  final int lowStockAlerts;

  DashboardKPIs({
    required this.dailyRevenue,
    required this.activeOrdersCount,
    required this.averageTicket,
    required this.lowStockAlerts,
  });
}

class DashboardNotifier extends StateNotifier<DashboardKPIs> {
  final Ref _ref;

  DashboardNotifier(this._ref) : super(DashboardKPIs(
    dailyRevenue: 0,
    activeOrdersCount: 0,
    averageTicket: 0,
    lowStockAlerts: 0,
  )) {
    _init();
  }

  void _init() {
    _updateKPIs();
    _ref.listen(ordersNotifierProvider, (_, __) => _updateKPIs());
    _ref.listen(inventoryProvider, (_, __) => _updateKPIs());
  }

  void _updateKPIs() {
    final ordersState = _ref.read(ordersNotifierProvider);
    final inventoryState = _ref.read(inventoryProvider);

    final now = DateTime.now();
    final todayOrders = ordersState.allOrders.where((o) =>
      o.createdAt.year == now.year &&
      o.createdAt.month == now.month &&
      o.createdAt.day == now.day
    ).toList();

    final dailyRevenue = todayOrders.fold(0.0, (sum, o) => sum + o.total.value);
    final activeOrders = ordersState.allOrders.where((o) =>
      o.status.name == 'pending' || o.status.name == 'processing'
    ).length;

    final averageTicket = todayOrders.isEmpty ? 0.0 : dailyRevenue / todayOrders.length;
    final lowStockCount = inventoryState.items.where((i) => i.status == InventoryStatus.LOW_STOCK).length;

    state = DashboardKPIs(
      dailyRevenue: dailyRevenue,
      activeOrdersCount: activeOrders,
      averageTicket: averageTicket,
      lowStockAlerts: lowStockCount,
    );
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardKPIs>((ref) {
  return DashboardNotifier(ref);
});
