import 'dart:async';
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

  /// Carrega pedidos com paginação (primeira página)
  Future<void> loadOrdersPaginated({int pageSize = 20}) async {
    state = state.copyWith(
      isLoading: true, 
      error: null,
      currentPage: 0,
      pageSize: pageSize,
    );

    final result = await _getAllOrders(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false, 
          error: failure.message,
        );
      },
      (allOrders) {
        // Carrega apenas a primeira página
        final firstPageOrders = allOrders.take(pageSize).toList();
        final hasMore = allOrders.length > pageSize;
        
        state = state.copyWith(
          isLoading: false,
          orders: firstPageOrders,
          allOrders: allOrders,
          currentPage: 0,
          hasMorePages: hasMore,
          error: null,
        );
      },
    );
  }

  /// Carrega mais pedidos (próxima página)
  Future<void> loadMoreOrders() async {
    if (state.isLoadingMore || !state.hasMorePages) return;

    state = state.copyWith(isLoadingMore: true);

    // Simula delay de rede para melhor UX
    await Future.delayed(const Duration(milliseconds: 500));

    final nextPage = state.currentPage + 1;
    final startIndex = nextPage * state.pageSize;
    final endIndex = startIndex + state.pageSize;
    
    final nextPageOrders = state.allOrders
        .skip(startIndex)
        .take(state.pageSize)
        .toList();
    
    final updatedOrders = [...state.orders, ...nextPageOrders];
    final hasMore = endIndex < state.allOrders.length;

    state = state.copyWith(
      isLoadingMore: false,
      orders: updatedOrders,
      currentPage: nextPage,
      hasMorePages: hasMore,
    );
  }/// Cria um novo pedido
  Future<bool> createOrder(OrderEntity order) async {
    final result = await _createOrder(order);

    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (createdOrder) {
        // Adiciona o novo pedido às listas existentes (tanto orders quanto allOrders)
        final updatedOrders = [createdOrder, ...state.orders];
        final updatedAllOrders = [createdOrder, ...state.allOrders];
        
        // Força atualização imediata do estado para garantir reatividade
        state = state.copyWith(
          orders: updatedOrders,
          allOrders: updatedAllOrders,
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
        // IMPORTANTE: Para os métodos de filtro por data, apenas atualiza orders,
        // mas mantém allOrders intacto para não quebrar a reatividade dos filtros
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

  /// Aplica filtros combinados de status e período
  void applyFilters({
    OrderStatus? statusFilter,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    List<OrderEntity> filteredOrders = List.from(state.allOrders);

    // Aplica filtro de status se especificado
    if (statusFilter != null) {
      filteredOrders = filteredOrders
          .where((order) => order.status == statusFilter)
          .toList();
    }

    // Aplica filtro de período se especificado
    if (startDate != null && endDate != null) {
      filteredOrders = filteredOrders
          .where((order) {
            final orderDate = order.createdAt;
            return orderDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                   orderDate.isBefore(endDate.add(const Duration(days: 1)));
          })
          .toList();
    }

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

/// Provider conveniente para acessar apenas a lista de pedidos (com filtros aplicados)
final ordersListProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(filteredOrdersProvider);
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

/// Provider para pedidos concluídos (baseado em filteredOrdersProvider para reatividade)
final completedOrdersProvider = Provider<List<OrderEntity>>((ref) {
  final filteredOrders = ref.watch(filteredOrdersProvider);
  return filteredOrders.where((order) => order.isCompleted).toList();
});

/// Provider para pedidos pendentes (baseado em filteredOrdersProvider para reatividade)
final pendingOrdersProvider = Provider<List<OrderEntity>>((ref) {
  final filteredOrders = ref.watch(filteredOrdersProvider);
  return filteredOrders.where((order) => order.status == OrderStatus.pending).toList();
});

/// Provider para pedidos cancelados (baseado em filteredOrdersProvider para reatividade)
final cancelledOrdersProvider = Provider<List<OrderEntity>>((ref) {
  final filteredOrders = ref.watch(filteredOrdersProvider);
  return filteredOrders.where((order) => order.isCancelled).toList();
});

/// Provider para total de receita (baseado em filteredOrdersProvider para reatividade)
final totalRevenueProvider = Provider<double>((ref) {
  final filteredOrders = ref.watch(filteredOrdersProvider);
  return filteredOrders.fold(0.0, (sum, order) => sum + order.total.value);
});

// ===== PROVIDERS PARA FILTROS =====

/// Enum para tipos de filtro de status
enum StatusFilter { all, pending, processing, completed, cancelled }

/// Enum para tipos de filtro de período
enum PeriodFilter { all, today, week, month }

/// Provider para filtro de status selecionado
final selectedStatusFilterProvider = StateProvider<StatusFilter>((ref) {
  return StatusFilter.all;
});

/// Provider para filtro de período selecionado
final selectedPeriodFilterProvider = StateProvider<PeriodFilter>((ref) {
  return PeriodFilter.all;
});

/// Provider combinado que aplica filtros automaticamente
final filteredOrdersProvider = Provider<List<OrderEntity>>((ref) {
  final statusFilter = ref.watch(selectedStatusFilterProvider);
  final periodFilter = ref.watch(selectedPeriodFilterProvider);
  final ordersState = ref.watch(ordersNotifierProvider);
  
  // Garante reatividade observando mudanças no estado completo
  final allOrders = ordersState.allOrders;

  // Aplica filtros combinados
  return _applyActiveFiltersSync(allOrders, statusFilter, periodFilter);
});

/// Função auxiliar para aplicar filtros sincronamente
List<OrderEntity> _applyActiveFiltersSync(
  List<OrderEntity> allOrders,
  StatusFilter statusFilter,
  PeriodFilter periodFilter,
) {
  List<OrderEntity> filteredOrders = List.from(allOrders);

  // Aplica filtro de status
  if (statusFilter != StatusFilter.all) {
    OrderStatus orderStatus;
    switch (statusFilter) {
      case StatusFilter.pending:
        orderStatus = OrderStatus.pending;
        break;
      case StatusFilter.processing:
        orderStatus = OrderStatus.processing;
        break;
      case StatusFilter.completed:
        orderStatus = OrderStatus.completed;
        break;
      case StatusFilter.cancelled:
        orderStatus = OrderStatus.cancelled;
        break;
      case StatusFilter.all:
        // Não deveria chegar aqui
        orderStatus = OrderStatus.pending;
        break;
    }
    
    filteredOrders = filteredOrders
        .where((order) => order.status == orderStatus)
        .toList();
  }

  // Aplica filtro de período
  if (periodFilter != PeriodFilter.all) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;
    
    switch (periodFilter) {
      case PeriodFilter.today:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case PeriodFilter.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        endDate = startDate.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;
      case PeriodFilter.month:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case PeriodFilter.all:
        // Não deveria chegar aqui
        startDate = DateTime.now();
        endDate = DateTime.now();
        break;
    }
    
    filteredOrders = filteredOrders
        .where((order) {
          final orderDate = order.createdAt;
          return orderDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                 orderDate.isBefore(endDate.add(const Duration(days: 1)));
        })
        .toList();
  }

  return filteredOrders;
}
