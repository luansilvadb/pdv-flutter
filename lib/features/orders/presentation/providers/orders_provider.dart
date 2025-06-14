import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/get_all_orders.dart';
import '../../domain/usecases/get_orders_by_date_range.dart';
import '../../../../shared/domain/use_cases/base_use_case.dart';
import '../../../../core/services/dependency_injection.dart';
import 'orders_state.dart';

/// StateNotifier para gerenciar o estado dos pedidos
class OrdersNotifier extends StateNotifier<OrdersState> {
  final CreateOrder _createOrder;
  final GetAllOrders _getAllOrders;
  final GetOrdersByDateRange _getOrdersByDateRange;

  OrdersNotifier(
    this._createOrder,
    this._getAllOrders,
    this._getOrdersByDateRange,
  ) : super(OrdersState.empty);

  /// Carrega todos os pedidos
  Future<void> loadAllOrders() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getAllOrders(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false, 
          error: failure.message,
        );
      },
      (orders) {
        state = state.copyWith(
          isLoading: false,
          orders: orders,
          allOrders: orders,
          error: null,
        );
      },
    );
  }

  /// Cria um novo pedido
  Future<bool> createOrder(OrderEntity order) async {
    final result = await _createOrder(order);

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (createdOrder) {
        // Adiciona o novo pedido à lista existente
        final updatedOrders = [createdOrder, ...state.orders];
        state = state.copyWith(
          orders: updatedOrders,
          error: null,
        );
        return true;
      },
    );
  }

  /// Filtra pedidos por período
  Future<void> loadOrdersByDateRange(DateTime startDate, DateTime endDate) async {
    state = state.copyWith(isLoading: true, error: null);

    final params = GetOrdersByDateRangeParams(
      startDate: startDate,
      endDate: endDate,
    );
    
    final result = await _getOrdersByDateRange(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false, 
          error: failure.message,
        );
      },
      (orders) {
        state = state.copyWith(
          isLoading: false,
          orders: orders,
          error: null,
        );
      },
    );
  }

  /// Filtra pedidos por status
  void filterOrdersByStatus(OrderStatus? status) {
    if (status == null) {
      // Se status é null, mostra todos os pedidos
      state = state.copyWith(orders: state.allOrders);
      return;
    }
    final filteredOrders = state.allOrders
        .where((order) => order.status == status)
        .toList();
    state = state.copyWith(orders: filteredOrders);
  }

  /// Limpa os pedidos (útil para filtros)
  void clearOrders() {
    state = state.copyWith(orders: [], error: null);
  }

  /// Limpa erros
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Obtém pedidos de hoje
  Future<void> loadTodayOrders() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    
    await loadOrdersByDateRange(startOfDay, endOfDay);
  }

  /// Obtém pedidos da semana atual
  Future<void> loadThisWeekOrders() async {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    await loadOrdersByDateRange(startOfWeek, endOfWeek);
  }

  /// Obtém pedidos do mês atual
  Future<void> loadThisMonthOrders() async {
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final endOfMonth = DateTime(today.year, today.month + 1, 0);
    
    await loadOrdersByDateRange(startOfMonth, endOfMonth);
  }
}

/// Provider principal para o notifier de pedidos
final ordersNotifierProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(
    sl<CreateOrder>(),
    sl<GetAllOrders>(),
    sl<GetOrdersByDateRange>(),
  );
});

/// Provider conveniente para acessar apenas a lista de pedidos
final ordersListProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(ordersNotifierProvider).orders;
});

/// Provider para verificar se está carregando
final isLoadingOrdersProvider = Provider<bool>((ref) {
  return ref.watch(ordersNotifierProvider).isLoading;
});

/// Provider para obter erro
final ordersErrorProvider = Provider<String?>((ref) {
  return ref.watch(ordersNotifierProvider).error;
});

/// Provider para obter estatísticas
final ordersStatisticsProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(ordersNotifierProvider).statistics;
});

/// Provider para pedidos concluídos
final completedOrdersProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(ordersNotifierProvider).completedOrders;
});

/// Provider para pedidos pendentes
final pendingOrdersProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(ordersNotifierProvider).pendingOrders;
});

/// Provider para pedidos cancelados
final cancelledOrdersProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(ordersNotifierProvider).cancelledOrders;
});

/// Provider para total de receita
final totalRevenueProvider = Provider<double>((ref) {
  return ref.watch(ordersNotifierProvider).totalRevenue;
});
