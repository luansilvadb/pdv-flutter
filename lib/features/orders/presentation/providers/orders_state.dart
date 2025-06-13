import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

/// Estado dos pedidos no sistema
class OrdersState extends Equatable {
  final List<OrderEntity> orders;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? statistics;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
    this.statistics,
  });

  /// Cria uma cópia do estado com novos valores
  OrdersState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? statistics,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      statistics: statistics ?? this.statistics,
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
  List<Object?> get props => [orders, isLoading, error, statistics];

  @override
  String toString() => 'OrdersState('
      'orders: ${orders.length}, '
      'isLoading: $isLoading, '
      'error: $error'
      ')';
}
