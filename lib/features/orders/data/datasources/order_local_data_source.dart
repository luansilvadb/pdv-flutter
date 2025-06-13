import 'dart:convert';
import '../models/order_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';

/// Data source local para gerenciar pedidos usando LocalStorage
abstract class OrderLocalDataSource {
  /// Salva um pedido no armazenamento local
  Future<void> saveOrder(OrderModel order);

  /// Obtém todos os pedidos salvos
  Future<List<OrderModel>> getAllOrders();

  /// Obtém um pedido específico por ID
  Future<OrderModel?> getOrderById(String orderId);

  /// Remove um pedido
  Future<void> deleteOrder(String orderId);

  /// Limpa todos os pedidos
  Future<void> clearAllOrders();

  /// Obtém estatísticas dos pedidos
  Future<Map<String, dynamic>> getOrdersStatistics();
}

/// Implementação concreta do data source local
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final LocalStorage localStorage;
  static const String ordersKey = 'cached_orders';

  OrderLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> saveOrder(OrderModel order) async {
    try {
      final orders = await getAllOrders();
      
      // Remove pedido existente com mesmo ID (se houver)
      orders.removeWhere((existingOrder) => existingOrder.id == order.id);
      
      // Adiciona o novo pedido
      orders.add(order);
      
      // Ordena por data de criação (mais recente primeiro)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // Limita a 1000 pedidos para evitar problemas de performance
      if (orders.length > 1000) {
        orders.removeRange(1000, orders.length);
      }
      
      final ordersJson = orders.map((order) => order.toJson()).toList();
      await localStorage.store(ordersKey, json.encode(ordersJson));
    } catch (e) {
      throw CacheException(message: 'Erro ao salvar pedido: $e');
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final ordersString = await localStorage.retrieve<String>(ordersKey);
      if (ordersString == null || ordersString.isEmpty) return [];

      final ordersList = json.decode(ordersString) as List<dynamic>;
      return ordersList
          .map((orderJson) => OrderModel.fromJson(orderJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Erro ao carregar pedidos: $e');
    }
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final orders = await getAllOrders();
      return orders.cast<OrderModel?>().firstWhere(
        (order) => order?.id == orderId,
        orElse: () => null,
      );
    } catch (e) {
      throw CacheException(message: 'Erro ao buscar pedido: $e');
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      final orders = await getAllOrders();
      orders.removeWhere((order) => order.id == orderId);
      
      final ordersJson = orders.map((order) => order.toJson()).toList();
      await localStorage.store(ordersKey, json.encode(ordersJson));
    } catch (e) {
      throw CacheException(message: 'Erro ao remover pedido: $e');
    }
  }

  @override
  Future<void> clearAllOrders() async {
    try {
      await localStorage.delete(ordersKey);
    } catch (e) {
      throw CacheException(message: 'Erro ao limpar pedidos: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getOrdersStatistics() async {
    try {
      final orders = await getAllOrders();
      
      if (orders.isEmpty) {
        return {
          'totalOrders': 0,
          'totalRevenue': 0.0,
          'averageOrderValue': 0.0,
          'completedOrders': 0,
          'pendingOrders': 0,
          'cancelledOrders': 0,
        };
      }
      
      final totalOrders = orders.length;
      final totalRevenue = orders.fold<double>(
        0.0, 
        (sum, order) => sum + order.total.value,
      );
      final averageOrderValue = totalRevenue / totalOrders;
      
      final completedOrders = orders.where((o) => o.isCompleted).length;
      final pendingOrders = orders.where((o) => o.status.name == 'pending').length;
      final cancelledOrders = orders.where((o) => o.isCancelled).length;
      
      return {
        'totalOrders': totalOrders,
        'totalRevenue': totalRevenue,
        'averageOrderValue': averageOrderValue,
        'completedOrders': completedOrders,
        'pendingOrders': pendingOrders,
        'cancelledOrders': cancelledOrders,
      };
    } catch (e) {
      throw CacheException(message: 'Erro ao calcular estatísticas: $e');
    }
  }
}
