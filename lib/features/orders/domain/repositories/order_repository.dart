import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';

/// Repository interface para operações de pedidos
abstract class OrderRepository {
  /// Salva um novo pedido
  Future<Either<Failure, OrderEntity>> saveOrder(OrderEntity order);

  /// Obtém todos os pedidos
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();

  /// Obtém um pedido específico por ID
  Future<Either<Failure, OrderEntity?>> getOrderById(String orderId);

  /// Obtém pedidos por status
  Future<Either<Failure, List<OrderEntity>>> getOrdersByStatus(
    String status,
  );

  /// Obtém pedidos de um período específico
  Future<Either<Failure, List<OrderEntity>>> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Atualiza o status de um pedido
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    String status,
  );

  /// Remove um pedido
  Future<Either<Failure, void>> deleteOrder(String orderId);

  /// Obtém estatísticas de pedidos
  Future<Either<Failure, Map<String, dynamic>>> getOrdersStatistics();
}
