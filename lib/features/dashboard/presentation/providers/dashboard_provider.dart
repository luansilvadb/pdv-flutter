import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../inventory/presentation/providers/inventory_provider.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../inventory/domain/entities/inventory_item.dart';

class DashboardState {
  final double todaySales;
  final int activeOrders;
  final double averageTicket;
  final int lowStockItems;

  DashboardState({
    this.todaySales = 0.0,
    this.activeOrders = 0,
    this.averageTicket = 0.0,
    this.lowStockItems = 0,
  });
}

final dashboardProvider = Provider<DashboardState>((ref) {
  final ordersAsync = ref.watch(ordersNotifierProvider);
  final inventoryAsync = ref.watch(inventoryProvider);

  double todaySales = 0.0;
  int activeOrders = 0;
  double totalSales = 0.0;
  int completedCount = 0;
  int lowStockCount = 0;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final orders = ordersAsync.orders;
  for (var order in orders) {
    if (order.status == OrderStatus.pending ||
        order.status == OrderStatus.processing) {
      activeOrders++;
    }

    if (order.status == OrderStatus.completed) {
      totalSales += order.total.value;
      completedCount++;

      if (order.createdAt.isAfter(today)) {
        todaySales += order.total.value;
      }
    }
  }

  inventoryAsync.whenData((items) {
    lowStockCount =
        items
            .where(
              (i) =>
                  i.status == InventoryStatus.lowStock ||
                  i.status == InventoryStatus.outOfStock,
            )
            .length;
  });

  return DashboardState(
    todaySales: todaySales,
    activeOrders: activeOrders,
    averageTicket: completedCount > 0 ? totalSales / completedCount : 0.0,
    lowStockItems: lowStockCount,
  );
});
