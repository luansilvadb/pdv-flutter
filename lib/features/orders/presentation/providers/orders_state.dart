import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

/// Estado dos pedidos no sistema
class OrdersState extends Equatable {
  final List<OrderEntity> orders;
  final List<OrderEntity> allOrders;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final Map<String, dynamic>? statistics;
  final int currentPage;
  final int pageSize;
  final bool hasMorePages;

  const OrdersState({
    this.orders = const [],
    this.allOrders = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.statistics,
    this.currentPage = 0,
    this.pageSize = 20,
    this.hasMorePages = true,
  });

  /// Cria uma cópia do estado com novos valores
  OrdersState copyWith({
    List<OrderEntity>? orders,
    List<OrderEntity>? allOrders,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    Map<String, dynamic>? statistics,
    int? currentPage,
    int? pageSize,
    bool? hasMorePages,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      allOrders: allOrders ?? this.allOrders,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      statistics: statistics ?? this.statistics,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }

  /// Estado vazio
  static const OrdersState empty = OrdersState();

  /// Verifica se há pedidos
  bool get hasOrders => orders.isNotEmpty;

  /// Verifica se há erro
  bool get hasError => error != null;

  /// Pedidos concluídos
  List<OrderEntity> get completedOrders => 
      orders.where((order) => order.isCompleted).toList();

  /// Pedidos pendentes
  List<OrderEntity> get pendingOrders => 
      orders.where((order) => order.status == OrderStatus.pending).toList();

  /// Pedidos cancelados
  List<OrderEntity> get cancelledOrders => 
      orders.where((order) => order.isCancelled).toList();

  /// Total de receita
  double get totalRevenue => 
      orders.fold(0.0, (sum, order) => sum + order.total.value);
  @override
  List<Object?> get props => [
    orders, 
    allOrders, 
    isLoading, 
    isLoadingMore, 
    error, 
    statistics, 
    currentPage, 
    pageSize, 
    hasMorePages
  ];

  @override
  String toString() => 'OrdersState('
      'orders: ${orders.length}, '
      'allOrders: ${allOrders.length}, '
      'isLoading: $isLoading, '
      'isLoadingMore: $isLoadingMore, '
      'currentPage: $currentPage, '
      'hasMorePages: $hasMorePages, '
      'error: $error'
      ')';
}
